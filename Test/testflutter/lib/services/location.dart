import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import '../main.dart';


Future <void> getCurrentLocation()async{
  final Position geolocation = 
  await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
  currentPosition = geolocation;
}

Future <void> loadBuildings()async{
  final firestoreInstance = await FirebaseFirestore.instance.collection('GEOLOC').get();
  firestoreInstance.docs.forEach((element) {
    //print(element.id);
    geolocs.add(Geoloc(element.data(), element.id));
    //print(element.data().values);
  });
}

Future <void> getClosestBuilding()async{
  double distance = double.infinity;
  int index;
  if(currentPosition != null && geolocs.length != 0){
    for(int i = 0; i < geolocs.length; i++){
      if(geolocs[i].latitude != null && geolocs[i].longitude != null){
        double tmp = Geolocator.distanceBetween(currentPosition.latitude, currentPosition.longitude, geolocs[i].latitude, geolocs[i].longitude);
        if(tmp < distance){
          distance = tmp;
          index = i;
        }
      }
    }
  }
  closestBuilding = geolocs[index];
}

class Geoloc {
    String buildingId;
    String description;
    String lastUpdatedBy;
    //DateTime lastUpdatedDate;
    double latitude;
    double longitude;

    Geoloc(Map<String, dynamic> data, String id){
      this.buildingId = id;
      this.description = data["Description"];
      this.lastUpdatedBy = data["LastUpdatedBy"];
      this.latitude = data["Latitude"];
      this.longitude = data["Longitude"];  
    }
}