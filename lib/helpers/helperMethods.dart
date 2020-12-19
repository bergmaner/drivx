import 'package:connectivity/connectivity.dart';
import 'package:drivx/constants.dart';
import 'package:drivx/helpers/requestHelper.dart';
import 'package:drivx/models/addresModel.dart';
import 'package:drivx/provider/AppData.dart';
import 'package:geolocator/geolocator.dart';
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

      address = response['results'][0]['formatted_address'];
      Address pickupAddress = Address();
      pickupAddress.latitude = position.latitude;
      pickupAddress.longitude = position.longitude;
      pickupAddress.placeAddress = address;

      Provider.of<AppData>(context, listen: false).updateAddress(pickupAddress);
    }
    else return ":(((((";

    return address;
  }
}