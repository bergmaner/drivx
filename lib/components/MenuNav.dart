import 'package:drivx/components/HorizontalDivider.dart';
import 'package:drivx/components/Icon.dart';
import "package:flutter/material.dart";

class MenuNav extends StatefulWidget {
  @override
  _MenuNavState createState() => _MenuNavState();
}

class _MenuNavState extends State<MenuNav> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            color: Colors.white,
            height: 160,
            child: DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
              child:Row(
                children:<Widget>[
                  CustomIcon(svgIcon: "assets/icons/avatar.svg",height: 80),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:<Widget>[
                      Text("kolo", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
                      SizedBox(height: 5),
                      Text("View Profile", textAlign: TextAlign.left,)
                    ]
                  )
                ]
              ),
          ),
          ),
          HorizontalDivider(),
          SizedBox( height: 10),
          ListTile(
            leading: CustomIcon(svgIcon: "assets/icons/free.svg", height: 20),
            title: Text('Free Rides'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: CustomIcon(svgIcon: "assets/icons/payments.svg", height: 20),
            title: Text('Payments'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: CustomIcon(svgIcon: "assets/icons/history.svg", height: 20),
            title: Text('Ride History'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: CustomIcon(svgIcon: "assets/icons/support.svg", height: 20),
            title: Text('Support'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: CustomIcon(svgIcon: "assets/icons/about.svg", height: 20),
            title: Text('About'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
