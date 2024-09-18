import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sdp/pages/signup.dart';
import 'package:sdp/pages/login.dart';
import 'package:sdp/pages/sorting.dart'; // Import the BubbleSortPage

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Home Page",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26,
            fontFamily: 'Montserrat',
          ),
        ),
        backgroundColor: Colors.indigo[800],  // Medium dark blue
        elevation: 8.0,
        centerTitle: true,
      ),
      backgroundColor: Colors.lightBlue[50],  // Light background for better contrast
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Welcome text
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Text(
                "Welcome to the Home Page!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo[800],
                  fontFamily: 'Montserrat',
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 30),

            // Bubble Sort Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SortingPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo[600],  // Medium blue button
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Bubble Sort",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 40),

            // Sign Out button
            IconButton(
              icon: Icon(Icons.logout),
              color: Colors.indigo[600],
              iconSize: 40,
              onPressed: () {
                _signOut();
              },
              tooltip: 'Sign Out',
            ),
            SizedBox(height: 20),

            // Label below the icon
            Text(
              "Sign Out",
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.indigo[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Sign-out method
  void _signOut() {
    FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()), // Navigating to LoginPage
      ModalRoute.withName('/login'),
    );
  }
}
