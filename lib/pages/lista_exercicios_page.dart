import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:training_planning_app/pages/Alimento_page.dart';
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
    final prefs = await SharedPreferences.getInstance();
    final tipoTreino = prefs.getString(FiltroPage.CHAVE_CAMPO_DIA) ?? '';

    final todosExercicios = await _dao.listar();

    setState(() {
      if (tipoTreino == Exercicio.CAMPO_DIA) {
        _exercicios = todosExercicios
            .where((e) => (e.dia % 7) == _diaSelecionado)
            .toList();
      } else if (tipoTreino == Exercicio.CAMPO_SEMANA) {
        final hojeFormatado = DateFormat('dd/MM/yyyy').format(DateTime.now());

        _exercicios = todosExercicios.where((e) {
          final dataExercicio = e.semana != null
              ? DateFormat('dd/MM/yyyy').format(e.semana!)
              : '';
          return dataExercicio == hojeFormatado;
        }).toList();
      } else {
        _exercicios = todosExercicios;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _criarAppBar(),
      body: Stack(
        children: [
          Column(
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
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 56),
              child: ElevatedButton(
                onPressed: _checarLocalizacaoAcademia,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Checar Academia',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),

        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16, left: 40.0, right: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              heroTag: "abrirAlimentos",
              onPressed: _abrirPaginaDieta,
              backgroundColor: Colors.green,
              child: const Icon(Icons.restaurant_menu),
              tooltip: "Abrir Alimentos/Dieta",
            ),
            FloatingActionButton(
              heroTag: "adicionarExercicio",
              onPressed: _adicionarExercicio,
              backgroundColor: Colors.green,
              child: const Icon(Icons.add),
              tooltip: "Adicionar Exercício",
            ),
          ],
        ),
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

  void _abrirPaginaDieta() {
    Navigator.of(context).pushNamed(AlimentosPage.ROUTE_NAME).then((alterouValores) {
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

  void _checarLocalizacaoAcademia() async {
    final prefs = await SharedPreferences.getInstance();
    final localString = prefs.getString(FiltroPage.CHAVE_LOCAL_ACADEMIA);

    if (localString == null || !localString.contains(',')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Local da academia não configurado.')),
      );
      return;
    }

    final partes = localString.split(',');
    final latAcademia = double.tryParse(partes[0]);
    final lngAcademia = double.tryParse(partes[1]);

    if (latAcademia == null || lngAcademia == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Local da academia inválido.')),
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Permissão de localização negada.')),
        );
        return;
      }
    }

    final posicaoAtual = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final distancia = Geolocator.distanceBetween(
      posicaoAtual.latitude,
      posicaoAtual.longitude,
      latAcademia,
      lngAcademia,
    );

    final dentroDoRaio = distancia <= 100;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Resultado da Verificação'),
          content: Text(dentroDoRaio
              ? '✅ Você está perto da academia! 🎯'
              : '🚫 Você está longe da academia.\nDistância: ${distancia.toStringAsFixed(0)} metros.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );

  }



}
