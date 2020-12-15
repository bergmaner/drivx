import 'package:drivx/components/NoAccountText.dart';
import 'package:drivx/components/SignInForm.dart';
import 'package:drivx/components/SignUpForm.dart';
import 'package:drivx/components/SocialCard.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  static String routeName = "/sign_up";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child:Text("Sign Up")
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20.0),
        child:SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child:Column(
              children:[
                SizedBox(height: 20),
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
                NoAccountText(),
                SizedBox(height: 20)
              ],
            ),
          ),
        ),
      ),
    );
  }
}