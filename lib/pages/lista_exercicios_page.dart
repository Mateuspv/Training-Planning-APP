import 'package:flutter/material.dart';
import 'package:training_planning_app/pages/inclusao_exercicios_page.dart';
import 'package:training_planning_app/widgets/criarbarradias.dart';
import '../dao/exercicios_dao.dart';
import '../model/exercicios.dart';
import 'filtro_page.dart';

class ListaExerciciosPage extends StatefulWidget {
  @override
  _ListaExerciciosPageState createState() => _ListaExerciciosPageState();
}

class _ListaExerciciosPageState extends State<ListaExerciciosPage> {
  final _dao = ExerciciosDao();
  List<Exercicio> _exercicios = [];
  int _diaSelecionado = DateTime.now().weekday % 7;

  @override
  void initState() {
    super.initState();
    _carregarExercicios();
  }

  void _carregarExercicios() async {
    final exercicios = await _dao.listar();
    setState(() {
      _exercicios = exercicios.where((e) => (e.dia % 7) == _diaSelecionado).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _criarAppBar(),
      body: Column(
        children: [
          CriarBarraDias(
            diaSelecionado: _diaSelecionado,
            onDiaSelecionado: (index) {
              setState(() {
                _diaSelecionado = index;
              });
              _carregarExercicios();
            },
          ),
          Expanded(child: _criarBody()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _adicionarExercicio,
        child: Icon(Icons.add),
      ),
    );
  }

  AppBar _criarAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.green,
      title: const Text('Lista de Exercícios'),
      actions: [
        IconButton(
          onPressed: _abrirFiltro,
          icon: Icon(Icons.filter_list),
        ),
      ],
    );
  }

  Widget _criarBody() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: _exercicios.isEmpty
          ? Center(child: Text('Nenhum exercício cadastrado'))
          : ListView.builder(
        itemCount: _exercicios.length,
          itemBuilder: (context, index) {
            final exercicio = _exercicios[index];
            return Dismissible(
              key: Key(exercicio.id.toString()),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (direction) async {
                final id = exercicio.id;
                if (id != null) {
                  await _dao.remover(id);
                  setState(() {
                    _exercicios.removeAt(index);
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Exercício "${exercicio.exercicio}" removido')),
                  );
                }
              },
              child: Card(
                child: ListTile(
                  title: Text(exercicio.exercicio),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Peso: ${exercicio.peso} | Reps: ${exercicio.repeticao}'),
                      if (exercicio.observacao?.isNotEmpty == true)
                        Text('Obs: ${exercicio.observacao}'),
                    ],
                  ),
                ),
              ),
            );
          }
      ),
    );
  }

  void _abrirFiltro() {
    Navigator.of(context).pushNamed(FiltroPage.ROUTE_NAME).then((alterouValores) {
      if (alterouValores == true) {
        setState(() {});
      }
    });
  }

  void _adicionarExercicio() {
    Navigator.of(context)
        .pushNamed(InclusaoExerciciosPage.ROUTE_NAME)
        .then((_) => _carregarExercicios());
  }


}
