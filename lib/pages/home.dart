import 'package:flutter/material.dart';
import 'package:sdp/pages/signup.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      body: Column(
        children: [
          Text("Welcome to the Home Page!"),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: ()  {
               _signOut();
              // Navigate to the sign-in or welcome page after sign-out
              Navigator.of(context).pushReplacementNamed('/signup');  // Replace with your sign-in page route
            },
          ),
      ],
      ),
    );
  }

  void _signOut(){
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
      ModalRoute.withName('/signup'),
    );
  }

}