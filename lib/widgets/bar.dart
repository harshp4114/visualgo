import 'package:flutter/material.dart';

class Bar extends StatelessWidget {
  final int value;
  final int maxValue;
  final Color color;

  Bar({required this.value, required this.maxValue, required this.color});

  @override
  Widget build(BuildContext context) {
    // Normalize bar height based on the max value
    double barHeightPercentage = (value / maxValue);

    return Flexible(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Display the value on top of the bar
          Text(
            value.toString(),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),

          // Bar container, flexible and responsive to screen size
          Expanded(
            child: FractionallySizedBox(
              heightFactor: barHeightPercentage, // Responsive bar height
              alignment: Alignment.bottomCenter,
              child: Container(
                width: 20,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}