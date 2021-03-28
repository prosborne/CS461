import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geolocator/geolocator.dart';
import 'package:testflutter/Login.dart';
import 'package:flutter/services.dart';


import 'services/location.dart';
import 'DataModels/Geoloc.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.white, // status bar color
  ));

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

List<Geoloc> geolocs = [];
bool geofence = true;
Position currentPosition;
Geoloc closestBuilding;

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState(){
    _startup();
    if(currentPosition != null && geolocs.length > 0){
      getClosestBuilding();
    //  print(closestBuilding);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginScreen(),
    );
  }

  Future<void> _startup()async{
    await loadBuildings();
  //  print(geolocs.length);
    await getCurrentLocation();
  //  print(currentPosition.latitude.toString());
    print('${currentPosition.latitude}, ${currentPosition.longitude}');
    await getClosestBuilding();
    print(closestBuilding.description);
    print('${closestBuilding.latitude}, ${closestBuilding.longitude}');
  }
}
