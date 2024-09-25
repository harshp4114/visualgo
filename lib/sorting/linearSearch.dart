import 'package:flutter/material.dart';

class LinearSearchPage extends StatefulWidget {
  @override
  _LinearSearchPageState createState() => _LinearSearchPageState();
}

class _LinearSearchPageState extends State<LinearSearchPage> {
  List<int> array = [];
  int target = -1;
  int currentIndex = -1;
  bool found = false;
  bool isSearching = false; // Flag to indicate if the search is in progress
  final TextEditingController arrayController = TextEditingController();
  final TextEditingController targetController = TextEditingController();

  @override
  void dispose() {
    arrayController.dispose();
    targetController.dispose();
    super.dispose();
  }

  // Perform linear search step by step
  void linearSearch() async {
    setState(() {
      found = false;
      isSearching = true;
    });

    for (int i = 0; i < array.length; i++) {
      setState(() {
        currentIndex = i;
      });
      await Future.delayed(Duration(seconds: 1)); // Add delay to simulate animation

      if (array[i] == target) {
        setState(() {
          found = true;
          isSearching = false;
        });
        break;
      }
    }

    // If target is not found
    if (!found) {
      setState(() {
        isSearching = false;
      });
    }
  }

  // Widget to build the array view with horizontal scrolling
  Widget _buildArrayView() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // Enable horizontal scrolling
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: array.asMap().entries.map((entry) {
          int index = entry.key;
          int value = entry.value;
          return Container(
            margin: EdgeInsets.all(8),
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: index == currentIndex
                  ? (found ? Colors.green : Colors.blue)
                  : Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                value.toString(),
                style: TextStyle(
                  color: index == currentIndex ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Linear Search Visualization"),
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
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Enter array elements (comma-separated)",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Input for the target number
            TextField(
              controller: targetController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Enter target value",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Search button
            ElevatedButton(
              onPressed: () {
                setState(() {
                  // Parse the array from user input
                  array = arrayController.text.split(",").map((e) => int.parse(e.trim())).toList();
                  target = int.parse(targetController.text);
                  currentIndex = -1;
                  found = false;
                  isSearching = false;
                });
                linearSearch(); // Start the linear search
              },
              child: Text("Start Linear Search"),
            ),
            SizedBox(height: 20),

            // Array visualization
            _buildArrayView(),
            SizedBox(height: 20),

            // Display search status
            Text(
              isSearching
                  ? "Searching..."
                  : found
                  ? "Target found at index $currentIndex"
                  : "Target not found in the array",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: found ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
