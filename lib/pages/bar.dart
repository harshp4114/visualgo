import 'package:flutter/material.dart';

class Bar extends StatelessWidget {
  final int value;
  final int maxValue;
  final Color color;

  Bar({required this.value, required this.maxValue, required this.color});

  @override
  Widget build(BuildContext context) {
    double barHeight = (value / maxValue) * 150;  // Normalize height

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Display the value on top of the bar
        Text(
          value.toString(),
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),

        // The actual bar
        Container(
          height: barHeight,
          width: 20,
          color: color,
        ),
      ],
    );
  }
}
