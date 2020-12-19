import 'package:drivx/screens/forgotPasswordScreen.dart';
import 'package:drivx/screens/mainScreen.dart';
import 'package:drivx/screens/searchScreen.dart';
import 'package:drivx/screens/signInScreen.dart';
import 'package:drivx/screens/signUpScreen.dart';
import 'package:flutter/widgets.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SignInScreen.routeName: (context) => SignInScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  MainScreen.routeName: (context) => MainScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  SearchScreen.routeName: (context) => SearchScreen(),
};