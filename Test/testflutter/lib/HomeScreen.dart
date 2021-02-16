import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:testflutter/Login.dart';

import 'package:testflutter/Settings.dart';
import 'package:testflutter/WKOView.dart';
import 'package:testflutter/Timer.dart';
import 'package:testflutter/Notification.dart';

final databaseReference = FirebaseFirestore.instance;

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
          Center(child: _testWidget()),    //_monthlyWKO()),
        ],
      ),
    );
  }


//Daily Work Order Function
  Widget _dailyWKO() {
    return StreamBuilder<QuerySnapshot>(
      stream: databaseReference.collection('WKO').snapshots(),
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
                        DayObject._timestamp = document['Due'].toDate();
                        if ((DayObject._timestamp.month == DayObject._today.month) && (DayObject._timestamp.day == DayObject._today.day)) {
                          return GestureDetector(
                            onTap: () {
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
                          child: Container(
                              child: ListTile(
                                title: Text(document['ID'].toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text(
                                    document['Description'].toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                
                                  
                                ),
                              )
                              );
                        } else
                          return Container(

                              child: ListTile(
                                title: Text(' ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                ));
                      },
                      fallbackBuilder: (BuildContext context) {
                        return Text('Empty');
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
                        var check = false;
                        var monthdiff = (DayObject._timestamp.month - DayObject._today.month);
                        if(monthdiff == 0 && ((DayObject._timestamp.day - DayObject._today.day) < 7)){
                          check = true;
                        }
                        else if(monthdiff <= 1){
                          var temp = DayObject._timestamp.day + 30;
                          var temp2 = (temp - DayObject._today.day);
                          if(temp2 < 7)
                            check = true;
                          else{
                            check = false;
                          }
                        }
                        else{
                          check = true;
                        }
                        if (check == true) {
                          return GestureDetector(
                          onTap: () {
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
                          child: Container(
                              child: ListTile(
                                title: Text(document['ID'].toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text(
                                    document['Description'].toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                
                                  
                                ),
                              ));
                        } else
                          return SizedBox.shrink();
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
                        var check = false;
                        var monthdiff = (DayObject._timestamp.month - DayObject._today.month);
                        if(monthdiff < 1)
                          check = true;
                        else{
                          check = false;
                        }
                        if (check == true) {
                          return GestureDetector(
                            onTap: () {
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
                          child: Container(
                              child: ListTile(
                                title: Text(document['ID'].toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text(
                                    document['Description'].toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
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
        if (_index == 1) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginScreen()));
        }
        
        if (_index == 2) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MyTimer()));
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




  Widget _testWidget(){
    //databaseReference.collection('WKO').snapshots().listen((snapshot){});
    
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('WKO').snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) return new Text('Loading...');
        return ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                if(snapshot.data.docs[index]['Personnel'].toString() == 'DocumentReference(EMP/0000)')
                  //Text(snapshot.data.docs[index]['Personnel'].toString()),
                  GestureDetector(
                            onTap: () {
                                    //Set assets to pushed to next screen
                                    Temp.assets = snapshot.data.docs[index]['Asset'].toString();
                                    Temp.descript =
                                        snapshot.data.docs[index]['Description'].toString();
                                    Temp.timedue = snapshot.data.docs[index]['Due'].toDate();
                                    Temp.id = snapshot.data.docs[index]['ID'].toString();
                                    Temp.prio = snapshot.data.docs[index]['Priority'].toString();
                                    Temp.type = snapshot.data.docs[index]['Type'].toString();
                                    Temp.person =
                                        snapshot.data.docs[index]['Personnel'].toString();
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
                          child: Container(
                              child: ListTile(
                                title: Text(snapshot.data.docs[index]['ID'].toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text(
                                    snapshot.data.docs[index]['Description'].toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                ),
                  ))
              ]
              );
          }
        );
      }
    );
      }

}
