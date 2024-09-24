import 'package:flutter/material.dart';

class MergeSortTree extends StatelessWidget {
  final List<List<int>> steps; // Steps showing the current state of the array during sorting
  final int currentStep; // Current step for visualization

  MergeSortTree({
    required this.steps,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _buildTree(steps, currentStep),
    );
  }

  List<Widget> _buildTree(List<List<int>> steps, int step) {
    if (step >= steps.length) return [];

    List<int> currentValues = steps[step];

    // Create a widget for the current level
    List<Widget> widgets = [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: currentValues.map((value) {
          Color color = (currentValues == steps.last) ? Colors.green : Colors.blue;
          return Container(
            margin: const EdgeInsets.all(4),
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                value.toString(),
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }).toList(),
      ),
    ];

    // Determine how to split the array for the next level
    if (currentValues.length > 1) {
      int mid = currentValues.length ~/ 2;

      // Create branches for left and right
      widgets.add(SizedBox(height: 20)); // Space between rows
      widgets.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Left branch
          Container(
            height: 20,
            width: 2,
            color: Colors.black,
          ),
          SizedBox(width: 30), // Space between branches
          // Right branch
          Container(
            height: 20,
            width: 2,
            color: Colors.black,
          ),
        ],
      ));

      // Add the next level of the tree
      widgets.add(SizedBox(height: 20)); // Space between levels
      widgets.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Build left subtree
          Expanded(
            child: Column(
              children: _buildTree(steps, step + 1), // Recursively show left subtree
            ),
          ),
          SizedBox(width: 20), // Space between subtrees
          // Build right subtree
          Expanded(
            child: Column(
              children: _buildTree(steps, step + 1), // Recursively show right subtree
            ),
          ),
        ],
      ));
    }

    return widgets;
  }
}
