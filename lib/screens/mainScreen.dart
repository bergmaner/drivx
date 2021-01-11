import 'dart:async';
import 'package:drivx/components/Button.dart';
import 'package:drivx/components/HorizontalDivider.dart';
import 'package:drivx/components/MenuNav.dart';
import 'package:drivx/components/ProgressDialog.dart';
import 'package:drivx/helpers/fireHeper.dart';
import 'package:drivx/helpers/helperMethods.dart';
import 'package:drivx/models/directionDetails.dart';
import 'package:drivx/models/nearbydriver.dart';
import 'package:drivx/provider/AppData.dart';
import 'package:drivx/screens/searchScreen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:drivx/constants.dart';
import 'package:drivx/components/Icon.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  static String routeName = "/mainScreen";
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  DirectionDetails tripDirectionDetails;
  var geolocator = Geolocator();
  Position currentPosition;
  double rideDetailsHeight = 0;
  double searchContainerHeight = 340;
  double requestContainerHeight = 0;
  bool isOpen = false;
  List<LatLng> polylineCoords = [];
  Set<Polyline> _polylines = {};
  Set<Circle> _circles = {};
  Set<Marker> _markers = {};

  DatabaseReference rideRequestRef;

  void setCurrentPosition() async {
    Position position = await geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;
    LatLng pos = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition = new CameraPosition(target: pos, zoom:14);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    geofireListener();
  }

  void showDetailsContainer()async{
    await getDirection();
    setState(() {
      searchContainerHeight = 0;
      rideDetailsHeight = 300;
      isOpen = true;
    });
  }

  @override
  void initState() {
    super.initState();
    HelperMethods.getCurrentUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: googlePlex,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            zoomGesturesEnabled: true,
            polylines: _polylines,
            circles: _circles,
            markers: _markers,
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
                (isOpen)?
                resetApp():
                scaffoldKey.currentState.openDrawer();
              },
              elevation: 2.0,
              fillColor: Colors.white,
              child: Icon(
                (isOpen)?
                Icons.arrow_back :
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
            child: AnimatedSize(
              vsync: this,
              duration: new Duration(milliseconds: 150),
              curve: Curves.easeIn,
              child: Container(
                height: searchContainerHeight,
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
                        onTap: () async{
                          var response = await Navigator.pushNamed(context, SearchScreen.routeName);

                          if (response == "getDirection") {
                            showDetailsContainer();
                          }
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
                                Text("Search Destination",style: TextStyle(fontWeight: FontWeight.bold))
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
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                               Text(
                                    Provider.of<AppData>(context).pickupAddress != null ?
                                    Provider.of<AppData>(context).pickupAddress.placeAddress :
                                    "Add address",
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontWeight: FontWeight.bold,)
                                ),
                                SizedBox(height:3),
                                Text("Your home address", style: TextStyle(fontSize: 11, color: Color(0xFFadadad)))
                              ]
                            )
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
                                    Text("Add Work",style: TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,),
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
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
              child: AnimatedSize(
                vsync: this,
                duration: new Duration(milliseconds: 150),
                curve: Curves.easeIn,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 15.0, // soften the shadow
                        spreadRadius: 0.5, //extend the shadow
                        offset: Offset(
                          0.7, // Move to right 10  horizontally
                          0.7, // Move to bottom 10 Vertically
                        ),
                      )
                    ],

                  ),
                  height: rideDetailsHeight,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 18),
                    child: Column(
                      children: <Widget>[

                        Container(
                          width: double.infinity,
                          color: Color(0xFFe3fded),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: <Widget>[
                                CustomIcon(svgIcon: "assets/icons/taxi.svg", height: 30),
                                SizedBox(width: 16,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Taxi', style: TextStyle(fontSize: 18, fontFamily: 'Brand-Bold'),),
                                    Text( (tripDirectionDetails != null) ? tripDirectionDetails.distanceText : "", style: TextStyle(fontSize: 16, color: Color(0xFF918D8D)),)

                                  ],
                                ),
                                Expanded(child: Container()),
                                Text((tripDirectionDetails != null) ? '${HelperMethods.calculatePrices(tripDirectionDetails)} PLN' : "", style: TextStyle(fontSize: 18, fontFamily: 'Brand-Bold'),),

                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 22,),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: <Widget>[
                              Column(
                                  children: <Widget>[
                                SizedBox(height:8),
                                CustomIcon(svgIcon:"assets/icons/money.svg", height: 30),
                              ]
                              ),
                              SizedBox(width: 16,),
                              Text('Cash'),
                              SizedBox(width: 5,),
                              Icon(Icons.keyboard_arrow_down, color: Color(0xFF918D8D), size: 16,),
                            ],
                          ),
                        ),

                        SizedBox(height: 22,),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Button(text: "Request", press: (){
                            showRequestContainer();
                          })
                        )

                      ],
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedSize(
              vsync: this,
              duration: new Duration(milliseconds: 150),
              curve: Curves.easeIn,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 15.0, // soften the shadow
                      spreadRadius: 0.5, //extend the shadow
                      offset: Offset(
                        0.7, // Move to right 10  horizontally
                        0.7, // Move to bottom 10 Vertically
                      ),
                    )
                  ],
                ),
                height: requestContainerHeight,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[

                      SizedBox(height: 10,),
                      LinearProgressIndicator(
                        backgroundColor: Color(0xffffa8a8),
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xfff00000)),
                      ),
                      SizedBox(
                      height: 10
                      ),
                      Text(
                        'Requesting a Ride...',
                         style: TextStyle(
                            color: Color(0xFF383635),
                            fontSize: 22.0,
                            fontFamily: 'Brand-Bold'
                        ),
                      ),
                      SizedBox(height: 20,),

                      GestureDetector(
                        onTap: (){
                          cancelRequest();
                          resetApp();
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(width: 1.0, color: Color(0xFFe1e5e8)),

                          ),
                          child: Icon(Icons.close, size: 25,),
                        ),
                      ),

                      SizedBox(height: 10,),

                      Container(
                        width: double.infinity,
                        child: Text(
                          'Cancel ride',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
      drawer:MenuNav()
    );
  }

  Future<void> getDirection() async{
    var pickup = Provider.of<AppData>(context, listen: false).pickupAddress;
    var destination = Provider.of<AppData>(context, listen: false).destinationAddress;

    var pickupLatLng = LatLng(pickup.latitude, pickup.longitude);
    var destinationLatLng = LatLng(destination.latitude, destination.longitude);

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressDialog(status: "Please wait..."),
    );

    var directionDetails = await HelperMethods.getDirectionDetails(pickupLatLng, destinationLatLng);

    setState(() {
      tripDirectionDetails = directionDetails;
    });

    Navigator.pop(context);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> results = polylinePoints.decodePolyline(directionDetails.encodedPoints);

    polylineCoords.clear();

    if(results.isNotEmpty){
      results.forEach((PointLatLng points) {
        polylineCoords.add(LatLng(points.latitude,points.longitude));
      });
    }

    _polylines.clear();

    setState(() {
      Polyline polyline = Polyline(
        polylineId: PolylineId("polyid"),
        color: Color(0xfff00000),
        points: polylineCoords,
        jointType: JointType.round,
        width: 4,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );
      _polylines.add(polyline);
    });

    LatLngBounds bounds;

    if(pickupLatLng.latitude > destinationLatLng.latitude && pickupLatLng.longitude > destinationLatLng.longitude){
      bounds = LatLngBounds(southwest: destinationLatLng, northeast: pickupLatLng);
    }
    else if(pickupLatLng.longitude > destinationLatLng.longitude){
      bounds = LatLngBounds(
          southwest: LatLng(pickupLatLng.latitude , destinationLatLng.longitude),
          northeast: LatLng(destinationLatLng.latitude, pickup.longitude));
    }
    else if(pickupLatLng.latitude > destinationLatLng.latitude){
    bounds = LatLngBounds(
    southwest: LatLng(destinationLatLng.latitude, pickupLatLng.longitude),
    northeast: LatLng(pickupLatLng.latitude, destinationLatLng.longitude),
    );
    }
    else{
    bounds = LatLngBounds(southwest: pickupLatLng, northeast: destinationLatLng);
    }

    mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));

    Marker pickupMarker = Marker(
      markerId: MarkerId("pickup"),
      position: pickupLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      infoWindow: InfoWindow(title: pickup.placeName, snippet: "My Location")
    );
    Marker destinationMarker = Marker(
        markerId: MarkerId("destination"),
        position: destinationLatLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(title: destination.placeName, snippet: "My Destination")
    );

    setState(() {
      _markers.add(pickupMarker);
      _markers.add(destinationMarker);
    });

    Circle pickupCircle = Circle(
      circleId: CircleId("pickup"),
      strokeColor: Colors.red,
      strokeWidth: 3,
      radius: 12,
      center: pickupLatLng,
      fillColor: Colors.blue
    );
    Circle destinationCircle = Circle(
        circleId: CircleId("destination"),
        strokeColor: Colors.red,
        strokeWidth: 3,
        radius: 12,
        center: pickupLatLng,
        fillColor: Colors.blue
    );

    setState(() {
      _circles.add(pickupCircle);
      _circles.add(destinationCircle);
    });
  }

      void showRequestContainer(){
        setState(() {

          rideDetailsHeight = 0;
          requestContainerHeight = 200;
          isOpen = false;

        });

        createRequest();

      }
      void createRequest() async {
        rideRequestRef = FirebaseDatabase.instance.reference().child("rideRequest").push();
        var pickup = Provider.of<AppData>(context, listen:false).pickupAddress;
        var destination = Provider.of<AppData>(context, listen:false).destinationAddress;

        Map pickupMap = {
          "latitude": pickup.latitude.toString(),
          "longitude": pickup.longitude.toString()
        };

        Map destinationMap = {
          "latitude": destination.latitude.toString(),
          "longitude": destination.longitude.toString()
        };

        Map rideMap = {
          "created_at": DateTime.now().toString(),
          "rider_name": currentUserInfo.fullName,
          "rider_phone": currentUserInfo.phone,
          "pickup_address": pickup.placeName,
          "destination_address": destination.placeName,
          "location": pickupMap,
          "destination": destinationMap,
          "payment_method": "card",
          "driver_id": "waiting",

        };

        rideRequestRef.set(rideMap);
      }
      void cancelRequest() async {
        rideRequestRef.remove();
      }
      void geofireListener(){
        Geofire.initialize("driversAvaible");
        Geofire.queryAtLocation(currentPosition.latitude, currentPosition.longitude, 20).listen((map) {
          print(map);
          if (map != null) {
            var callBack = map['callBack'];
            switch (callBack) {
              case Geofire.onKeyEntered:

                NearbyDriver nearbyDriver = NearbyDriver();
                nearbyDriver.key = map['key'];
                nearbyDriver.latitude = map['latitude'];
                nearbyDriver.longitude = map['longitude'];
                print('nnn: ${nearbyDriver}');
                FireHelper.nearbyDriverList.add(nearbyDriver);

                break;
              case Geofire.onKeyExited:

                FireHelper.removeFromList(map['key']);

                break;
              case Geofire.onKeyMoved:

                NearbyDriver nearbyDriver = NearbyDriver();
                nearbyDriver.key = map['key'];
                nearbyDriver.latitude = map['latitude'];
                nearbyDriver.longitude = map['longitude'];
                FireHelper.updateLocation(nearbyDriver);

                break;
              case Geofire.onGeoQueryReady:
                print("XDDDDD");
                print('length: ${FireHelper.nearbyDriverList.length}');
              break;
            }
          }
        });
      }
      resetApp(){

        setState(() {

          polylineCoords.clear();
          _polylines.clear();
          _markers.clear();
          _circles.clear();
          rideDetailsHeight = 0;
          requestContainerHeight=0;
          searchContainerHeight = 340;
          isOpen = false;

        });

        setCurrentPosition();

      }
      }
