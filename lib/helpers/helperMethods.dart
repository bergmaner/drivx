import 'package:connectivity/connectivity.dart';
import 'package:drivx/constants.dart';
import 'package:drivx/helpers/requestHelper.dart';
import 'package:geolocator/geolocator.dart';

class HelperMethods{
  static Future<String> findCoordinateAddress(Position position) async{
    String address = "";
    var connectivityResult = await Connectivity().checkConnectivity();
    if(connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi){
      return address;
    }
    String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=${mapKey}";
    var response = await RequestHelper.getRequest(url);
    if(response != "failure"){
      address = response['results'][0]['formatted_address'];
    }
    else return ":(((((";

    return address;
  }
}