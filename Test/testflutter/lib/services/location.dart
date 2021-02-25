import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import '../main.dart';
import 'dart:io';

Future <void> getCurrentLocation()async{
  final Position geolocation = 
  await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
  currentPosition = geolocation;
}

Future <void> loadBuildings()async{
  final firestoreInstance = await FirebaseFirestore.instance.collection('GEOLOC2').get();
  firestoreInstance.docs.forEach((element) {
    print(element.id);
    geolocs.add(Geoloc(element.data(), element.id));
    print(element.data().values);
  });
}

Future <void> getClosestBuilding()async{
  double distanceToClosestObject = double.infinity;
  double tmp;
  int index = 0;
  print('Getting Closest Building...');
  print(geolocs.length);
  if(currentPosition != null && geolocs.length != 0){
    for(int i = 0; i < geolocs.length; i++){
      if(geolocs[i].isInside(Point([currentPosition.latitude, currentPosition.longitude])) == true){
        closestBuilding = geolocs[i];
        print('Inside');
        return;
      }else{
        print('here');
        tmp = geolocs[i].distance(Point([currentPosition.latitude, currentPosition.longitude]));
        print('here');
        if(tmp < distanceToClosestObject){
          distanceToClosestObject = tmp;
          index = i;
        }
      }
    }
  }
  closestBuilding = geolocs[index];
  print(tmp);

  // double distance = double.infinity;
  // int index;
  // if(currentPosition != null && geolocs.length != 0){
  //   for(int i = 0; i < geolocs.length; i++){
  //     if(geolocs[i].latitude != null && geolocs[i].longitude != null){
  //       double tmp = Geolocator.distanceBetween(currentPosition.latitude, currentPosition.longitude,
  //                                                geolocs[i].latitude, geolocs[i].longitude);
  //       if(tmp < distance){
  //         distance = tmp;
  //         index = i;
  //       }
  //     }
  //   }
  // }
  // closestBuilding = geolocs[index];
}

class Geoloc {
    String buildingId;
    String description;
    String lastUpdatedBy;
    
    List<Point> points = [];
    List<Line> lines = [];
    //DateTime lastUpdatedDate;
    double latitude;
    double longitude;

    Geoloc(Map<String, dynamic> data, String id){
      this.buildingId = id;
      this.description = data["Description"];
      this.lastUpdatedBy = data["LastUpdatedBy"];
      points.add(Point(data["Point1"]));
      points.add(Point(data["Point2"]));
      points.add(Point(data["Point3"]));
      points.add(Point(data["Point4"]));

      for(int i = 0; i < points.length; i++){
        print('${points[i].latitude}, ${points[i].longitude}');
      }

      if(points.length > 0){
        for(int i = 0; i < points.length; i++){
          lines.add(Line(p1: points[i % points.length], p2: points[(i + 1) % points.length]));
          //lines[i].printLine();
        }
      }
      //this.latitude = data["Latitude"];
      //this.longitude = data["Longitude"];
    }

    bool isInside(Point p1){
      int tmp1 = 0, tmp2 = 0;
      double x = p1.latitude;
      double y = p1.longitude;

      for(int i = 0; i < this.lines.length; i++){
        double a = this.lines[i].a;
        double b = this.lines[i].b;
        double c = this.lines[i].c;

        double xMin = this.lines[i].minLongitude;
        double xMax = this.lines[i].maxLongitude;
        double yMin = this.lines[i].minLatitude;
        double yMax = this.lines[i].maxLatitude;
        int direction = this.lines[i].direction;

        //print('${a * x + b * y + c}');

        if(x < xMax){
          if(direction == 1 || direction == 3 || direction == 5){
            if(y <= yMax && y > yMin){
              if((a * x + b * y + c) >= 0){
                tmp1++;
              }
            }
          }else if(direction == 2 || direction == 4 || direction == 6){
            if(y < yMax && y >= yMin){
              if((a * x + b * y + c) <= 0){
                tmp1++;
              }
            }
          }
        }
        if(x > xMin){
          if(direction == 1 || direction == 3 || direction == 5){
            if(y <= yMax && y > yMin){
              if((a * x + b * y + c) <= 0){
                tmp2++;
              }
            }
          }else if(direction == 2 || direction == 4 || direction == 6){
            if(y < yMax && y >= yMin){
              if((a * x + b * y + c) >= 0){
                tmp2++;
              }
            }
          }
        }
      }
      print('tmp1: $tmp1, tmp2: $tmp2');
      tmp1 = tmp1 % 2;
      tmp2 = tmp2 % 2;

      if(tmp1 == 1 && tmp2 == 1) return true;
      else return false;
    }

