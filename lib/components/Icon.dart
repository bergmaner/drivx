import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomIcon extends StatelessWidget {
  const CustomIcon({
    Key key,
    this.height,
    @required this.svgIcon,
  }) : super(key: key);

  final String svgIcon;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 20, 20, 20,),
      child: SvgPicture.asset(
        svgIcon,
        height: height,
      ),
    );
  }
}