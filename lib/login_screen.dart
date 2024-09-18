import 'package:final_year_food_project/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_food_project/sign_up_screen.dart'; // Import your SignUpScreen

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoading = false;

  // Method to show snackbar with a message
  void showSnackBar(String message) {
    var snackbar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  // Login method with email and password
  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      setState(() {
        isLoading = true;
      });

      // Sign in user with Firebase Authentication
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      // Navigate to the next screen upon successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const DashboardScreen(), // Define your HomeScreen
        ),
      );
    } on FirebaseAuthException catch (e) {
      // Display error message if login fails
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Login Failed"),
            content: Text(e.message ?? "An error occurred."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    } finally {
      // Always reset loading state at the end
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: 1000,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 70, 320, 0),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                  color: const Color.fromRGBO(13, 44, 82, 1.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(33, 80, 0, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Login",
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Enter your email and password to login',
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(28, 30, 28, 10),
                      child: TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          labelText: 'Email',
                          floatingLabelStyle: const TextStyle(
                            color: Color.fromRGBO(147, 18, 18, 1.0),
                          ),
                          hintText: '',
                        ),
                        validator: (String? value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'Enter an email';
                          }

                          bool emailValid = RegExp(
                              r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                              .hasMatch(value!);
                          if (!emailValid) {
                            return 'Enter a valid email';
                          }

                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(28, 10, 28, 10),
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          labelText: 'Password',
                          floatingLabelStyle: const TextStyle(
                            color: Color.fromRGBO(147, 18, 18, 1.0),
                          ),
                          hintText: '',
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter a password';
                          }

                          if (value.length < 6) {
                            return 'Enter a password with more than 6 characters';
                          }

                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          loginWithEmailAndPassword(
                            emailController.text.trim(),
                            passwordController.text.trim(),
                          );
                        }
                      },
                      child: isLoading
                          ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                          : const Text("Login"),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 4.0,
                        backgroundColor: const Color(0xff008081),
                        fixedSize: const Size(355.0, 60.0),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpScreen()), // Navigate to SignUpScreen
                        );
                      },
                      child: const Text(
                        "Don't have an account? Register here",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
