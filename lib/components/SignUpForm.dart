import 'package:drivx/components/Button.dart';
import 'package:drivx/components/FormError.dart';
import 'package:drivx/components/Icon.dart';
import "package:flutter/material.dart";
import 'package:flutter_svg/flutter_svg.dart';
import "package:drivx/constants.dart";

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  String email;
  String password;
  String fullName;
  bool remember = false;
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];

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
                    removeError(error: emailNullError);
                  }
                  return null;
                },
                validator: (value) {
                  if (value.isEmpty) {
                    addError(error: emailNullError);
                    return "";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    labelText: "Full Name",
                    hintText: "Enter your full name",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon:CustomIcon(svgIcon:"assets/icons/mail.svg")
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
                    suffixIcon:CustomIcon(svgIcon:"assets/icons/mail.svg")
                ),

              ),
              SizedBox(height: 20),
              TextFormField(
                onSaved: (newValue) => fullName = newValue,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    removeError(error: emailNullError);
                  }
                  return null;
                },
                validator: (value) {
                  if (value.isEmpty) {
                    addError(error: emailNullError);
                    return "";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    labelText: "Phone Number",
                    hintText: "Enter your phone number",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon:CustomIcon(svgIcon:"assets/icons/mail.svg")
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
                    suffixIcon:CustomIcon(svgIcon:"assets/icons/lock.svg")
                ),
              ),
              SizedBox(height: 20),
              FormError(errors: errors),
              SizedBox(height: 20),
              Button(text:"Sign up",
                  press: (){
                    if (_formKey.currentState.validate()){
                      _formKey.currentState.save();
                    }
                  })
            ]
        )
    );
  }
}
