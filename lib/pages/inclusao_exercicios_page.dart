import 'package:flutter/material.dart';
import 'package:training_planning_app/widgets/criarbarradias.dart';

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
          child: Icon(Icons.save),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _nomeExercicioController,
                  decoration: InputDecoration(labelText: 'Nome do Exercício'),
                ),
              ),
              SizedBox(width: 10),
              SizedBox(
                width: 80,
                child: TextField(
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
                child: TextField(
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
                items: ['8', '10', '12', '15+']
                    .map<DropdownMenuItem<String>>((String value) {
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
    );
  }

  void _salvarExercicio() {
    print('Salvo');
;
  }
}
