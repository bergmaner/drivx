import 'package:drivx/components/HaveAccountText.dart';
import 'package:drivx/components/SignUpForm.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  static String routeName = "/signUp";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
          title: Text("Sign Up",),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20.0),
        child:SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child:Column(
              children:[

                Text(
                  "Register",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height:10),
                Text(
                  "Complete your details",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                SignUpForm(),
                SizedBox(height: 35),
                HaveAccountText(),
                SizedBox(height: 20)
              ],
            ),
          ),
        ),
      ),
    );
  }
}