import 'package:drivx/screens/signInScreen.dart';
import 'package:flutter/material.dart';

class HaveAccountText extends StatelessWidget {
  const HaveAccountText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Do you have an account? ",
          style: TextStyle(fontSize: 16),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, SignInScreen.routeName),
          child: Text(
            "Sign In",
            style: TextStyle(
                fontSize: 16,
                color: Color(0xfff00000)),
          ),
        ),
      ],
    );
  }
}