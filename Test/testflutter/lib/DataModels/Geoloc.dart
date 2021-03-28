import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'Point.dart';
import 'Line.dart';
import '../main.dart';
class Geoloc {
    String buildingId;
    String description;
    String lastUpdatedBy;
    //DateTime lastUpdatedDate;
    double latitude;
    double longitude;
    
    List<Point> points = [];
    List<Line> lines = [];

    Geoloc(Map<String, dynamic> data, String id){
      this.buildingId = id;
      this.description = data["Description"];
      this.lastUpdatedBy = data["LastUpdatedBy"];
      this.latitude = data["Latitude"];
      this.longitude = data["Longitude"];  
      if(geofence == true){
        points.add(Point(data["Point1"]));
        points.add(Point(data["Point2"]));
        points.add(Point(data["Point3"]));
        points.add(Point(data["Point4"]));
      }

      if(points.length > 0){
        for(int i = 0; i < points.length; i++){
          lines.add(Line(p1: points[i % points.length], p2: points[(i + 1) % points.length]));
        }
      }
    }

    // is_inside can determine if the point home is within the object.
    // the values of tmp1 and tmp2 are the counters for determining how many lines the point is
    // to the left of and right of respectively
    // The process of determining left and right is the same, just the inequalities are flipped
    // Left side:
    // loop through all the lines defined in obj
    // determine if the x coordinate for the point is less than the maximum value of x for the current line
    // use the direction to determine which inequality to use, if the line is running lower to higher the value
    // of ax+by+c needs to be greater than or equal to 0 to determine if the point is to the left,
    // if the line runs higher to lower then the inequality flips to less than or equal to
    // if either of this is true then tmp1 is incremented
    //
    // The right side is determined the same
    // if both tmp1 and tmp2 are odd, is_inside returns true indicating the point is inside the object
    // if they are unequal, zero or even then the point is outside the object
    bool isInside(Point p1){
      int left = 0, right = 0;
      double x = p1.longitude;
      double y = p1.latitude;

      for(int i = 0; i < this.lines.length; i++){
        double a = this.lines[i].a;
        double b = this.lines[i].b;
        double c = this.lines[i].c;

        double xMin = this.lines[i].minLongitude;
        double xMax = this.lines[i].maxLongitude;
        double yMin = this.lines[i].minLatitude;
        double yMax = this.lines[i].maxLatitude;
        int direction = this.lines[i].direction;

        //check if user to the left of current line
        if(x < xMax){
          if(direction == 1 || direction == 3 || direction == 5){
            if(y <= yMax && y > yMin){
              if((a * x + b * y + c) >= 0){
                left++;
              }
            }
          }else if(direction == 2 || direction == 4 || direction == 6){
            if(y < yMax && y >= yMin){
              if((a * x + b * y + c) <= 0){
                left++;
              }
            }
          }
        }
        //check if user is to the right of current line
        if(x > xMin){
          if(direction == 1 || direction == 3 || direction == 5){
            if(y <= yMax && y > yMin){
              if((a * x + b * y + c) <= 0){
                right++;
              }
            }
          }else if(direction == 2 || direction == 4 || direction == 6){
            if(y < yMax && y >= yMin){
              if((a * x + b * y + c) >= 0){
                right++;
              }
            }
          }
        }
      }
      left = left % 2;
      right = right % 2;

      if(left == 1 && right == 1) return true;
      else return false;
    }

  double distance(Point currentLocation){
    if(currentLocation != null && lines.length > 0){
      List<Point> closestLinePoints = [];
      List<double> distanceToLine = [];
      int minIndex = 0;
      for(int i = 0; i < lines.length; i++){
        closestLinePoints.add(_lineDistance(lines[i], currentLocation));
        distanceToLine.add(_pointDistance(closestLinePoints[i], currentLocation));
        if(distanceToLine[i] != null){
          if(distanceToLine[i] < distanceToLine[minIndex]) 
            minIndex = i;
        }
      }
      double tmp = Geolocator.distanceBetween(currentLocation.latitude, currentLocation.longitude, closestLinePoints[minIndex].latitude, closestLinePoints[minIndex].longitude); 
      return tmp;
    }else{
      return null;
    }
  }

  Point _lineDistance(Line line, Point currentLocation){
    if(line != null && currentLocation != null){
      int r = 0;
      r++;

      double a = line.a;
      double b = line.b;
      double c = line.c;
      double p, x, y;

      if(a != 0 && b != 0){
        p = currentLocation.latitude - (b/a) * currentLocation.longitude;
        x = (p + (c/b)) / ((pow(a, 2) + pow(b, 2))/(-b*a));
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
      r++;
      if(y <= line.maxLatitude && y >= line.minLatitude){
        if(x <= line.maxLongitude && x >= line.minLongitude){
          return Point([y, x]);
        }
      }
      r++;
      double p1Dist = _pointDistance(line.p1, currentLocation);
      double p2Dist = _pointDistance(line.p2, currentLocation);

      if(p1Dist < p2Dist){
        return line.p1;
      }
      else if(p1Dist > p2Dist){
        return line.p2;
      }
      else if(p1Dist == p2Dist){
        return line.p1;
      }
    }
    return null;

  }

  double _pointDistance(Point p1, Point p2){
    if(p1 == null || p2 == null){
      return null;
    }
    else
      return Geolocator.distanceBetween(p1.latitude, p1.longitude, p2.latitude, p2.longitude);
  }
}