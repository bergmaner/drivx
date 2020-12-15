import 'package:drivx/components/NoAccountText.dart';
import 'package:drivx/components/SignInForm.dart';
import 'package:drivx/components/SocialCard.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatelessWidget {
  static String routeName = "/signIn";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:Text("Sign In")
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
        "Welcome Back",
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
            SizedBox(height:10),
          Text(
            "Sign in with your email and password  \nor continue with social media",
            textAlign: TextAlign.center,
          ),
            SizedBox(height: 40),
            SignInForm(),
            SizedBox(height:40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SocialCard(
                  icon: "assets/icons/google.svg",
                  press: () {},
                ),
                SocialCard(
                  icon: "assets/icons/facebook.svg",
                  press: () {},
                ),
                SocialCard(
                  icon: "assets/icons/twitter.svg",
                  press: () {},
                ),
              ],
            ),
            SizedBox(height: 25),
           NoAccountText()
          ],
          ),
          ),
        ),
      ),
    );
  }
}