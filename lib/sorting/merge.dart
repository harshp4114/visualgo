import 'package:flutter/material.dart';
import '../widgets/merge_sort_tree.dart'; // Ensure this is imported
import '../pages/home.dart';
import '../pages/signup.dart';

class MergeSortPage extends StatefulWidget {
  @override
  _MergeSortPageState createState() => _MergeSortPageState();
}

class _MergeSortPageState extends State<MergeSortPage> {
  List<int> _array = [];
  List<List<int>> _steps = [];
  bool _isSorting = false;
  int _currentStep = 0;

  final _arrayController = TextEditingController();

  void _mergeSort(List<int> arr) {
    if (arr.length <= 1) return; // Base case

    int mid = arr.length ~/ 2; // Find the midpoint
    List<int> left = arr.sublist(0, mid);
    List<int> right = arr.sublist(mid);

    _mergeSort(left); // Sort the left half
    _mergeSort(right); // Sort the right half

    _merge(arr, left, right); // Merge the sorted halves
  }

  void _merge(List<int> arr, List<int> left, List<int> right) {
    int i = 0, j = 0, k = 0;
    List<int> merged = [];

    while (i < left.length && j < right.length) {
      if (left[i] <= right[j]) {
        merged.add(left[i++]);
      } else {
        merged.add(right[j++]);
      }
    }

    while (i < left.length) {
      merged.add(left[i++]);
    }

    while (j < right.length) {
      merged.add(right[j++]);
    }

    for (int value in merged) {
      arr[k++] = value;
    }

    _steps.add(List.from(arr)); // Save the current state of the array
  }

  void _parseArrayInput(String input) {
    List<int> array = input.split(',').map((e) => int.tryParse(e.trim()) ?? 0).toList();
    setState(() {
      _array = array;
      _steps = [List.from(array)];
      _currentStep = 0;
    });
  }

  Future<void> _startSortingVisualization() async {
    setState(() {
      _isSorting = true;
      _steps = []; // Reset steps
    });

    _mergeSort(_array);

    // Update the current step based on the steps generated during sorting
    for (int i = 0; i < _steps.length; i++) {
      await Future.delayed(Duration(seconds: 1)); // Delay for visualization
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Merge Sort Visualization'),
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
                'Array Visualization:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Center(
                  child: MergeSortTree(
                    steps: _steps,
                    currentStep: _currentStep,
                  ),
                ),
              ),
              SizedBox(height: 20),
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
