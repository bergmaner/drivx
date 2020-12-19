import 'package:drivx/components/Icon.dart';
import "package:flutter/material.dart";

class SearchScreen extends StatefulWidget {
  static String routeName = "/searchScreen";
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height: 260,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow:
              [BoxShadow(
                color: Colors.black12,
                blurRadius: 5.0,
                spreadRadius: 0.5,
                offset: Offset(0.7,0.7),
              ),
              ]
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 24, top: 48, right: 24, bottom: 20),
              child: Column(
                children: <Widget>[

                SizedBox(height: 5,),
              Stack(
                children: <Widget>[
                  GestureDetector(
                      onTap:(){
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back)
                  ),
                  Center(
                    child: Text('Set Destination',
                      style: TextStyle(fontSize: 20,fontFamily: 'Brand-Bold' ),
                    ),
                  ),
                ],
              ),
                  SizedBox(height: 18,),

                  Row(
                    children: <Widget>[
                      CustomIcon(svgIcon: "assets/icons/location.svg", height: 30),

                      SizedBox(width: 18,),

                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFe2e2e2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Padding(
                            padding:  EdgeInsets.all(2.0),
                            child: TextField(
                              decoration: InputDecoration(
                                  hintText: 'Pickup location',
                                  fillColor: Color(0xFFe2e2e2),
                                  filled: true,
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(left: 10, top: 8, bottom: 8)
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),

                  Row(
                    children: <Widget>[
                     CustomIcon(svgIcon: "assets/icons/destination.svg", height: 30),
                      SizedBox(width: 18,),

                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFe2e2e2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Padding(
                            padding:  EdgeInsets.all(2.0),
                            child: TextField(
                              decoration: InputDecoration(
                                  hintText: 'Where to?',
                                  fillColor: Color(0xFFe2e2e2),
                                  filled: true,
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(left: 10, top: 8, bottom: 8),
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ]
            )
            )
          )
        ]
      )
    );
  }
}
