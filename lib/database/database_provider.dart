
import 'package:sqflite/sqflite.dart';

import '../model/exercicios.dart';


class DatabaseProvider {

  static const _dbNome = 'cadastro_exercicios.db';
  static const _dbVersion = 1;

  DatabaseProvider._init();

  static final DatabaseProvider instance = DatabaseProvider._init();

  Database? _database;

  Future<Database> get database async{
    if (_database == null){
      _database = await _initDataBase();
    }
    return _database!;
  }

  Future<Database> _initDataBase() async {
    String databasePath = await getDatabasesPath();
    String dbPath = '${databasePath}/${_dbNome}';
    return await openDatabase(
      dbPath,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async{
    await db.execute('''
    CREATE TABLE ${Exercicio.nomeTabela}(
    ${Exercicio.CAMPO_ID} INTEGER PRIMARY KEY AUTOINCREMENT,
     ${Exercicio.CAMPO_EXERCICIO} TEXT NOT NULL,
    ${Exercicio.CAMPO_PESO} TEXT NOT NULL,
    ${Exercicio.CAMPO_REPETICOES} TEXT NOT NULL,
    ${Exercicio.CAMPO_DIA} INTEGER NOT NULL,
    ${Exercicio.CAMPO_SEMANA} TEXT,
    ${Exercicio.CAMPO_OBS} TEXT,
    ${Exercicio.LOCAL_ACADEMIA} TEXT
    );
    ''');
  }

  Future<void> _onUpgrade( Database db, int oldVersion, int newVersion) async {
  }

  Future<void> close() async {
    if(_database != null){
      await _database!.close();
    }
  }
}