
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(
                'Password Reset Link Sent to Your Email',
              ),
            );
          });

    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(
                e.message.toString(),
              ),
            );
          });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 70,),
            Row(
              children: [
                SizedBox(width: 15,),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios),
                  color: Colors.white,
                ),
                SizedBox(width: 10,),
                Text(
                  "Forgot Password",
                  style: TextStyle(color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(25, 10, 20, 10),
              child: Container(
                child: Text(
                  "Enter your Email Address",
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: TextFormField(
                  style: TextStyle(
                    color: Colors.white
                  ),
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),

                    ),
                    labelText: 'Email',
                    floatingLabelStyle: TextStyle(
                      color: Colors.white,
                    ),
                    hintText: '',
                  ),
                  validator: (String? value) {
                    if (value?.trim().isEmpty ?? true) {
                      return 'Eneter an email';
                    }

                    bool emailValid = RegExp(
                        r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                        .hasMatch(value!);
                    if (emailValid == false) {
                      return 'Enter valid Email';
                    }

                    return null;
                  },
                ),
              ),

            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(

                      onPressed: () {
                        if(_formKey.currentState!.validate()){passwordReset();}
                      },
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 4.0,
                        backgroundColor: Colors.white,
                        fixedSize: Size(
                            350.0, 60.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

    );
  }
}