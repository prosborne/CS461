import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';

import 'package:testflutter/Settings.dart';
import 'package:testflutter/WKOView.dart';
import 'package:testflutter/Timer.dart';
import 'package:testflutter/Notification.dart';


class TestScreen extends StatefulWidget {
  final String user;
  TestScreen({Key key, @required this.user}) : super(key: key);
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _testQuery(),
      
    );
  }


  Widget _testQuery(){

  }












}