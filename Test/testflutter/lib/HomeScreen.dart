import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';

import 'package:testflutter/Settings.dart';
import 'package:testflutter/WKOView.dart';
import 'package:testflutter/Timer.dart';
import 'package:testflutter/Notification.dart';

class Checker {
  static String check = '';
}

class Temp {
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
  static DateTime _weekahead =
      DateTime(_today.year, _today.month, (_today.day + 7));
  static DateTime _timestamp;
}

class HomeScreen extends StatefulWidget {
  final String user;
  HomeScreen({Key key, @required this.user}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

/// This is the private State class that goes with HomeScreen.
class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  int _index;

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
    String user = 'Branden Holloway';
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
          Center(child: _weekWKO()),
          Center(child: _monthlyWKO()),
        ],
      ),
    );
  }


//Daily Work Order Function
  Widget _dailyWKO() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('WKO').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return new Text('Loading...');
        return new ListView(
          children: snapshot.data.docs.map((DocumentSnapshot document) {
            DayObject._timestamp = document['Due'].toDate();
            //if(((DayObject._weekahead.day) - (DayObject._timestamp.day)) < 7) {
            if (DayObject._timestamp.month == 4) {
              Checker.check = 'Yes';
            } else {
              Checker.check = 'No';
            }
            return new ListTile(
              //Display appropriate WKO for day, week, month tab view
              title: Card(
                  child: Column(
                children: [
                  Conditional.single(
                      context: context,
                      conditionBuilder: (BuildContext context) => true == true,
                      widgetBuilder: (BuildContext context) {
                        DayObject._timestamp = document['Due'].toDate();
                        // if (((DayObject._weekahead.day) -
                        //             (DayObject._timestamp.day) <
                        //         7) ||
                        //     ((DayObject._weekahead.month !=
                        //             DayObject._timestamp.month) &&
                        //         ((DayObject._weekahead.day) -
                        //                 (DayObject._timestamp.day) <
                        //             0)) ||
                        //     (DayObject._timestamp.day) == 13) {
                        if ((DayObject._timestamp.month == DayObject._today.month) && (DayObject._timestamp.day == DayObject._today.day)) {
                          return Container(
                              child: ListTile(
                                title: Text(document['ID'].toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text(
                                    document['Description'].toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                trailing: IconButton(
                                  icon: Icon(Icons.arrow_right),
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
                              ));
                        } else
                          return Container(

                              child: ListTile(
                                title: Text('This shouldnt be here :(',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
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

//Weekly Work Order Function
  Widget _weekWKO() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('WKO').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return new Text('Loading...');
        return new ListView(
          children: snapshot.data.docs.map((DocumentSnapshot document) {
            DayObject._timestamp = document['Due'].toDate();
            //if(((DayObject._weekahead.day) - (DayObject._timestamp.day)) < 7) {
            if (DayObject._timestamp.month == 4) {
              Checker.check = 'Yes';
            } else {
              Checker.check = 'No';
            }
            return new ListTile(
              //Display appropriate WKO for day, week, month tab view
              title: Card(
                  child: Column(
                children: [
                  Conditional.single(
                      context: context,
                      conditionBuilder: (BuildContext context) => true == true,
                      widgetBuilder: (BuildContext context) {
                        //DayObject._timestamp = document['Due'].toDate();
                        // if (((DayObject._weekahead.day) -
                        //             (DayObject._timestamp.day) <
                        //         7) ||
                        //     ((DayObject._weekahead.month !=
                        //             DayObject._timestamp.month) &&
                        //         ((DayObject._weekahead.day) -
                        //                 (DayObject._timestamp.day) <
                        //             0)) ||
                        //     (DayObject._timestamp.day) == 13) {
                        if (Checker.check == 'Yes') {
                          return Container(
                              child: ListTile(
                                title: Text(document['ID'].toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text(
                                    document['Description'].toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                trailing: IconButton(
                                  icon: Icon(Icons.arrow_right),
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
                              ));
                        } else
                          return Container(

                              child: ListTile(
                                title: Text(document['ID'].toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text(
                                    document['Description'].toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                trailing: IconButton(
                                  icon: Icon(Icons.arrow_right),
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

//Monthly Work Order Function
  Widget _monthlyWKO() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('WKO').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return new Text('Loading...');
        return new ListView(
          children: snapshot.data.docs.map((DocumentSnapshot document) {
            DayObject._timestamp = document['Due'].toDate();
            //if(((DayObject._weekahead.day) - (DayObject._timestamp.day)) < 7) {
            if (DayObject._timestamp.month == 4) {
              Checker.check = 'Yes';
            } else {
              Checker.check = 'No';
            }
            return new ListTile(
              //Display appropriate WKO for day, week, month tab view
              title: Card(
                  child: Column(
                children: [
                  Conditional.single(
                      context: context,
                      conditionBuilder: (BuildContext context) => true == true,
                      widgetBuilder: (BuildContext context) {
                        //DayObject._timestamp = document['Due'].toDate();
                        // if (((DayObject._weekahead.day) -
                        //             (DayObject._timestamp.day) <
                        //         7) ||
                        //     ((DayObject._weekahead.month !=
                        //             DayObject._timestamp.month) &&
                        //         ((DayObject._weekahead.day) -
                        //                 (DayObject._timestamp.day) <
                        //             0)) ||
                        //     (DayObject._timestamp.day) == 13) {
                        if (Checker.check == 'Yes') {
                          return Container(
                              child: ListTile(
                                title: Text(document['ID'].toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text(
                                    document['Description'].toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                trailing: IconButton(
                                  icon: Icon(Icons.arrow_right),
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
                              ));
                        } else
                          return Container(

                              child: ListTile(
                                title: Text(document['ID'].toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text(
                                    document['Description'].toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                trailing: IconButton(
                                  icon: Icon(Icons.arrow_right),
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

  //Bottom nav bar
  Widget _bottomNav() {
    return BottomNavigationBar(
      currentIndex: _index,
      onTap: (int _index) {
        setState(() {
          this._index = _index;
        });
        if (_index == 2) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MyTimer()));
        }
        if (_index == 3) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SettingsPage()));
          // PopupMenuButton(
          //   itemBuilder: (BuildContext bc) => [
          //     PopupMenuItem(child: Text("Sign Out"), value: 1),
          //   ],
          //   onSelected: (value) {
          //     if(value == 1){
          //       Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
          //     }
          //   }
          // );
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

}
