import 'package:drivx/provider/AppData.dart';
import 'package:drivx/routes.dart';
import 'package:drivx/screens/mainScreen.dart';
import "package:drivx/screens/signInScreen.dart";
import 'package:drivx/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'components/Button.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await FirebaseApp.configure(
    options: Platform.isIOS || Platform.isMacOS
        ? FirebaseOptions(
      appId: '1:208461910166:ios:cb53e804d6d462cb29b2b7',
      apiKey: 'AIzaSyBXwNnIlA2i83rdz7vdq2il8Jc8hzBoVAU',
      projectId: 'drivx-d9475',
      messagingSenderId: '297855924061',
      databaseURL: 'https://drivx-d9475-default-rtdb.firebaseio.com',
    )
        : FirebaseOptions(
      appId: '1:208461910166:android:577e473fd479f86f29b2b7',
      apiKey: 'AIzaSyDa40qijodFxtXH5eXDAHGI_shjXrxM_Ck',
      databaseURL: 'https://drivx-d9475-default-rtdb.firebaseio.com',
      messagingSenderId: '297855924061',
      projectId: 'drivx-d9475',
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        theme: theme(),
        initialRoute: MainScreen.routeName,
        routes: routes,
      ),
    );
  }
}
