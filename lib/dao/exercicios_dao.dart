import '../database/database_provider.dart';
import '../model/exercicios.dart';

class ExerciciosDao{
  final dbProvider = DatabaseProvider.instance;

  Future<bool> salvar(Exercicio exercicio) async{
    final db = await dbProvider.database;
    final valores = exercicio.toMap();
    if (exercicio.id == null){
      exercicio.id = await db.insert(Exercicio.nomeTabela, valores);
      return true;
    }else{
      final registrosAtualizados = await db.update(Exercicio.nomeTabela, valores,
          where: '${Exercicio.CAMPO_ID} = ?', whereArgs: [exercicio.id]);
      return registrosAtualizados > 0;
    }
  }

  Future<bool> remover (int id) async{
    final db = await dbProvider.database;
    final registrosAtualizados = await db.delete(Exercicio.nomeTabela,
        where:  '${Exercicio.CAMPO_ID} = ?', whereArgs: [id]);
    return registrosAtualizados > 0;
  }

  Future<List<Exercicio>> listar({
    String filtro = '',
  }) async{
    String? where;
    if (filtro.isNotEmpty){
      where = "UPPER(${Exercicio.CAMPO_EXERCICIO}) LIKE '${filtro.toUpperCase()}'";
    }

    final db = await dbProvider.database;
    final resultado = await db.query(Exercicio.nomeTabela,
      columns: [
        Exercicio.CAMPO_ID,
        Exercicio.CAMPO_EXERCICIO,
        Exercicio.CAMPO_REPETICOES,
        Exercicio.CAMPO_PESO,
        Exercicio.CAMPO_OBS,
        Exercicio.CAMPO_DIA,
        Exercicio.CAMPO_SEMANA,
      ],
      where: where,
    );
    return resultado.map((m) => Exercicio.fromMap(m)).toList();
  }
}