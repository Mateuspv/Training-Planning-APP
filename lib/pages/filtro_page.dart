import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/exercicios.dart';

class FiltroPage extends StatefulWidget {
  static const ROUTE_NAME = '/filtro';
  static const CHAVE_CAMPO_DIA = 'campoDIa';
  static const CHAVE_ORDENAR_SEMANA = 'campoSemana';
  static const CHAVE_LOCAL_ACADEMIA = 'localAcademia';

  @override
  _FiltroPageState createState() => _FiltroPageState();
}

class _FiltroPageState extends State<FiltroPage> {
  final camposConfiguracaoTreino = {
    Exercicio.CAMPO_DIA: 'Treino diário',
    Exercicio.CAMPO_SEMANA: 'Treino Semanal',
  };

  late final SharedPreferences prefs;
  String _usarTreinoDiario = '';
  String _usarTreinoSemana = '';
  String _localAcademia = '';
  bool _alterouValores = false;

  @override
  void initState() {
    super.initState();
    _carregarSharedPreferences();
  }

  void _carregarSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _usarTreinoDiario = prefs.getString(FiltroPage.CHAVE_CAMPO_DIA) ?? '';
      _usarTreinoSemana = prefs.getString(FiltroPage.CHAVE_ORDENAR_SEMANA) ?? '';
      _localAcademia = prefs.getString(FiltroPage.CHAVE_LOCAL_ACADEMIA) ?? '';
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
          title: const Text('Configurações'),
        ),
        body: Stack(
          children: [
            _criaBody(),
            Positioned(
              bottom: 50,
              right: 15,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Academia',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  FloatingActionButton(
                    onPressed: _buscarLocalizacao,
                    child: const Icon(Icons.gps_fixed),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _criaBody() {
    return ListView(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 10, top: 10),
          child: Text('Configuração de treino'),
        ),
        for (final campo in camposConfiguracaoTreino.keys)
          Row(
            children: [
              Radio(
                value: campo,
                groupValue: _usarTreinoDiario,
                onChanged: _onTreinoDiarioChange,
              ),
              Text(camposConfiguracaoTreino[campo] ?? ''),
            ],
          ),
      ],
    );
  }

  Future<bool> _onVoltarClick() async {
    Navigator.of(context).pop(_alterouValores);
    return true;
  }

  void _onTreinoDiarioChange(String? valor) {
    prefs.setString(FiltroPage.CHAVE_CAMPO_DIA, valor ?? '');
    _alterouValores = true;
    setState(() {
      _usarTreinoDiario = valor ?? '';
    });
  }

  void _buscarLocalizacao() {
    print('');
  }
}