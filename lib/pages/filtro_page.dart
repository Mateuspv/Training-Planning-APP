import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/exercicios.dart';
import 'mapa_selecao_page.dart';

class FiltroPage extends StatefulWidget {
  static const ROUTE_NAME = '/filtro';
  static const CHAVE_CAMPO_DIA = 'campoDIa';
  static const CHAVE_CAMPO_SEMANA = 'campoSemana';
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
  String _tipoTreinoSelecionado = '';
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
      _tipoTreinoSelecionado = prefs.getString(FiltroPage.CHAVE_CAMPO_DIA) ?? '';
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
                groupValue: _tipoTreinoSelecionado,
                onChanged: _onTipoTreinoChange,
              ),
              Text(camposConfiguracaoTreino[campo] ?? ''),
            ],
          ),
        if (_localAcademia.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
            child: Text(
              'Local da academia: $_localAcademia',
              style: TextStyle(color: Colors.black54, fontSize: 12),
            ),
          ),
      ],
    );
  }


  Future<bool> _onVoltarClick() async {
    Navigator.of(context).pop(_alterouValores);
    return true;
  }

  void _onTipoTreinoChange(String? valor) {
    prefs.setString(FiltroPage.CHAVE_CAMPO_DIA, valor ?? '');
    _alterouValores = true;
    setState(() {
      _tipoTreinoSelecionado = valor ?? '';
    });
  }

  void _buscarLocalizacao() async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapaSelecaoPage(),
      ),
    );

    if (resultado != null && resultado is LatLng) {
      final latitude = resultado.latitude.toString();
      final longitude = resultado.longitude.toString();
      final local = '$latitude,$longitude';

      setState(() {
        _localAcademia = local;
        _alterouValores = true;
      });

      prefs.setString(FiltroPage.CHAVE_LOCAL_ACADEMIA, local);
    }
  }
}