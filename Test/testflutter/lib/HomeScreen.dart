import 'package:flutter/material.dart';
import 'package:testflutter/Settings.dart';
import 'package:testflutter/Timer.dart';
import 'package:testflutter/Notification.dart';


class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

/// This is the private State class that goes with HomeScreen.
class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin{
  
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
        body:  _tabItems(),
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
            decoration: InputDecoration(
                border: InputBorder.none, hintText: 'Search....'),
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xFFE0E0E0),
          bottom: TabBar(controller: _controller,
            labelColor: Colors.black,
            tabs: [
              Tab(icon: Text('Due: Today')),
              Tab(icon: Text('Due: Week')),
              Tab(icon: Text('Due: Month')),
            ],
          ),
        ),
        body: TabBarView(controller: _controller,
          children: [
            Center(child: Text('Display only daily WKO')),
            Center(child: Text('Display only Weekly WKO')),
            Center(child: Text('Display only Monthly WKO')),
          ],
        ),
    );
  }


  Widget _bottomNav() {
    return BottomNavigationBar(
      currentIndex: _index,
          onTap: (int _index) {
            setState(() {
              this._index = _index;
            });
            if(_index == 2){
              Navigator.push(
              context, MaterialPageRoute(builder: (context) => MyTimer()));
            }
            if(_index == 3){
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

