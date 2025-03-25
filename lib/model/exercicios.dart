import 'package:intl/intl.dart';

class Exercicio{
  static const CAMPO_ID = '_id';
  static const CAMPO_REPETICOES = 'repeticoes';
  static const CAMPO_PESO = 'peso';
  static const CAMPO_OBS = 'observacao';
  static const CAMPO_DIA = 'dia';
  static const CAMPO_SEMANA= 'semana';
  static const LOCAL_ACADEMIA = 'localAcademia';

  int id;
  String repeticao;
  String peso;
  String? observacao;
  DateTime dia;
  DateTime semana;
  String? localAcademia;

  Exercicio({required this.id, required this.repeticao, required this.peso, this.observacao, required this.dia, required this.semana, this.localAcademia});

  String get diaFormatado{
    return DateFormat('dd/MM/yyyy').format(dia);
  }

  String get semanaFormatado{
    return DateFormat('dd/MM/yyyy').format(semana);
  }

}