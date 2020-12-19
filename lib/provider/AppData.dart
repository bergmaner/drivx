import 'package:drivx/models/addresModel.dart';
import "package:flutter/material.dart";

class AppData extends ChangeNotifier{

  Address pickupAddress;

  void updateAddress(Address address){
    pickupAddress = address;
    notifyListeners();
  }
}