import 'dart:async';
import 'package:flutter/material.dart';
import 'bar.dart'; // Ensure you have the Bar widget properly defined

class SortingPage extends StatefulWidget {
  @override
  _SortingPageState createState() => _SortingPageState();
}

class _SortingPageState extends State<SortingPage> {
  List<int> _array = [];
  List<List<int>> _steps = [];
  bool _isSorting = false;
  int _currentStep = 0;

  final _arrayController = TextEditingController();

  // Bubble sort implementation with steps tracking
  void _bubbleSort() {
    setState(() {
      _isSorting = true;
      _steps = [];
    });

    List<int> arr = List.from(_array);
    for (int i = 0; i < arr.length - 1; i++) {
      for (int j = 0; j < arr.length - i - 1; j++) {
        if (arr[j] > arr[j + 1]) {
          int temp = arr[j];
          arr[j] = arr[j + 1];
          arr[j + 1] = temp;

          // Add the current state of the array to the steps for visualization
          _steps.add(List.from(arr));
        }
      }
    }

    // After sorting is complete
    setState(() {
      _isSorting = false;
    });
  }

  // Parse the array input
  void _parseArrayInput(String input) {
    List<int> array = input.split(',').map((e) => int.tryParse(e.trim()) ?? 0).toList();
    setState(() {
      _array = array;
      _steps = [List.from(array)];
      _currentStep = 0;
    });
  }

  // Animation for sorting visualization
  Future<void> _startSortingVisualization() async {
    for (int i = 0; i < _steps.length; i++) {
      await Future.delayed(Duration(milliseconds: 500));
      setState(() {
        _currentStep = i;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxValue = _array.isNotEmpty ? _array.reduce((a, b) => a > b ? a : b) : 1;

    return Scaffold(
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

            // Display the Bubble Sort code
            Text(
              'Bubble Sort Code:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Container(
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
            SizedBox(height: 20),

            // Display sorting steps with bar animation
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                          ? _steps[_currentStep].map((e) {
                        return Bar(
                          value: e,
                          maxValue: maxValue,
                          color: Colors.blue,
                        );
                      }).toList()
                          : [],
                    ),
                  ),

                  SizedBox(height: 20),

                  // Sorting Control Buttons
                  if (_isSorting)
                    CircularProgressIndicator()
                  else
                    ElevatedButton(
                      onPressed: _startSortingVisualization,
                      child: Text('Start Sorting Animation'),
                    ),
                ],
              ),
            ),

            // Button to trigger sorting
            Center(
              child: ElevatedButton(
                onPressed: _bubbleSort,
                child: Text('Generate Steps'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
