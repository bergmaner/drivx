import 'package:drivx/components/Icon.dart';
import 'package:drivx/components/ProgressDialog.dart';
import 'package:drivx/constants.dart';
import 'package:drivx/helpers/helperMethods.dart';
import 'package:drivx/helpers/requestHelper.dart';
import 'package:drivx/models/addresModel.dart';
import 'package:drivx/models/prediction.dart';
import 'package:drivx/provider/AppData.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

class PredictionSquare extends StatelessWidget {

  final Prediction prediction;
  PredictionSquare({this.prediction});

  void getPlaceDetails (String placeId, context) async{

    showDialog(
      barrierDismissible:  false,
      context: context,
      builder: (BuildContext context) => ProgressDialog(status:"Please wait...")
    );

    String url = 'https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&key=$mapKey';

    var response = await RequestHelper.getRequest(url);

    Navigator.pop(context);

    if(response == "failure") return;

    if(response['status'] == "OK"){

      Address place = Address();
      place.placeName = response['result']['name'];
      place.placeId = placeId;
      place.latitude = response["result"]['geometry']['location']['lat'];
      place.longitude = response["result"]['geometry']['location']['lng'];

      Provider.of<AppData>(context,listen: false).updateDestinationAddress(place);
      print(place.placeName);

      Navigator.pop(context, "getDirection");
    }
  }

  @override
  Widget build(BuildContext context) {
    return
      FlatButton(
        onPressed: (){
          getPlaceDetails(prediction.placeId, context);
        },
          padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: <Widget> [
            Row(
              children: <Widget>[
                CustomIcon(svgIcon: 'assets/icons/loc.svg', height: 20),
                SizedBox(width: 10),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(prediction.mainText, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16, color: Colors.black)),
                      SizedBox(height: 2),
                      Text(prediction.secondaryText, style: TextStyle(fontSize: 12, color: Color(0xFFadadad)))
                    ]
                )
              ]
          )
      ]
        )
    );
  }
}
