import 'package:intl/intl.dart';

class Exercicio{
  static const CAMPO_ID = '_id';
  static const CAMPO_EXERCICIO = 'exercicio';
  static const CAMPO_REPETICOES = 'repeticoes';
  static const CAMPO_PESO = 'peso';
  static const CAMPO_OBS = 'observacao';
  static const CAMPO_DIA = 'dia';
  static const CAMPO_SEMANA= 'semana';
  static const LOCAL_ACADEMIA = 'localAcademia';
  static const nomeTabela = 'exercicio';

  int? id;
  String exercicio;
  String repeticao;
  String peso;
  String? observacao;
  int dia;
  DateTime? semana;
  String? localAcademia;

  Exercicio({this.id, required this.exercicio, required this.repeticao, required this.peso, this.observacao, required this.dia, this.semana, this.localAcademia});

  String get semanaFormatado{
    return DateFormat('dd/MM/yyyy').format(semana!);
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
    CAMPO_ID : id,
    CAMPO_REPETICOES: repeticao,
    CAMPO_EXERCICIO: exercicio,
    CAMPO_PESO: peso,
    CAMPO_OBS: observacao,
    CAMPO_DIA: dia,
    CAMPO_SEMANA: semana !=null ? DateFormat("dd/MM/yyyy").format(semana!): null,
    LOCAL_ACADEMIA: localAcademia != null ? null : null
  };

  factory Exercicio.fromMap(Map<String, dynamic> map) => Exercicio(
    id: map[CAMPO_ID] is int ? map[CAMPO_ID] : null,
    exercicio: map[CAMPO_EXERCICIO]?.toString() ?? "",
    repeticao: map[CAMPO_REPETICOES]?.toString() ?? "",
    peso: map[CAMPO_PESO]?.toString() ?? "",
    observacao: map[CAMPO_OBS]?.toString() ?? "",
    dia: map[CAMPO_DIA] is int ? map[CAMPO_DIA] : 0,
    semana: map[CAMPO_SEMANA] is String
        ? DateFormat("dd/MM/yyyy").parse(map[CAMPO_SEMANA])
        : DateTime.now(),
  );




}