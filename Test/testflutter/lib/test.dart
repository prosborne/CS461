import 'package:flutter/material.dart';


class MyHomePageTest extends StatefulWidget {
  @override
  State createState() => new MyHomePageTestState();
}

class MyHomePageTestState extends State<MyHomePageTest> with SingleTickerProviderStateMixin {
  TabController _controller;
  int _index;

  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 4, vsync: this);
    _index = 0;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Traveler"),
        bottom: new TabBar(controller: _controller, tabs: <Tab>[
          new Tab(text: "NEW"),
          new Tab(text: "HOTELS"),
          new Tab(text: "FOOD"),
          new Tab(text: "FUN"),
        ]),
      ),
      body: new TabBarView(
        controller: _controller,
        children: <Widget>[
          new NewPage(_index),
          new HotelsPage(_index),
          new FoodPage(_index),
          new FunPage(_index),
        ],
      ),
      bottomNavigationBar: new BottomNavigationBar(
          currentIndex: _index,
          onTap: (int _index) {
            setState(() {
              this._index = _index;
            });
          },
          items: <BottomNavigationBarItem>[
            new BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              title: new Text("Home"),
            ),
            new BottomNavigationBarItem(
              icon: new Icon(Icons.favorite),
              title: new Text("Favorites"),
            ),
          ]),
    );
  }
}

class NewPage extends StatelessWidget {
  final int index;

  NewPage(this.index);

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Text('NewPage, index: $index'),
    );
  }
}

class HotelsPage extends StatelessWidget {
  final int index;

  HotelsPage(this.index);

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Text('HotelsPage, index: $index'),
    );
  }
}

class FoodPage extends StatelessWidget {
  final int index;

  FoodPage(this.index);

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Text('FoodPage, index: $index'),
    );
  }
}

class FunPage extends StatelessWidget {
  final int index;

  FunPage(this.index);

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Text('FunPage, index: $index'),
    );
  }
}



//Search Bar
// Widget _searchBar() {
//     return SizedBox(
//         height: 100.0,
//         child: MaterialApp(
//           home: FloatingSearchBar.builder(
//             itemCount: 100,
//             itemBuilder: (BuildContext context, int index) {
//               return ListTile(
//                   //leading: Text(index.toString()),
//                   );
//             },
//             drawer: Drawer(
//                 child: Row(
//               children: [
//                 FloatingActionButton(
//                   child: Icon(Icons.settings),
//                   onPressed: () {},
//                 )
//               ],
//             )),
//             trailing: CircleAvatar(
//               child: FloatingActionButton(
//                 child: Icon(Icons.settings),
//                 onPressed: () {},
//               ),
//             ),
//             onChanged: (String value) {},
//             onTap: () {},
//             decoration: InputDecoration.collapsed(
//               hintText: "Search...",
//             ),
//           ),
//         ));
//   }