import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sdp/pages/home.dart';
import 'package:sdp/pages/signup.dart';
import 'package:sdp/firebase_auth/auth_services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers for email and password input
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Form key to manage form validation
  final _formKey = GlobalKey<FormState>();

  FirebaseAuthService _auth = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[600]!,
        title: Text(
          "Login",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28,
            fontFamily: 'Montserrat',
          ),
        ),
        elevation: 8.0,
        centerTitle: true,
      ),
      backgroundColor: Colors.lightBlue[50]!,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Form(
          key: _formKey, // Form key for validation
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Heading text
              Container(
                margin: EdgeInsets.only(bottom: 15),
                child: Text(
                  "Welcome to VisuAlgo!!",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo[800]!,
                    fontFamily: 'Montserrat',
                    letterSpacing: 1.1,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),

              // Email TextBox with controller and validation
              TextFormField(
                controller: _emailController,
                style: TextStyle(color: Colors.indigo[800]!, fontSize: 25),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
                  filled: true,
                  fillColor: Colors.indigo[50]!,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  labelText: 'Email',
                  labelStyle: TextStyle(
                      color: Colors.indigo[600]!,
                      fontSize: 25,
                      fontWeight: FontWeight.w600),
                  errorStyle: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                  hintText: 'Enter your email',
                  hintStyle: TextStyle(color: Colors.indigo[300]!),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Password TextBox with controller and validation
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                style: TextStyle(color: Colors.indigo[800]!, fontSize: 25),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
                  filled: true,
                  fillColor: Colors.indigo[50]!,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  labelText: 'Password',
                  labelStyle: TextStyle(
                      color: Colors.indigo[600]!,
                      fontSize: 25,
                      fontWeight: FontWeight.w600),
                  errorStyle: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                  hintText: 'Enter your password',
                  hintStyle: TextStyle(color: Colors.indigo[300]!),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),

              // Login Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _signIn();
                  }
                },
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo[600]!,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 50),

              // Text and Sign Up Button Row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Create an account?",
                    style: TextStyle(
                      color: Colors.indigo[600]!,
                      fontSize: 23,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  SizedBox(width: 15),

                  // Sign Up Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.indigo[600]!,
                      side: BorderSide(color: Colors.indigo[600]!, width: 2),
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signIn() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    // Call Firebase Authentication service to sign in
    User? user = await _auth.signInWithEmailAndPassword(email, password);

    if (user != null) {
      print("User signed in successfully.");
      Navigator.pushNamed(context, '/home');
    } else {
      print("Sign-in failed. Please check your credentials.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed. Please try again.')),
      );
    }
  }
}
