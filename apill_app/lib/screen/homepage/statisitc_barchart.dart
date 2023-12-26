import 'package:flutter/material.dart';

class HomeBarChart extends StatelessWidget {
  const HomeBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StackedBar(flex: 1, color: Colors.red),
        StackedBar(flex: 1, color: Colors.orange),
        StackedBar(flex: 1, color: Colors.yellow),
        StackedBar(flex: 1, color: Colors.green),
        StackedBar(flex: 1, color: Colors.blue),
        StackedBar(flex: 1, color: Colors.black),
      ],
    );
  }
}

class StackedBar extends StatelessWidget {
  final Color color;
  final int flex;

  const StackedBar({required this.color, required this.flex});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
        height: 28.0, // Adjust the height as needed
        color: color,
      ),
    );
  }
}