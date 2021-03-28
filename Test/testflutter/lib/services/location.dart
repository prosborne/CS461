import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import '../main.dart';
import '../DataModels/Geoloc.dart';
import '../DataModels/Point.dart';


Future <void> getCurrentLocation()async{
  final Position geolocation = 
  await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
  currentPosition = geolocation;
}

Future <void> loadBuildings()async{
  if(geofence == false){
    final firestoreInstance = await FirebaseFirestore.instance.collection('GEOLOC').get();
    firestoreInstance.docs.forEach((element) {
      //print(element.id);
      geolocs.add(Geoloc(element.data(), element.id));
      //print(element.data().values);
    });
  }else{
    await getCurrentLocation();
    final firestoreInstance = await FirebaseFirestore.instance.collection('GEOFENCE').get();
    firestoreInstance.docs.forEach((element) {
      geolocs.add(Geoloc(element.data(), element.id));
    });
  }
}

Future <void> getClosestBuilding()async{
  if(geofence == false){
    double distance = double.infinity;
    int index;
    if(currentPosition != null && geolocs.length != 0){
      for(int i = 0; i < geolocs.length; i++){
        if(geolocs[i].latitude != null && geolocs[i].longitude != null){
          double tmp = Geolocator.distanceBetween(currentPosition.latitude, currentPosition.longitude, geolocs[i].latitude, geolocs[i].longitude);
          print('${geolocs[i].description}: ${geolocs[i].latitude}, ${geolocs[i].longitude}, distance: $tmp');
          if(tmp < distance){
            distance = tmp;
            index = i;
          }
        }
      }
    }
    closestBuilding = geolocs[index];
}else{
  double distanceToClosestObject = double.infinity;
  double closestDistance;
  int index = 0;
  if(currentPosition != null && geolocs.length != 0){
    for(int i = 0; i < geolocs.length; i++){
      print('checking isInside');
      if(geolocs[i].isInside(Point([currentPosition.latitude, currentPosition.longitude])) == true){
        print('inside ${geolocs[i].description}');
        closestBuilding = geolocs[i];
        return;
      }else{
        print('checking Distance');
        closestDistance = geolocs[i].distance(Point([currentPosition.latitude, currentPosition.longitude]));

        if(closestDistance < distanceToClosestObject){
          distanceToClosestObject = closestDistance;
          index = i;
        }
      }
    }
  }
  closestBuilding = geolocs[index];
  print('Closest Building is ${geolocs[index].description} at $distanceToClosestObject meters away');
  }
}
