import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geolocator/geolocator.dart';
import 'package:testflutter/Login.dart';

import 'services/location.dart';
import 'services/location.dart';
import 'services/location.dart';
import 'services/location.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

List<Geoloc> geolocs = [];
Position currentPosition;
List<Geoloc> closestBuilding = [];

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState(){
    _startup();
    // if(currentPosition != null && geolocs.length > 0){
    //   print('...getClosestBuilding');
    //   getClosestBuilding();
    //   //print(closestBuilding);
    // }
    super.initState();
    // if(currentPosition != null){
    //   print('finished');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //home: CircularProgressIndicator()
      home: LoginScreen(),
    );
  }

  Future<void> _startup()async{ 
    await loadBuildings();
    print('...loadBuilding');
    print('..getting location');
    // await getCurrentLocation();
    print('..getting closest building');
    await getClosestBuilding();
    print(closestBuilding[0].buildingId.toString());
  }
}
