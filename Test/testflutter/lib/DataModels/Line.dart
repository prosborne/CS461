import 'dart:math';

import 'Point.dart';
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

  // get_direction will use the values in p1 and p2 to determine the direction the line is going
  // the actual direction is irrelevent but it needs to be uniform in order to define the corners of the
  // object correctly. Otherwise, if the point is parallel with a corner, the program will not be able to
  // determine if the point is inside or outside the object.
  // the return values are as follows:
  
  //  0 - horizontal line
  //  1 - diagonal left to right and lower to higher
  //  2 - diagonal left to right and higher to lower
  //  3 - diagonal right to left and lower to higher
  //  4 - diagonal right to left and higher to lower
  //  5 - vertical line running down
  //  6 - vertical line running up
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