import 'package:geolocator/geolocator.dart';

// ignore: non_constant_identifier_names
Position get_current_location() {
  Geolocator
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
      .then((Position position) {
      print('${position.longitude.toString()}, ${position.latitude.toString()}');
    return position;
  }).catchError((e) {
    print(e);
  });
}