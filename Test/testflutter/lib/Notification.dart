import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';

import 'package:testflutter/WKOView.dart';

class WKO {
  static String assets;
  static String descript;
  static DateTime timedue;
  static String id;
  static String prio;
  static String type;
  // static String person;
  static String person;
}

class Notifier {
  static bool isAvailable = false;
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
        body: _unassignedWKO());
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
    //databaseReference.collection('WKO').snapshots().listen((snapshot){});

    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('WKO').snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) return new Text('Loading...');
          return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                return Column(children: [
                  if (snapshot.data.docs[index]['Personnel'].toString() ==
                      'DocumentReference(EMP/0000)')

                    // Text((snapshot.data.docs[index]['Personnel'])),
                    GestureDetector(
                        onTap: () {
                          //Set assets to pushed to next screen
                          String assetWKO =
                              snapshot.data.docs[index]['Asset'].toString();
                          _assetChecker(assetWKO);
                          WKO.descript = snapshot
                              .data.docs[index]['Description']
                              .toString();
                          WKO.timedue =
                              snapshot.data.docs[index]['Due'].toDate();
                          WKO.id = snapshot.data.docs[index]['ID'].toString();
                          WKO.prio =
                              snapshot.data.docs[index]['Priority'].toString();
                          WKO.type =
                              snapshot.data.docs[index]['Type'].toString();
                          String personWKO =
                              snapshot.data.docs[index]['Personnel'].toString();
                          _personChecker(personWKO);
                          //Push to next screen for selected WKO
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WKOView(
                                      assets: WKO.assets,
                                      descript: WKO.descript,
                                      timedue: WKO.timedue,
                                      id: WKO.id,
                                      prio: WKO.prio,
                                      type: WKO.type,
                                      person: WKO.person)));
                        },
                        child: Container(
                          child: ListTile(
                            title: Text(
                                snapshot.data.docs[index]['ID'].toString(),
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(
                                snapshot.data.docs[index]['Description']
                                    .toString(),
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            trailing: IconButton(
                              icon: Icon(Icons.add, color: Colors.black),
                              tooltip: 'Add WKO',
                              onPressed: () {
                                _showMyDialog();
                              },
                            ),
                          ),
                        ))
                ]);
              });
        });
  }

  void _assetChecker(String x) {
    switch (x) {
      case ('DocumentReference(GEOLOC/wrWnYGNTwRwasNXwmMtS)'):
        {
          WKO.assets = 'Kelly Engineering Center';
          print('kelly Engineering Center');
        }
        break;
      case ('DocumentReference(GEOLOC/rHjy81bXaT3LM5ENIaH0)'):
        {
          WKO.assets = 'OSU Foundation Center';
          print('OSU Foundation Center');
        }
        break;
      case ('DocumentReference(GEOLOC/RwIJdGEHDFcQS8jmuddR)'):
        {
          WKO.assets = 'OSU Botany Farm';
          print('OSU Botany Farm');
        }
        break;
      case ('DocumentReference(GEOLOC/8Pd9jydcDhmTpwkBNrMS)'):
        {
          WKO.assets = 'Johnson Hall';
          print('Johnson Hall');
        }
        break;
      default:
        {
          WKO.assets = 'Default Location';
          print('Broken');
        }
        break;
    }
  }

  void _personChecker(String x) {
    switch (x) {
      case ('DocumentReference(EMP/0000)'):
        {
          WKO.person = 'Unassigned';
          print('Unassigned');
        }
        break;
      case ('DocumentReference(EMP/HhB68yRmzFGbRnJf2GHP)'):
        {
          WKO.person = 'Hunter Christensen';
          print('Hunter C');
        }
        break;
      case ('DocumentReference(EMP/YuDRVKSwtaWEz00cXiPA)'):
        {
          WKO.person = 'Branden Holloway';
          print('Branden H');
        }
        break;
      case ('DocumentReference(EMP/Z3hNoEArVupMxARPCe3R)'):
        {
          WKO.person = 'Spencer Big';
          print('Spencer B');
        }
        break;
      default:
        {
          WKO.person = 'Default person';
          print('Broken');
        }
        break;
    }
  }
}
