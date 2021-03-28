class Point{
  double latitude;
  double longitude;
  Point(List<dynamic> points){
    this.latitude = points[0];
    this.longitude = points[1];
  }
}