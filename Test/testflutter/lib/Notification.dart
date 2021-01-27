import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        body: ListView(
          // This next line does the trick.
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(bottom: 10.0),
            child: Card(
              child: Column(
                children: [
                  ListTile(
                    trailing: 
                    IconButton(
                        icon: Icon(Icons.add, color: Colors.black),
                        tooltip: 'Add WKO',
                      onPressed: () {
                        _showMyDialog();
                      },
                    ),
                    title: Text('Insert Notification Here')
                  )
                ],
              )
            ),
            ),
            
          ],
        ));
  }


  Future<void> _showMyDialog() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Do you want to add this WKO to your todo list?'),
        content: SingleChildScrollView(
        ),
        actions: <Widget>[
          TextButton(
            child: 
            Text('Yes'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: 
            Text('No'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),

        ],
      );
    },
  );
}
}
