import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/bar.dart'; // Ensure your Bar widget is imported correctly

class SelectionSortPage extends StatefulWidget {
  @override
  _SelectionSortPageState createState() => _SelectionSortPageState();
}

class _SelectionSortPageState extends State<SelectionSortPage> {
  List<int> _array = [];
  List<List<int>> _steps = [];
  bool _isSorting = false;
  int _currentStep = 0;
  int _minIndex = -1; // Track the index of the minimum value

  final _arrayController = TextEditingController();

  // Selection sort implementation with steps tracking
  void _selectionSort() {
    List<int> arr = List.from(_array);
    for (int i = 0; i < arr.length - 1; i++) {
      int minIndex = i; // Start with the first element as the minimum

      // Save the current state at the beginning of each outer loop iteration
      _steps.add(List.from(arr));

      for (int j = i + 1; j < arr.length; j++) {
        if (arr[j] < arr[minIndex]) {
          minIndex = j; // Update the minimum index
        }
        // Save the current state after checking
        _steps.add(List.from(arr));
      }

      // Highlight the minimum index after the inner loop
      _minIndex = minIndex;

      // Swap if the minimum index is not the current index
      if (minIndex != i) {
        int temp = arr[i];
        arr[i] = arr[minIndex];
        arr[minIndex] = temp;
      }

      // Save the state after the swap
      _steps.add(List.from(arr));
    }
  }

  // Parse the array input
  void _parseArrayInput(String input) {
    List<int> array = input.split(',').map((e) => int.tryParse(e.trim()) ?? 0).toList();
    setState(() {
      _array = array;
      _steps = [List.from(array)];
      _currentStep = 0;
      _minIndex = -1; // Reset min index
    });
  }

  // Animation for sorting visualization
  Future<void> _startSortingVisualization() async {
    setState(() {
      _isSorting = true;
      _steps = [];
    });

    // First, generate the steps by sorting the array
    _selectionSort();

    // Animate the sorting process
    for (int i = 0; i < _steps.length; i++) {
      await Future.delayed(Duration(milliseconds: 500));
      setState(() {
        _currentStep = i;
      });
    }

    setState(() {
      _isSorting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final maxValue = _array.isNotEmpty ? _array.reduce((a, b) => a > b ? a : b) : 1;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Selection Sort Visualization'),
          backgroundColor: Colors.indigo,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Input field for array
              TextFormField(
                controller: _arrayController,
                decoration: InputDecoration(
                  labelText: 'Enter array (comma separated)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
                onFieldSubmitted: (value) {
                  _parseArrayInput(value);
                },
              ),
              SizedBox(height: 20),

              // Display the Selection Sort code
              Text(
                'Selection Sort Code:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Container(
                height: 120, // Set fixed height for scrollable code area
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.grey[200],
                    child: Text(
                      '''
for (int i = 0; i < arr.length - 1; i++) {
  int minIndex = i;
  for (int j = i + 1; j < arr.length; j++) {
    if (arr[j] < arr[minIndex]) {
      minIndex = j;
    }
  }
  int temp = arr[i];
  arr[i] = arr[minIndex];
  arr[minIndex] = temp;
}
                      ''',
                      style: TextStyle(fontFamily: 'Courier'),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Display sorting steps with bar animation
              Text(
                'Array Visualization:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              // Bar visualization of array
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _steps.isNotEmpty
                      ? _steps[_currentStep].asMap().entries.map((entry) {
                    int index = entry.key;
                    int value = entry.value;
                    // Highlight the current minimum index
                    bool isMin = index == _minIndex;
                    return Bar(
                      value: value,
                      maxValue: maxValue,
                      color: isMin ? Colors.red : Colors.blue, // Highlight min index in red
                    );
                  }).toList()
                      : [],
                ),
              ),

              SizedBox(height: 20),

              // Sorting Control Buttons
              Center(
                child: ElevatedButton(
                  onPressed: _isSorting ? null : _startSortingVisualization, // Disable button during sorting
                  child: Text('Start Sorting Animation'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
