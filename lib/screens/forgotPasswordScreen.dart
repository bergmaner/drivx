import 'package:drivx/components/Button.dart';
import 'package:drivx/components/FormError.dart';
import 'package:drivx/components/NoAccountText.dart';
import 'package:drivx/constants.dart';
import 'package:drivx/components/Icon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  static String routeName = "/forgotPassword";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password"),
      ),
      body: SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
      child: Padding(
      padding:
      EdgeInsets.symmetric(horizontal: 20),
      child: Column(
      children: [
      SizedBox(height: 40),
      Text(
      "Forgot Password",
      style: TextStyle(
      fontSize: 28,
      color: Colors.black,
      fontWeight: FontWeight.bold,
      ),
      ),
      SizedBox(height: 40),
      Text(
      "Please enter your email and we will send \nyou a link to return to your account",
      textAlign: TextAlign.center,
      ),
      SizedBox(height: 40),
    ForgotPassForm(),
    ],
    ),
    ),
    ),
    ),
    );
  }
}

class ForgotPassForm extends StatefulWidget {
  @override
  _ForgotPassFormState createState() => _ForgotPassFormState();
}

class _ForgotPassFormState extends State<ForgotPassForm> {
  final _formKey = GlobalKey<FormState>();
  List<String> errors = [];
  String email;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              onSaved: (newValue) => email = newValue,
              onChanged: (value) {
                if (value.isNotEmpty && errors.contains(emailNullError)) {
                  setState(() {
                    errors.remove(emailNullError);
                  });
                } else if (emailValidatorRegExp.hasMatch(value) &&
                    errors.contains(invalidEmailError)) {
                  setState(() {
                    errors.remove(invalidEmailError);
                  });
                }
                return null;
              },
              validator: (value) {
                if (value.isEmpty && !errors.contains(emailNullError)) {
                  setState(() {
                    errors.add(emailNullError);
                  });
                } else if (!emailValidatorRegExp.hasMatch(value) &&
                    !errors.contains(invalidEmailError)) {
                  setState(() {
                    errors.add(invalidEmailError);
                  });
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: "Email",
                hintText: "Enter your email",
                // If  you are using latest version of flutter then lable text and hint text shown like this
                // if you r using flutter less then 1.20.* then maybe this is not working properly
                floatingLabelBehavior: FloatingLabelBehavior.always,
                suffixIcon: CustomIcon(svgIcon: "assets/icons/mail.svg", height: 30),
              ),
            ),
            SizedBox(height: 40),
            FormError(errors: errors),
            SizedBox(height: 15),
            Button(
              text: "Continue",
              press: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                    FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((value) => {
                      print("Check Your mails"),
                    });
                }
              },
            ),
            SizedBox(height:40),
            NoAccountText(),
          ],
        ),
      ),
    );
  }
}
