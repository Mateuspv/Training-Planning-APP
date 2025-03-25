import 'package:flutter/material.dart';

class CriarBarraDias extends StatelessWidget {
  final int diaSelecionado;
  final Function(int) onDiaSelecionado;
  final List<String> _diasSemana = ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'];

  CriarBarraDias({required this.diaSelecionado, required this.onDiaSelecionado});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(7, (index) {
          bool selecionado = diaSelecionado == index;
          return GestureDetector(
            onTap: () => onDiaSelecionado(index),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: selecionado ? Colors.green : Colors.grey[300],
              child: Text(
                _diasSemana[index],
                style: TextStyle(
                  color: selecionado ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}