  double distance(Point currentLocation){
    int l = 0;
    print(l);
    l++;
    if(currentLocation != null && lines.length > 0){
      print(l);
      l++;
      List<Point> closestLinePoints = [];
      List<double> distanceToLine = [];
      int minI = 0;
      for(int i = 0; i < lines.length; i++){
        print(l);
        l++;
        closestLinePoints.add(_lineDistance(lines[i], currentLocation));
        distanceToLine.add(_pointDistance(closestLinePoints[i], currentLocation));
        if(distanceToLine[i] != null){
          if(distanceToLine[i] < distanceToLine[minI]) 
            minI = i;
        }
      }
      print('$l here');
      l++;
      double tmp = Geolocator.distanceBetween(currentLocation.latitude, currentLocation.longitude, closestLinePoints[minI].latitude, closestLinePoints[minI].longitude); 
      print('Closest point: ${closestLinePoints[minI].longitude}, ${closestLinePoints[minI].latitude}, $tmp');
      return tmp;
    }else{
      return null;
    }
  }

  Point _lineDistance(Line line, Point currentLocation){
    if(line != null && currentLocation != null){
      int r = 0;
      print('start _lineDistance $r');
      r++;

      double a = line.a;
      double b = line.b;
      double c = line.c;
      double p, x, y;

      if(a != 0 && b != 0){
        p = currentLocation.latitude - (b/a) * currentLocation.longitude;
        x = (p + (c/b)) / ((pow(a, 2)) + pow(b, 2))/(-b*a);
        y = (b/a)*x + p;
      }else{
        if(a == 0){
          x = currentLocation.longitude;
          y = line.p1.latitude;
        }else if(b == 0){
          x = line.p1.longitude;
          y = currentLocation.latitude;
        }
      }

      print('_lineDistance $r');
      r++;

      if(y <= line.maxLatitude && y >= line.minLatitude){
        if(x <= line.maxLongitude && x >= line.minLongitude){
          return Point([longitude, latitude]);
        }
      }
      print('_lineDistance $r');
      r++;
      double p1Dist = _pointDistance(line.p1, currentLocation);
      double p2Dist = _pointDistance(line.p2, currentLocation);

      if(p1Dist < p2Dist) return line.p1;
      else if(p1Dist < p2Dist) return line.p2;
      else if(p1Dist == p2Dist) return line.p1;
    }
    return null;

  }

  double _pointDistance(Point p1, Point p2){
    if(p1 == null || p2 == null)
      return null;
    else
      return Geolocator.distanceBetween(p1.latitude, p1.longitude, p2.latitude, p2.longitude);
  }
}

class Point{
  double latitude;
  double longitude;
  Point(List<dynamic> points){
    this.latitude = points[0];
    this.longitude = points[1];
  }
}

class Line{
  Point p1, p2;
  double a, b, c, maxLongitude, minLongitude, maxLatitude, minLatitude ;
  int direction;

  Line({this.p1, this.p2}){
    this.minLongitude = min(p1.longitude, p2.longitude);
    this.maxLongitude = max(p1.longitude, p2.longitude);
    this.minLatitude = min(p1.latitude, p2.latitude);
    this.maxLatitude = max(p1.latitude, p2.latitude);

    this.a = p1.latitude - p2.latitude;
    this.b = p2.longitude - p1.longitude;
    this.c = (p1.longitude * p2.latitude) - (p1.latitude * p2.longitude);

    this.direction = getDirection(p1, p2);
  }

  printLine(){
    print('p1: ${this.p1.longitude}, ${this.p1.latitude}');
    print('p2: ${this.p2.longitude}, ${this.p2.latitude}');
    print('xMin: ${this.minLongitude}, xMax: ${this.maxLongitude}');
    print('yMin: ${this.minLatitude}, yMax: ${this.maxLatitude}');
    print('direction: ${this.direction}\n');
  }

  int getDirection(Point p1, Point p2){
    if(p1.longitude < p2.longitude){
      if(p1.latitude < p2.latitude) return 1;
      else if(p1.latitude > p2.latitude) return 2;
      else return 0;
    }else if (p1.longitude > p2.longitude){
      if(p1.latitude < p2.latitude) return 3;
      else if(p1.latitude > p2.latitude) return 4;
      else return 0;
    }else{
      if(p1.latitude < p2.latitude) return 5;
      else if(p1.latitude > p2.latitude) return 6;
      else return 7;
    }
  }
}