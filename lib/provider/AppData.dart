import 'package:drivx/models/addresModel.dart';
import "package:flutter/material.dart";

class AppData extends ChangeNotifier{

  Address pickupAddress;
  Address destinationAddress;

  void updatePickupAddress(Address address){
    pickupAddress = address;
    notifyListeners();
  }

  void updateDestinationAddress(Address address){
    destinationAddress = address;
    notifyListeners();
  }
}