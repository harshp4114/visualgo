import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/bar.dart';

class InsertionSortPage extends StatefulWidget {
  @override
  _InsertionSortPageState createState() => _InsertionSortPageState();
}

class _InsertionSortPageState extends State<InsertionSortPage> {
  List<int> _array = [];
  List<List<int>> _steps = [];
  List<List<int>> _highlightIndices = []; // Track current key and insertion position
  bool _isSorting = false;
  bool _isPaused = false;
  int _currentStep = 0;
  bool _isAutoMode = true;

  final _arrayController = TextEditingController();

  void _insertionSort() {
    List<int> arr = List.from(_array);
    _steps.clear();
    _highlightIndices.clear();

    _steps.add(List.from(arr));
    _highlightIndices.add([-1, -1]); // No highlights initially

    for (int i = 1; i < arr.length; i++) {
      int key = arr[i];
      int j = i - 1;

      // Save state before starting insertion
      _steps.add(List.from(arr));
      _highlightIndices.add([i, j]); // Highlight current key and comparison position

      while (j >= 0 && arr[j] > key) {
        arr[j + 1] = arr[j];
        j--;

        // Save state after each shift
        _steps.add(List.from(arr));
        _highlightIndices.add([i, j + 1]);
      }

      arr[j + 1] = key;

      // Save state after insertion
      _steps.add(List.from(arr));
      _highlightIndices.add([j + 1, -1]); // Highlight final position
    }
  }

  void _parseArrayInput(String input) {
    List<int> array = input.split(',').map((e) => int.tryParse(e.trim()) ?? 0).toList();
    setState(() {
      _array = array;
      _steps = [List.from(array)];
      _highlightIndices = [[-1, -1]];
      _currentStep = 0;
      _isSorting = false;
      _isPaused = false;
    });
  }

  Future<void> _startAutomaticVisualization({bool fromCurrentStep = false}) async {
    setState(() {
      _isSorting = true;
      _isAutoMode = true;
      _isPaused = false;
      if (!fromCurrentStep) {
        _steps = [];
        _highlightIndices = [];
        _currentStep = 0;
        _insertionSort();
      }
    });

    for (int i = _currentStep; i < _steps.length; i++) {
      if (!_isAutoMode || _isPaused) break;
      await Future.delayed(Duration(milliseconds: 500));
      if (!mounted) return;
      setState(() {
        _currentStep = i;
      });
    }

    if (!_isPaused && mounted) {
      setState(() {
        _isSorting = _currentStep < _steps.length - 1;
      });
    }
  }

  void _startManualVisualization() {
    setState(() {
      _isAutoMode = false;
      _isPaused = false;
      _isSorting = true;
      _steps = [];
      _highlightIndices = [];
      _currentStep = 0;
    });
    _insertionSort();
  }

  void _switchToAutoFromManual() {
    setState(() {
      _isAutoMode = true;
    });
    _startAutomaticVisualization(fromCurrentStep: true);
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
      if (!_isPaused) {
        _startAutomaticVisualization(fromCurrentStep: true);
      }
    });
  }

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
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

              Text(
                'Insertion Sort Code:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              Container(
                height: 120,
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
}''',
                      style: TextStyle(fontSize: 16, fontFamily: 'Courier'),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              Text(
                'Array Visualization:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _steps.isNotEmpty
                      ? _steps[_currentStep].asMap().entries.map((entry) {
                    int index = entry.key;
                    int value = entry.value;

                    Color barColor = Colors.blue;
                    if (_highlightIndices[_currentStep].contains(index)) {
                      barColor = Colors.red;
                    }

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

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: !_isSorting
                        ? () => _startAutomaticVisualization()
                        : _isAutoMode && !_isPaused
                        ? null
                        : _switchToAutoFromManual,
                    child: Text('Auto Sort'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isAutoMode ? Colors.indigo : Colors.grey,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  SizedBox(width: 20),

                  ElevatedButton(
                    onPressed: _isSorting && _isAutoMode && !_isPaused
                        ? null
                        : _startManualVisualization,
                    child: Text('Manual Sort'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !_isAutoMode ? Colors.indigo : Colors.grey,
                      foregroundColor: Colors.white,
                    ),
                  ),

                  if (_isAutoMode && _isSorting) ...[
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: _togglePause,
                      child: Text(_isPaused ? 'Resume' : 'Stop'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isPaused ? Colors.green : Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ],
              ),

              if (!_isAutoMode && _isSorting) ...[
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _currentStep > 0 ? _previousStep : null,
                      child: Text('Previous Step'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: _currentStep < _steps.length - 1 ? _nextStep : null,
                      child: Text('Next Step'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],

              if (_isSorting) ...[
                SizedBox(height: 10),
                Center(
                  child: Text(
                    'Step ${_currentStep + 1} of ${_steps.length}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}