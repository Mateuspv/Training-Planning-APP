import 'package:flutter/material.dart';

import '../services/nutritionx_service.dart';
import '../services/translator_service.dart';


class AlimentosPage extends StatefulWidget {

  static const ROUTE_NAME = '/alimentos';

  @override
  _AlimentosPageState createState() => _AlimentosPageState();
}

class _AlimentosPageState extends State<AlimentosPage> {
  final _controller = TextEditingController();
  final _service = NutritionixService();
  final _translator = TranslatorService();
  Map<String, dynamic>? _resultado;
  bool _carregando = false;

  Future<void> _buscarAlimento() async {
    final query = _controller.text.trim();
    if (query.isEmpty) return;

    setState(() => _carregando = true);

    final traducao = await _translator.traduzirParaIngles(query);
    if (traducao == null) {
      setState(() => _carregando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao traduzir com Google.')),
      );
      return;
    }

    final alimento = await _service.buscarAlimento(traducao);

    setState(() {
      _resultado = alimento;
      _carregando = false;
    });

    if (alimento == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Alimento não encontrado.')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consulta de Alimentos'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Digite um alimento',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _buscarAlimento,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _carregando
                ? CircularProgressIndicator()
                : _resultado != null
                ? Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Calorias: ${_resultado!['nf_calories']} kcal'),
                    Text('Proteínas: ${_resultado!['nf_protein']} g'),
                    Text('Carboidratos: ${_resultado!['nf_total_carbohydrate']} g'),
                    Text('Gorduras: ${_resultado!['nf_total_fat']} g'),
                  ],
                ),
              ),
            )
                : Text('Nenhuma informação exibida.'),
          ],
        ),
      ),
    );
  }
}
