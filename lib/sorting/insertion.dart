import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/bar.dart'; // Ensure your Bar widget is imported correctly

class InsertionSortPage extends StatefulWidget {
  @override
  _InsertionSortPageState createState() => _InsertionSortPageState();
}

class _InsertionSortPageState extends State<InsertionSortPage> {
  List<int> _array = [];
  List<List<int>> _steps = [];
  bool _isSorting = false;
  int _currentStep = 0;
  int _keyIndex = -1; // Track the index of the key being compared

  final _arrayController = TextEditingController();

  // Define a list of colors for the key
  final List<Color> _keyColors = [Colors.red, Colors.green, Colors.yellow, Colors.orange];

  // Insertion sort implementation with steps tracking
  void _insertionSort() {
    List<int> arr = List.from(_array);
    for (int i = 1; i < arr.length; i++) {
      int key = arr[i];
      int j = i - 1;

      // Highlight the current key and save the state
      _keyIndex = i; // Set the key index
      _steps.add(List.from(arr)); // Save the state before placing the key

      while (j >= 0 && arr[j] > key) {
        arr[j + 1] = arr[j];
        j--;

        // Add the state after each element movement
        _steps.add(List.from(arr));
      }
      arr[j + 1] = key;

      // Save the state after placing the key
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
      _keyIndex = -1; // Reset key index
    });
  }

  // Animation for sorting visualization
  Future<void> _startSortingVisualization() async {
    setState(() {
      _isSorting = true;
      _steps = [];
    });

    // First, generate the steps by sorting the array
    _insertionSort();

    // Animate the sorting process
    for (int i = 0; i < _steps.length; i++) {
      await Future.delayed(Duration(milliseconds: 500));
      setState(() {
        _currentStep = i;
        // Update the key index to match the current step
        _keyIndex = (i % _array.length < _array.length) ? i % _array.length : -1; // Reset if out of bounds
      });
    }

    setState(() {
      _isSorting = false;
      _keyIndex = -1; // Reset key index after sorting is done
    });
  }

  @override
  Widget build(BuildContext context) {
    final maxValue = _array.isNotEmpty ? _array.reduce((a, b) => a > b ? a : b) : 1;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Insertion Sort Visualization'),
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

              // Display the Insertion Sort code
              Text(
                'Insertion Sort Code:',
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
for (int i = 1; i < arr.length; i++) {
  int key = arr[i];
  int j = i - 1;
  while (j >= 0 && arr[j] > key) {
    arr[j + 1] = arr[j];
    j--;
  }
  arr[j + 1] = key;
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

                    // Determine color for the key based on current step
                    Color color = index == _keyIndex ? Colors.red : Colors.blue;

                    return Bar(
                      value: value,
                      maxValue: maxValue,
                      color: color, // Use the determined color
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
