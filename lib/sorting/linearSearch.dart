import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/bar.dart';

class LinearSearchPage extends StatefulWidget {
  @override
  _LinearSearchPageState createState() => _LinearSearchPageState();
}

class _LinearSearchPageState extends State<LinearSearchPage> {
  List<int> _array = [];
  List<List<int>> _steps = [];
  List<List<int>> _highlightIndices = [];
  int target = -1;
  bool _isSearching = false;
  bool _isPaused = false;
  int _currentStep = 0;
  bool _isAutoMode = true;
  bool _found = false;

  final _arrayController = TextEditingController();
  final _targetController = TextEditingController();

  @override
  void dispose() {
    _arrayController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  void _linearSearch() {
    List<int> arr = List.from(_array);
    _steps.clear();
    _highlightIndices.clear();
    _found = false;

    // Initial state
    _steps.add(List.from(arr));
    _highlightIndices.add([-1]);

    // Generate steps for visualization
    for (int i = 0; i < arr.length; i++) {
      _steps.add(List.from(arr));
      _highlightIndices.add([i]);

      if (arr[i] == target) {
        _found = true;
        break;
      }
    }
  }

  void _parseArrayInput(String arrayInput, String targetInput) {
    List<int> array = arrayInput.split(',').map((e) => int.tryParse(e.trim()) ?? 0).toList();
    setState(() {
      _array = array;
      target = int.tryParse(targetInput) ?? 0;
      _steps = [List.from(array)];
      _highlightIndices = [[-1]];
      _currentStep = 0;
      _isSearching = false;
      _isPaused = false;
      _found = false;
    });
  }

  Future<void> _startAutomaticSearch({bool fromCurrentStep = false}) async {
    setState(() {
      _isSearching = true;
      _isAutoMode = true;
      _isPaused = false;
      if (!fromCurrentStep) {
        _steps = [];
        _highlightIndices = [];
        _currentStep = 0;
        _linearSearch();
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
        _isSearching = _currentStep < _steps.length - 1;
      });
    }
  }

  void _startManualSearch() {
    setState(() {
      _isAutoMode = false;
      _isPaused = false;
      _isSearching = true;
      _steps = [];
      _highlightIndices = [];
      _currentStep = 0;
    });
    _linearSearch();
  }

  void _switchToAutoFromManual() {
    setState(() {
      _isAutoMode = true;
    });
    _startAutomaticSearch(fromCurrentStep: true);
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
      if (!_isPaused) {
        _startAutomaticSearch(fromCurrentStep: true);
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Linear Search Visualization"),
        backgroundColor: Colors.indigo,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _arrayController,
                decoration: InputDecoration(
                  labelText: "Enter array elements (comma-separated)",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              TextField(
                controller: _targetController,
                decoration: InputDecoration(
                    labelText: "Enter target value",
                    border: OutlineInputBorder(),
                    helperText: "Value to search for in the array"),
              ),
              SizedBox(height: 20),

              Text(
                _found
                    ? 'Element $target found at step ${_highlightIndices.last[0] + 1}'
                    : _isSearching && !_found && _currentStep == _steps.length - 1
                    ? 'Element $target not found.'
                    : 'Searching...',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                    bool isHighlighted =
                    _highlightIndices[_currentStep].contains(index);
                    return Bar(
                      value: value,
                      maxValue: _array.isEmpty
                          ? 1
                          : _array.reduce((a, b) => a > b ? a : b),
                      color: isHighlighted ? Colors.red : Colors.blue,
                    );
                  }).toList()
                      : [],
                ),
              ),

              // Column for buttons
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: !_isSearching
                            ? () {
                          _parseArrayInput(
                              _arrayController.text, _targetController.text);
                          _startAutomaticSearch();
                        }
                            : _isAutoMode && !_isPaused
                            ? null
                            : _switchToAutoFromManual,
                        child: Text('Auto Search'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isAutoMode ? Colors.indigo : Colors.grey,
                        ),
                      ),
                      SizedBox(width: 20),

                      ElevatedButton(
                        onPressed: _isSearching && _isAutoMode && !_isPaused
                            ? null
                            : () {
                          _parseArrayInput(
                              _arrayController.text, _targetController.text);
                          _startManualSearch();
                        },
                        child: Text('Manual Search'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: !_isAutoMode ? Colors.indigo : Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  // Pause/Resume button positioned below
                  if (_isAutoMode && _isSearching) ...[
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _togglePause,
                      child: Text(_isPaused ? 'Resume' : 'Pause'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isPaused ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ],
              ),

              if (!_isAutoMode && _isSearching) ...[
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _currentStep > 0 ? _previousStep : null,
                      child: Text('Previous Step'),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed:
                      _currentStep < _steps.length - 1 ? _nextStep : null,
                      child: Text('Next Step'),
                    ),
                  ],
                ),
              ],

              if (_isSearching) ...[
                SizedBox(height: 10),
                Center(
                  child: Text(
                    'Step ${_currentStep + 1} of ${_steps.length}',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
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
