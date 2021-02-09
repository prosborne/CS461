import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';

import 'package:testflutter/WKOView.dart';



class Temp {
  static String assets;
  static String descript;
  static DateTime timedue;
  static String id;
  static String prio;
  static String type;
  static String person;
}


class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: const Text(
              'Available WKOs',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Color(0xFFE0E0E0),
            leading: Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_sharp,
                    color: Colors.black,
                  ),
                ))),
        body: _unassWKO());
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Do you want to add this WKO to your todo list?'),
          content: SingleChildScrollView(),
          actions: <Widget>[
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _unassignedWKO() {
    return ListView(
      // This next line does the trick.
      scrollDirection: Axis.vertical,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: 10.0),
          child: Card(
              child: Column(
            children: [
              ListTile(
                  trailing: IconButton(
                    icon: Icon(Icons.add, color: Colors.black),
                    tooltip: 'Add WKO',
                    onPressed: () {
                      _showMyDialog();
                    },
                  ),
                  title: Text('Insert Notification Here'))
            ],
          )),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 10.0),
          child: Card(
              child: Column(
            children: [
              ListTile(
                  trailing: IconButton(
                    icon: Icon(Icons.add, color: Colors.black),
                    tooltip: 'Add WKO',
                    onPressed: () {
                      _showMyDialog();
                    },
                  ),
                  title: Text('Insert Notification Here'))
            ],
          )),
        ),
      ],
    );
  }

  Widget _unassWKO() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('WKO').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return new Text('Loading...');
        return new ListView(
          children: snapshot.data.docs.map((DocumentSnapshot document) {
            return new ListTile(
              //Display appropriate WKO for day, week, month tab view

              title: Card(
                  child: Column(
                children: [
                  Conditional.single(
                      context: context,
                      conditionBuilder: (BuildContext context) => true == true,
                      widgetBuilder: (BuildContext context) {
                        if (document['Personnel'].toString() ==
                            'DocumentReference(EMP/0000)') {
                          return Container(
                              child: ListTile(
                            title: Text(document['ID'].toString(),
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(document['Description'].toString(),
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            leading: IconButton(
                              icon: Icon(Icons.remove_red_eye),
                              color: Colors.black,
                                onPressed: () {
                                  //Set assets to pushed to next screen
                                  Temp.assets = document['Asset'].toString();
                                  Temp.descript =
                                      document['Description'].toString();
                                  Temp.timedue = document['Due'].toDate();
                                  Temp.id = document['ID'].toString();
                                  Temp.prio = document['Priority'].toString();
                                  Temp.type = document['Type'].toString();
                                  Temp.person =
                                      document['Personnel'].toString();
                                  //Push to next screen for selected WKO
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => WKOView(
                                              assets: Temp.assets,
                                              descript: Temp.descript,
                                              timedue: Temp.timedue,
                                              id: Temp.id,
                                              prio: Temp.prio,
                                              type: Temp.type,
                                              person: Temp.person)));
                                },
                             ),
                            trailing: IconButton(
                              icon: Icon(Icons.add, color: Colors.black),
                              tooltip: 'Add WKO',
                              onPressed: () {
                                _showMyDialog();
                              },
                            ),
                          ));
                        } else
                          return Container(
                              child: ListTile(
                            title: Text('This shouldnt be here :(',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            leading: IconButton(
                              icon: Icon(Icons.remove_red_eye),
                              color: Colors.black,
                                onPressed: () {
                                  
                                },
                             ),
                          ));
                      },
                      fallbackBuilder: (BuildContext context) {
                        return Text('hey');
                      }),
                ],
              )),
            );
          }).toList(),
        );
      },
    );
  }
}
