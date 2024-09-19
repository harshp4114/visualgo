import 'package:flutter/material.dart';
import 'package:sdp/pages/home.dart';
import 'package:sdp/pages/signup.dart';
import 'package:sdp/sorting/bubble.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sdp/pages/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/signup': (context) => SignUpPage(),
        '/sorting': (context) => SortingPage(),
      },
      home:LoginPage(),
      // Add an onGenerateRoute for unknown routes
      onGenerateRoute: (settings) {
        // Handle unknown routes here if needed
        return MaterialPageRoute(builder: (context) => LoginPage());
      },
    );
  }
}

