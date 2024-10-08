import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/bar.dart'; // Ensure you have the Bar widget properly defined

class SortingPage extends StatefulWidget {
  @override
  _SortingPageState createState() => _SortingPageState();
}

class _SortingPageState extends State<SortingPage> {
  List<int> _array = [];
  List<List<int>> _steps = [];
  List<List<int>> _swapIndices = [];  // Track indices of swapped elements
  bool _isSorting = false;
  int _currentStep = 0;

  final _arrayController = TextEditingController();

  // Bubble sort implementation with steps tracking and swap highlighting
  void _bubbleSort() {
    List<int> arr = List.from(_array);
    for (int i = 0; i < arr.length - 1; i++) {
      for (int j = 0; j < arr.length - i - 1; j++) {
        if (arr[j] > arr[j + 1]) {
          int temp = arr[j];
          arr[j] = arr[j + 1];
          arr[j + 1] = temp;

          // Add the current state of the array and the swapped indices
          _steps.add(List.from(arr));
          _swapIndices.add([j, j + 1]);  // Track which bars were swapped
        }
      }
    }
  }

  // Parse the array input
  void _parseArrayInput(String input) {
    List<int> array = input.split(',').map((e) => int.tryParse(e.trim()) ?? 0).toList();
    setState(() {
      _array = array;
      _steps = [List.from(array)];
      _swapIndices = [[-1, -1]];  // No swaps initially
      _currentStep = 0;
    });
  }

  // Animation for sorting visualization
  Future<void> _startSortingVisualization() async {
    setState(() {
      _isSorting = true;
      _steps = [];
      _swapIndices = [];
    });

    // First, generate the steps by sorting the array
    _bubbleSort();

    // Now, animate the sorting process
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
          title: Text('Bubble Sort Visualization'),
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

              // Scrollable section for the Bubble Sort code
              Text(
                'Bubble Sort Code:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              // Making the code scrollable with a limited height
              Container(
                height: 120, // Set fixed height for scrollable code area
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.grey[200],
                    child: Text(
                      '''
for (int i = 0; i < arr.length - 1; i++) {
  for (int j = 0; j < arr.length - i - 1; j++) {
    if (arr[j] > arr[j + 1]) {
      int temp = arr[j];
      arr[j] = arr[j + 1];
      arr[j + 1] = temp;
    }
  }
}
                      ''',
                      style: TextStyle(fontSize: 16, fontFamily: 'Courier'),
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

                    // Highlight the bars that are being swapped
                    Color barColor = _swapIndices[_currentStep].contains(index)
                        ? Colors.red  // Color for the swapped bars
                        : Colors.blue;

                    return Bar(
                      value: value,
                      maxValue: maxValue,
                      color: barColor,
                    );
                  }).toList()
                      : [],
                ),
              ),

              SizedBox(height: 20),

              // Sorting Control Buttons
              Center(
                child: ElevatedButton(
                  onPressed: _isSorting ? null : _startSortingVisualization,
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
