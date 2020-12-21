import 'package:drivx/components/Icon.dart';
import 'package:drivx/models/prediction.dart';
import "package:flutter/material.dart";

class PredictionSquare extends StatelessWidget {

  final Prediction prediction;
  PredictionSquare({this.prediction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        child: Column(
          children: <Widget> [
            Row(
              children: <Widget>[
                CustomIcon(svgIcon: 'assets/icons/loc.svg', height: 20),
                SizedBox(width: 10),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(prediction.mainText, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16)),
                      SizedBox(height: 2),
                      Text(prediction.secondaryText, style: TextStyle(fontSize: 12, color: Color(0xFFadadad)))
                    ]
                )
              ]
          )
      ]
        )
      ),
    );
  }
}
