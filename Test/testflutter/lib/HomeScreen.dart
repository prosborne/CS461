import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:testflutter/Login.dart';

import 'package:testflutter/Settings.dart';
import 'package:testflutter/WKOView.dart';
import 'package:testflutter/Timer.dart';
import 'package:testflutter/Notification.dart';
import 'package:geolocator/geolocator.dart';

final databaseReference = FirebaseFirestore.instance;
final String kly = 'DocumentReference(GEOLOC/wrWnYGNTwRwasNXwmMtS)';
final String bnd = 'DocumentReference(EMP/YuDRVKSwtaWEz00cXiPA)';
final categoryDocRef =
    databaseReference.collection('GEOLOC').doc('wrWnYGNTwRwasNXwmMtS');

class Checker {
  static String check = '';
}

class WKO {
  static String assets;
  static String descript;
  static DateTime timedue;
  static String id;
  static String prio;
  static String type;
  static String person;
}

class DayObject {
  static DateTime _today = DateTime.now();
  static DateTime _timestamp;
}

class HomeScreen extends StatefulWidget {
  final String user;
  HomeScreen({Key key, @required this.user}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState(user);
}

/// This is the private State class that goes with HomeScreen.
class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  int _index;
  String username;
  _HomeScreenState(this.username);

  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 3, vsync: this);
    _index = 0;
  }

  void clickNotification() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => NotificationScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabItems(),
      bottomNavigationBar: _bottomNav(),
    );
  }

  Widget _tabItems() {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.search,
          color: Colors.black,
        ),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  clickNotification();
                },
                child: Icon(
                  Icons.notifications,
                  color: Colors.black,
                ),
              )),
        ],
        title: TextField(
          decoration:
              InputDecoration(border: InputBorder.none, hintText: 'Search....'),
          cursorColor: Colors.white,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFFE0E0E0),
        bottom: TabBar(
          controller: _controller,
          labelColor: Colors.black,
          tabs: [
            Tab(icon: Text('Due: Today')),
            Tab(icon: Text('Due: Week')),
            Tab(icon: Text('Due: Month')),
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: [
          Center(child: _dailyWKO()),
          Center(child: _weeklyWKO()),
          Center(child: _monthlyWKO()),
        ],
      ),
    );
  }

  //Bottom nav bar
  Widget _bottomNav() {
    return BottomNavigationBar(
      currentIndex: _index,
      onTap: (int _index) {
        setState(() {
          this._index = _index;
        });
        if (_index == 1) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginScreen()));
        }

        if (_index == 2) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MyTimer(user: null,)));
        }
        if (_index == 3) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SettingsPage()));
        }
      },
      type: BottomNavigationBarType.fixed,
      backgroundColor: Color(0xFFE0E0E0),
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.grading),
          label: 'WKO',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.build),
          label: 'MR',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.query_builder),
          label: 'Timer',
          //  activeIcon:
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      selectedItemColor: Colors.red,
    );
  }

  //Display daily work orders
  Widget _dailyWKO() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('WKO').snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) return new Text('Loading...');
          return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Conditional.single(
                        context: context,
                        conditionBuilder: (BuildContext context) =>
                            true == true,
                        widgetBuilder: (BuildContext context) {
                          DayObject._timestamp =
                              snapshot.data.docs[index]['Due'].toDate();
                          if ((DayObject._timestamp.month ==
                                  DayObject._today.month) &&
                              (DayObject._timestamp.day ==
                                  DayObject._today.day)) {
                            return GestureDetector(
                                onTap: () {
                                  //Set assets to pushed to next screen
                                  String assetWKO = snapshot
                                      .data.docs[index]['Asset']
                                      .toString();
                                  _assetChecker(assetWKO);
                                  WKO.descript = snapshot
                                      .data.docs[index]['Description']
                                      .toString();
                                  WKO.timedue =
                                      snapshot.data.docs[index]['Due'].toDate();
                                  WKO.id = snapshot.data.docs[index]['ID']
                                      .toString();
                                  WKO.prio = snapshot
                                      .data.docs[index]['Priority']
                                      .toString();
                                  WKO.type = snapshot.data.docs[index]['Type']
                                      .toString();
                                  String personWKO = snapshot
                                      .data.docs[index]['Personnel']
                                      .toString();
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
                                        snapshot.data.docs[index]['ID']
                                            .toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    subtitle: Text(
                                        snapshot.data.docs[index]['Description']
                                            .toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ));
                          } else
                            return SizedBox(
                              height: 0.1,
                            );
                        },
                        fallbackBuilder: (BuildContext context) {
                          return Text('filler');
                        }),
                  ],
                );
              });
        });
  }

  //Display weekly work orders
  Widget _weeklyWKO() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('WKO').snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) return new Text('Loading...');
          return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Conditional.single(
                        context: context,
                        conditionBuilder: (BuildContext context) =>
                            true == true,
                        widgetBuilder: (BuildContext context) {
                          DayObject._timestamp =
                              snapshot.data.docs[index]['Due'].toDate();
                          var check = false;
                          var monthdiff = (DayObject._timestamp.month -
                              DayObject._today.month);
                          if (monthdiff == 0 &&
                              ((DayObject._timestamp.day -
                                      DayObject._today.day) <
                                  7)) {
                            check = true;
                          } else if (monthdiff <= 1) {
                            var WKO = DayObject._timestamp.day + 30;
                            var WKO2 = (WKO - DayObject._today.day);
                            if (WKO2 < 7)
                              check = true;
                            else {
                              check = false;
                            }
                          } else {
                            check = true;
                          }
                          if (check == true) {
                            return GestureDetector(
                                onTap: () {
                                  String assetWKO = snapshot
                                      .data.docs[index]['Asset']
                                      .toString();
                                  _assetChecker(assetWKO);
                                  WKO.descript = snapshot
                                      .data.docs[index]['Description']
                                      .toString();
                                  WKO.timedue =
                                      snapshot.data.docs[index]['Due'].toDate();
                                  WKO.id = snapshot.data.docs[index]['ID']
                                      .toString();
                                  WKO.prio = snapshot
                                      .data.docs[index]['Priority']
                                      .toString();
                                  WKO.type = snapshot.data.docs[index]['Type']
                                      .toString();
                                  String personWKO = snapshot
                                      .data.docs[index]['Personnel']
                                      .toString();
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
                                        snapshot.data.docs[index]['ID']
                                            .toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    subtitle: Text(
                                        snapshot.data.docs[index]['Description']
                                            .toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ));
                          } else
                            return SizedBox(
                              height: 0.1,
                            );
                        },
                        fallbackBuilder: (BuildContext context) {
                          return Text('filler');
                        }),
                  ],
                );
              });
        });
  }

  //Display monthly work orders
  Widget _monthlyWKO() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('WKO').snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) return new Text('Loading...');
          return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Conditional.single(
                        context: context,
                        conditionBuilder: (BuildContext context) =>
                            true == true,
                        widgetBuilder: (BuildContext context) {
                          DayObject._timestamp =
                              snapshot.data.docs[index]['Due'].toDate();
                          var check = false;
                          var monthdiff = (DayObject._timestamp.month -
                              DayObject._today.month);
                          if (monthdiff < 1)
                            check = true;
                          else {
                            check = false;
                          }
                          if (check == true) {
                            return GestureDetector(
                                onTap: () {
                                  //Set assets to pushed to next screen
                                  String assetWKO = snapshot
                                      .data.docs[index]['Asset']
                                      .toString();
                                  _assetChecker(assetWKO);
                                  WKO.descript = snapshot
                                      .data.docs[index]['Description']
                                      .toString();
                                  WKO.timedue =
                                      snapshot.data.docs[index]['Due'].toDate();
                                  WKO.id = snapshot.data.docs[index]['ID']
                                      .toString();
                                  WKO.prio = snapshot
                                      .data.docs[index]['Priority']
                                      .toString();
                                  WKO.type = snapshot.data.docs[index]['Type']
                                      .toString();
                                  String personWKO = snapshot
                                      .data.docs[index]['Personnel']
                                      .toString();
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
                                        snapshot.data.docs[index]['ID']
                                            .toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    subtitle: Text(
                                        snapshot.data.docs[index]['Description']
                                            .toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ));
                          } else
                            return SizedBox(
                              height: 0.1,
                            );
                        },
                        fallbackBuilder: (BuildContext context) {
                          return Text('filler');
                        }),
                  ],
                );
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
