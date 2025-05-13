import 'package:flutter/material.dart';
import 'package:training_planning_app/widgets/criarbarradias.dart';

import '../dao/exercicios_dao.dart';
import '../model/exercicios.dart';

class InclusaoExerciciosPage extends StatefulWidget {
  static const ROUTE_NAME = '/inclusao';

  @override
  _InclusaoExerciciosPageState createState() => _InclusaoExerciciosPageState();
}

class _InclusaoExerciciosPageState extends State<InclusaoExerciciosPage> {
  int _diaSelecionado = DateTime.now().weekday % 7;
  bool _alterouValores = false;
  final TextEditingController _nomeExercicioController = TextEditingController();
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _observacaoController = TextEditingController();
  String _repeticoesSelecionadas = '8';
  final _dao = ExerciciosDao();
  var _carregando = false;

  // Se precisar usar dadosValidados e novaTarefa, precisa declarar uma key e form associada.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _atualizarLista();
  }

  void _atualizarLista() async {
    setState(() {
      _carregando = true;
    });

    // Simula algum carregamento se necessário
    await Future.delayed(Duration(milliseconds: 300));

    setState(() {
      _carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onVoltarClick,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Colors.green,
          title: const Text('Inclusão de Exercícios'),
        ),
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
          onPressed: _salvarExercicio,
          child: const Icon(Icons.save),
        ),
      ),
    );
  }

  Future<bool> _onVoltarClick() async {
    Navigator.of(context).pop(_alterouValores);
    return true;
  }

  Widget _criarBody() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _nomeExercicioController,
                    decoration: InputDecoration(labelText: 'Nome do Exercício'),
                    validator: (value) =>
                    value == null || value.isEmpty ? 'Campo obrigatório' : null,
                  ),
                ),
                SizedBox(width: 10),
                SizedBox(
                  width: 80,
                  child: TextFormField(
                    controller: _pesoController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Peso (kg)'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _observacaoController,
                    decoration: InputDecoration(labelText: 'Observação'),
                  ),
                ),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: _repeticoesSelecionadas,
                  onChanged: (String? newValue) {
                    setState(() {
                      _repeticoesSelecionadas = newValue!;
                    });
                  },
                  items: ['8', '10', '12', '15+'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _salvarExercicio() {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      final novoExercicio = Exercicio(
        exercicio: _nomeExercicioController.text,
        repeticao: _repeticoesSelecionadas,
        peso: _pesoController.text,
        observacao: _observacaoController.text,
        dia: _diaSelecionado == 0 ? 7 : _diaSelecionado,
        semana: DateTime.now(),
      );

      _dao.salvar(novoExercicio).then((success) {
        if (success) {
          setState(() {
            _alterouValores = true;
          });
          Navigator.of(context).pop(true);
        }
      });
    }
  }
}
