import 'package:flutter/material.dart';

class MergeSortPage extends StatefulWidget {
  @override
  _MergeSortPageState createState() => _MergeSortPageState();
}

class _MergeSortPageState extends State<MergeSortPage> {
  List<int> array = [];
  List<List<int>> steps = []; // To hold steps for visualization
  int currentStep = -1;
  final TextEditingController arrayController = TextEditingController();

  @override
  void dispose() {
    arrayController.dispose();
    super.dispose();
  }

  // Merge Sort Algorithm with step recording
  void mergeSort(List<int> array) {
    if (array.length <= 1) return;

    int mid = array.length ~/ 2;
    List<int> left = array.sublist(0, mid);
    List<int> right = array.sublist(mid);

    mergeSort(left);
    mergeSort(right);

    int i = 0, j = 0, k = 0;
    while (i < left.length && j < right.length) {
      if (left[i] <= right[j]) {
        array[k++] = left[i++];
      } else {
        array[k++] = right[j++];
      }
    }

    while (i < left.length) array[k++] = left[i++];
    while (j < right.length) array[k++] = right[j++];

    steps.add(List.from(array)); // Store the array at each step
  }

  // Function to start the merge sort and reset steps
  void startMergeSort() {
    setState(() {
      array = arrayController.text.split(",").map((e) => int.parse(e.trim())).toList();
      steps.clear();
      mergeSort(array);
      currentStep = 0;
    });
  }

  // Move to the next step in the visualization
  void nextStep() {
    setState(() {
      if (currentStep < steps.length - 1) {
        currentStep++;
      }
    });
  }

  // Move to the previous step in the visualization
  void previousStep() {
    setState(() {
      if (currentStep > 0) {
        currentStep--;
      }
    });
  }

  // Widget to build the tree-like hierarchy view
  Widget _buildTree(List<int> array, int level) {
    if (array.length == 1) {
      return Container(
        margin: EdgeInsets.all(8),
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            array[0].toString(),
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
      );
    }

    int mid = array.length ~/ 2;
    List<int> left = array.sublist(0, mid);
    List<int> right = array.sublist(mid);

    return Column(
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          children: array.map((value) {
            return Container(
              margin: EdgeInsets.all(8),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: level == 0 ? Colors.green : Colors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  value.toString(),
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 2,
                    height: 20,
                    color: Colors.black,
                  ),
                  _buildTree(left, level + 1),
                ],
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 2,
                    height: 20,
                    color: Colors.black,
                  ),
                  _buildTree(right, level + 1),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Merge Sort Visualization"),
        backgroundColor: Colors.indigo[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Input for the array
            TextField(
              controller: arrayController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Enter array elements (comma-separated)",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Start button
            ElevatedButton(
              onPressed: startMergeSort,
              child: Text("Start Merge Sort"),
            ),
            SizedBox(height: 16),

            // Step control buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: previousStep,
                  child: Text("Previous Step"),
                ),
                ElevatedButton(
                  onPressed: nextStep,
                  child: Text("Next Step"),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Merge sort visualization with hierarchy
            currentStep == -1
                ? Text(
              "Enter an array and press Start",
              style: TextStyle(fontSize: 18),
            )
                : Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      "Step ${currentStep + 1}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    _buildTree(steps[currentStep], 0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}