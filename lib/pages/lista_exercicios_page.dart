import 'package:flutter/material.dart';
import 'package:training_planning_app/pages/inclusao_exercicios_page.dart';
import 'package:training_planning_app/widgets/criarbarradias.dart';
import 'filtro_page.dart';

class ListaExerciciosPage extends StatefulWidget {
  @override
  _ListaExerciciosPageState createState() => _ListaExerciciosPageState();
}

class _ListaExerciciosPageState extends State<ListaExerciciosPage> {
  final List<String> _exercicios = ['Exercício Teste'];
  int _diaSelecionado = DateTime.now().weekday % 7;

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
          return Card(
            child: ListTile(
              title: Text(_exercicios[index]),
            ),
          );
        },
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
    Navigator.of(context).pushNamed(InclusaoExerciciosPage.ROUTE_NAME).then((resultado) {
      if (resultado != null && resultado is String) {
        setState(() {
          _exercicios.add(resultado);
        });
      }
    });
  }
}
