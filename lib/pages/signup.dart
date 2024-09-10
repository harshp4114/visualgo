import 'package:flutter/material.dart';
import 'package:sdp/main.dart';
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _validateAndSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      // Perform sign up logic here
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[600]!,
        title: Text(
          "Sign Up",
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
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Heading text
              Container(
                margin: EdgeInsets.only(bottom: 15),
                child: Text(
                  "Create an Account",
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

              // Username TextBox
              TextFormField(
                controller: _usernameController,
                style: TextStyle(color: Colors.indigo[800]!, fontSize: 25),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
                  filled: true,
                  errorStyle: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                  fillColor: Colors.indigo[50]!,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  labelText: 'Username',
                  labelStyle: TextStyle(color: Colors.indigo[600]!, fontSize: 25, fontWeight: FontWeight.w600),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Email TextBox
              TextFormField(
                controller: _emailController,
                style: TextStyle(color: Colors.indigo[800]!, fontSize: 25),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
                  filled: true,
                  errorStyle: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                  fillColor: Colors.indigo[50]!,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.indigo[600]!, fontSize: 25, fontWeight: FontWeight.w600),
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

              // Password TextBox
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                style: TextStyle(color: Colors.indigo[800]!, fontSize: 25),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
                  filled: true,
                  errorStyle: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                  fillColor: Colors.indigo[50]!,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.indigo[600]!, fontSize: 25, fontWeight: FontWeight.w600),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Confirm Password TextBox
              TextFormField(
                controller: _confirmPasswordController,
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
                  labelText: 'Confirm Password',
                  errorStyle: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                  labelStyle: TextStyle(color: Colors.indigo[600]!, fontSize: 25, fontWeight: FontWeight.w600),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),

              // Sign Up Button
              ElevatedButton(
                onPressed: _validateAndSubmit,
                child: Text(
                  'Sign Up',
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

              // Back to Login Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    ModalRoute.withName('/login'),
                  );
                },
                child: Text(
                  'Back to Login',
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
        ),
      ),
    );
  }
}
