import 'package:flutter/material.dart';
import 'package:training_planning_app/pages/Alimento_page.dart';
import 'package:training_planning_app/pages/filtro_page.dart';
import 'package:training_planning_app/pages/inclusao_exercicios_page.dart';
import 'package:training_planning_app/pages/lista_exercicios_page.dart';

void main() {
  runApp(const MyApp());

}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'APP Training Planing',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: ListaExerciciosPage(),
        routes: {
          FiltroPage.ROUTE_NAME: (BuildContext context) => FiltroPage(),
          InclusaoExerciciosPage.ROUTE_NAME: (BuildContext context) => InclusaoExerciciosPage(),
          AlimentosPage.ROUTE_NAME: (BuildContext context) => AlimentosPage(),
        }
    );
  }
}

