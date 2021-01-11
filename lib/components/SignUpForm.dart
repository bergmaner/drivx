import 'package:connectivity/connectivity.dart';
import 'package:drivx/components/Button.dart';
import 'package:drivx/components/FormError.dart';
import 'package:drivx/components/Icon.dart';
import 'package:drivx/components/ProgressDialog.dart';
import 'package:drivx/screens/mainScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import "package:flutter/material.dart";
import 'dart:developer';
import "package:drivx/constants.dart";
import 'package:flutter/services.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  String email;
  String password;
  String fullName;
  String phoneNumber;
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  void registerUser() async{
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => ProgressDialog(status: "Registering you ...")
    );
    final User user = (
        await _auth.createUserWithEmailAndPassword(email: email, password: password).catchError((err){
          FirebaseAuthException thisErr = err;
          print('error: ${thisErr.message}');
        })).user;

 if(user != null) {
   DatabaseReference userRef = FirebaseDatabase.instance.reference().child('users/${user.uid}');
   Map userMap = {
     "fullName": fullName,
     "email": email,
     "phoneNumber": phoneNumber
   };
   userRef.set(userMap);
   Navigator.pushNamedAndRemoveUntil(context, MainScreen.routeName,(route) => false);
 }}

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
            children: [
              TextFormField(
                onSaved: (newValue) => fullName = newValue,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    removeError(error: nameNullError);
                  }
                  return null;
                },
                validator: (value) {
                  if (value.isEmpty) {
                    addError(error: nameNullError);
                    return "";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    labelText: "Full Name",
                    hintText: "Enter your full name",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon:CustomIcon(svgIcon:"assets/icons/name.svg", height: 30)
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                onSaved: (newValue) => email = newValue,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    removeError(error: emailNullError);
                  } else if (emailValidatorRegExp.hasMatch(value)) {
                    removeError(error: invalidEmailError);
                  }
                  return null;
                },
                validator: (value) {
                  if (value.isEmpty) {
                    addError(error: emailNullError);
                    return "";
                  } else if (!emailValidatorRegExp.hasMatch(value)) {
                    addError(error: invalidEmailError);
                    return "";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "Enter your email",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon:CustomIcon(svgIcon:"assets/icons/mail.svg", height: 30,)
                ),

              ),
              SizedBox(height: 20),
              TextFormField(
                onSaved: (newValue) => phoneNumber = newValue,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    removeError(error: phoneNumberNullError);
                  }
                  return null;
                },
                validator: (value) {
                  if (value.isEmpty) {
                    addError(error: phoneNumberNullError);
                    return "";
                  } else if (!phoneValidatorRegExp.hasMatch(value)) {
                    addError(error: invalidPhoneNumberError);
                    return "";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    labelText: "Phone Number",
                    hintText: "Enter your phone number",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon:CustomIcon(svgIcon:"assets/icons/phone.svg", height: 30)
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                obscureText: true,
                onSaved: (newValue) => password = newValue,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    removeError(error: passNullError);
                  } else if (value.length >= 8) {
                    removeError(error: shortPassError);
                  }
                  return null;
                },
                validator: (value) {
                  if (value.isEmpty) {
                    addError(error: passNullError);
                    return "";
                  } else if (value.length < 8) {
                    addError(error: shortPassError);
                    return "";
                  }
                  return null;
                },

                decoration: InputDecoration(
                    labelText: "Password",
                    hintText: "Enter your password",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon:CustomIcon(svgIcon:"assets/icons/lock.svg", height: 30)
                ),
              ),
              SizedBox(height: 20),
              FormError(errors: errors),
              SizedBox(height: 20),
              Button(text:"Sign up",
                  press: () async{
                    var connectResult = Connectivity().checkConnectivity();
                    if(connectResult != ConnectivityResult.mobile && connectResult != ConnectivityResult.wifi) {
                      print(connectResult);
                    }
                      if (_formKey.currentState.validate())
                    {
                      _formKey.currentState.save();
                      registerUser();
                    }
                  })
            ]
        )
    );
  }
}
