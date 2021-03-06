import 'dart:math';

import 'package:connectivity/connectivity.dart';
import 'package:drivx/constants.dart';
import 'package:drivx/helpers/requestHelper.dart';
import 'package:drivx/models/addresModel.dart';
import 'package:drivx/models/directionDetails.dart';
import 'package:drivx/models/user.dart';
import 'package:drivx/provider/AppData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import "package:provider/provider.dart";

class HelperMethods{
  static Future<String> findCoordinateAddress(Position position, context) async{
    String address = "";
    var connectivityResult = await Connectivity().checkConnectivity();
    if(connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi){
      return address;
    }
    String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=${mapKey}";
    var response = await RequestHelper.getRequest(url);
    if(response != "failure"){

      address = '${response['results'][0]['address_components'][2]['long_name']} ${response['results'][0]['address_components'][1]['long_name']} ${response['results'][0]['address_components'][0]['long_name']}';
      Address pickupAddress = Address();
      pickupAddress.latitude = position.latitude;
      pickupAddress.longitude = position.longitude;
      pickupAddress.placeAddress = address;

      Provider.of<AppData>(context, listen: false).updatePickupAddress(pickupAddress);
      print('long: ${position.longitude}, lat: ${position.latitude}');
    }
    else return ":(((((";

    return address;
  }
  static Future<DirectionDetails> getDirectionDetails(LatLng start, LatLng end) async{
    String url = 'https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&mode=driving&key=$mapKey';
    var response = await RequestHelper.getRequest(url);
    print('start: $start end: $end');
    if(response == "failure"){
      return null;
    }
        DirectionDetails directionDetails = DirectionDetails();

        directionDetails.durationText = response["routes"][0]["legs"][0]["duration"]["text"];
        directionDetails.durationValue = response["routes"][0]["legs"][0]["duration"]["value"];
        directionDetails.distanceText = response["routes"][0]["legs"][0]["distance"]["text"];
        directionDetails.distanceValue = response["routes"][0]["legs"][0]["distance"]["value"];
        directionDetails.encodedPoints = response["routes"][0]["overview_polyline"]["points"];

        return directionDetails;
  }
  static int calculatePrices (DirectionDetails details){

    double basePrice = 3;
    double distancePrice = (details.distanceValue / 1000) * 0.3;
    double timePrice = (details.durationValue / 60) * 0.2;
    double totalPrice = basePrice + distancePrice + timePrice;

    return totalPrice.truncate();
  }
  static double generateRandomNumber(int max){

    var randomGenerator = Random();
    int randInt = randomGenerator.nextInt(max);

    return randInt.toDouble();
  }
  static void getCurrentUserInfo() async{
    String userId = currentUser.uid;
    DatabaseReference userRef = FirebaseDatabase.instance.reference().child('users/$userId');

    userRef.once().then((DataSnapshot snapshot) =>{
      if(snapshot.value != null){
        currentUserInfo = CurrentUser.fromSnapshot(snapshot),
        print('User: ${currentUserInfo.fullName}'),
      }
    });
  }

}