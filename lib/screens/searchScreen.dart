import 'package:drivx/components/HorizontalDivider.dart';
import 'package:drivx/components/Icon.dart';
import 'package:drivx/components/PredictionSquare.dart';
import 'package:drivx/constants.dart';
import 'package:drivx/helpers/requestHelper.dart';
import 'package:drivx/models/prediction.dart';
import 'package:drivx/provider/AppData.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  static String routeName = "/searchScreen";
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  var pickupController = TextEditingController();
  var destinationController = TextEditingController();
  var focus = FocusNode();
  bool focused = false;

  void setFocus(){
    if(!focused){
      FocusScope.of(context).requestFocus(focus);
      focused = true;
    }

  }

  List<Prediction> searchedResultsList = [];

  void searchPlace(String placeName) async {
    if(placeName.length > 1){
      String url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&sessiontoken=123254251&components=country:pl';
      var response = await RequestHelper.getRequest(url);
      if(response == "failure"){
        return;
      }
      if(response['status'] == "OK"){
        var predictionJson = response['predictions'];
        var results = (predictionJson as List).map((e) => Prediction.fromJson(e)).toList();
        print(results);
        setState(() {
          searchedResultsList = results;
        });

      }
    }
  }

  @override
  Widget build(BuildContext context) {

    setFocus();

    String address =  Provider.of<AppData>(context)?.pickupAddress?.placeAddress ?? "";
    pickupController.text = address;
    return Scaffold(
      body:
      Column(
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
                             controller: pickupController,
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
                              onChanged: (value){
                                searchPlace(value);
                              },
                              controller: destinationController,
                              focusNode: focus,
                              decoration: InputDecoration(
                                  hintText: 'Where?',
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
                      ),
                    ],
                  ),
                ]
            )
            )
          ),
          (searchedResultsList.length > 0) ?
          Expanded(
            child:ListView.separated(
            padding: EdgeInsets.all(0),
              itemBuilder: (context,index){
                return PredictionSquare(
                  prediction: searchedResultsList[index],
                );
              },
              separatorBuilder: (BuildContext context, int index) => HorizontalDivider(),
              itemCount: searchedResultsList.length,
              shrinkWrap: true,
              physics: ClampingScrollPhysics()
          )
          ):
          Container(),
        ]
      )
    );
  }
}