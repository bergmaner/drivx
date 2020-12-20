import 'dart:async';
import 'package:drivx/components/HorizontalDivider.dart';
import 'package:drivx/components/MenuNav.dart';
import 'package:drivx/helpers/helperMethods.dart';
import 'package:drivx/provider/AppData.dart';
import 'package:drivx/screens/searchScreen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:drivx/components/Icon.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  static String routeName = "/mainScreen";
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  var geolocator = Geolocator();
  Position currentPosition;

  void setCurrentPosition() async {
    Position position = await geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;
    LatLng pos = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition = new CameraPosition(target: pos, zoom:14);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    String address = await HelperMethods.findCoordinateAddress(position, context); 
    print('address: ${address}');
  }


  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            zoomGesturesEnabled: false,
            padding: EdgeInsets.only(bottom: 345.0,),
            onMapCreated: (GoogleMapController controller){
              _controller.complete(controller);
              mapController = controller;

              setCurrentPosition();
            },

          ),
          Positioned(
            top: 34,
            child:RawMaterialButton(
              enableFeedback: false,
              onPressed: () {
                scaffoldKey.currentState.openDrawer();
              },
              elevation: 2.0,
              fillColor: Colors.white,
              child: Icon(
                Icons.menu,
                color: Colors.red,
                size: 25.0,
              ),
              padding: EdgeInsets.all(10.0),
              shape: CircleBorder(),
            )
            ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 340,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 15.0,
                    spreadRadius: 0.5,
                    offset: Offset(0.7,0.7)
                  )
                ]
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:<Widget>[
                    SizedBox(height: 5),
                    Text(
                        "Nice to see you",
                        style: TextStyle(fontSize: 12)
                    ),
                    SizedBox(height: 2),
                    Text(
                        "Where are you going",
                        style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, SearchScreen.routeName);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5.0,
                              spreadRadius: 0.5,
                              offset: Offset(0.7,0.7)
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal:22.0),
                          child: Row(
                            children: <Widget>[
                              CustomIcon(svgIcon: "assets/icons/search.svg", height: 20),
                              SizedBox(width: 10),
                              Text("Search Destination",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13))
                            ]
                          ),
                        )
                      ),
                    ),
                    SizedBox(height:20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: <Widget>[
                          CustomIcon(svgIcon: "assets/icons/home.svg", height: 20),
                          SizedBox(width: 12),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                  Provider.of<AppData>(context).pickupAddress != null ?
                                  Provider.of<AppData>(context).pickupAddress.placeAddress :
                                  "Add address",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)
                              ),
                              SizedBox(height:3),
                              Text("Your home address", style: TextStyle(fontSize: 11, color: Color(0xFFadadad)))
                            ]
                          )
                        ]
                      ),
                    ),
                    SizedBox(height: 10),
                    HorizontalDivider(),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                          children: <Widget>[
                            CustomIcon(svgIcon: "assets/icons/work.svg", height: 20),

                            SizedBox(width: 12),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Add Work",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                  SizedBox(height:3),
                                  Text("Your work address", style: TextStyle(fontSize: 11, color: Color(0xFFadadad)))
                                ]
                            ),
                          ]
                      ),
                    ),
                    SizedBox(height: 10),
                    HorizontalDivider(),
                  ]
                ),
              )
            ),
          )
        ],
      ),
      drawer:MenuNav()
    );
  }
}
