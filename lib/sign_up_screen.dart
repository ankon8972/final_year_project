import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_food_project/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;

  void showSnackBar(String message) {
    var snackbar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  Future<void> signUpWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      setState(() {
        isLoading = true;
      });
      print("created");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LogInScreen()),
      );
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      await userCredential.user?.updateDisplayName(name);
      setState(() {
        isLoading = false;
      });
      print("agaain");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LogInScreen()),
      );

    } on FirebaseAuthException catch (e) {
      // Show error if registration fails
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Registration Failed"),
            content: Text(e.message ?? "An error occurred."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    } finally {

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
backgroundColor: Colors.yellow,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color:Colors.yellow,

            ),
          ),
          SingleChildScrollView(
            child: SizedBox(
              height: 1000,
              child: Column(
                children: [
                  SizedBox(height: 50,),
                  Image(image: AssetImage('assets/image/diet.png'),height: 150,width: 150,),
                  SizedBox(height: 30,),


                  Padding(
                    padding: const EdgeInsets.fromLTRB(33.0, 10, 30, 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        children: [
                          Text(
                            "Registration",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'In password section use combination of Lowercase, Uppercase, Number and Special characters',
                            style: TextStyle(fontSize: 13, color: Colors.black38),
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
                          padding: EdgeInsets.fromLTRB(28, 10, 28, 10),
                          child: TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              labelText: 'Email',
                              floatingLabelStyle: TextStyle(
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
                          padding: EdgeInsets.fromLTRB(28, 10, 28, 10),
                          child: TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              labelText: 'Full Name',
                              floatingLabelStyle: TextStyle(
                                color: Color.fromRGBO(147, 18, 18, 1.0),
                              ),
                              hintText: '',
                            ),
                            validator: (String? value) {
                              if (value?.trim().isEmpty ?? true) {
                                return 'Enter your name';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(28, 10, 28, 10),
                          child: TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              labelText: 'Password',
                              floatingLabelStyle: TextStyle(
                                color: Color.fromRGBO(147, 18, 18, 1.0),
                              ),
                              hintText: '',
                            ),
                            validator: (String? value) {
                              // Check if value is null or empty
                              if (value == null || value.isEmpty) {
                                return 'Enter a password';
                              }

                              // Check length only if value is not null
                              if (value.length < 6) {
                                return 'Enter a password with more than 6 characters';
                              }

                              // Regex to validate password
                              bool passwordRegex = RegExp(
                                  r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#\$&*~]).{6,}$')
                                  .hasMatch(value);  // value is non-null here

                              if (!passwordRegex) {
                                return 'Enter a strong password';
                              }

                              return null;  // If everything is valid
                            },
                          ),
                        ),

                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 20,right: 20),
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                signUpWithEmailAndPassword(
                                  emailController.text.trim(),
                                  passwordController.text.trim(),
                                  nameController.text.trim(),
                                );
                              }
                            },
                            child: isLoading
                                ? CircularProgressIndicator(
                              color: Colors.black,
                            )
                                : Text("Register",style: TextStyle(
                              color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20
                            ),),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 4.0,
                              backgroundColor:Colors.white,
                              fixedSize: Size(355.0, 60.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
