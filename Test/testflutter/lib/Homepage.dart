import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePage createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Mpulse Test Application'),
      ),
      //Grad an instance of the Firestore database
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('GEOLOC').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          //Check if the snapshot grabbed any data from firestore
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (BuildContext context, index) =>
                _buildListItem(context, snapshot.data.docs[index]),
          );
        },
      ),
    );
  }

  //Display data taken from firestore
  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return Card(
      shadowColor: Colors.green,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 15)),
          //Display description information
          Text(document['Description'],
              style: Theme.of(context).textTheme.headline6),
          Padding(padding: EdgeInsets.all(5)),
          //Display Latitude infomation
          Row(
            children:[ Align(
                alignment: Alignment.topLeft,
                // Used as a condtional statement
                child: (document['Latitude'] == null)
                    ? Text('Missing Information')
                    : Text('Lat: ' + document['Latitude'].toString())),
            ]),
          //Display Longitude information
          Container(
            child: Align(
                alignment: Alignment.topLeft,
                child: (document['Longitude'] == null)
                    ? Text('Missing Information')
                    : Text('Long: ' + document['Longitude'].toString())),
          ),
          //Display who last updated information
          Container(
            child: Align(
                alignment: Alignment.topLeft,
                child: (document['LastUpdatedBy'] == null)
                    ? Text('Missing Information')
                    : Text('Last Updated By: ' + document['LastUpdatedBy'])),
          ),
          //Display when the information was last updated
          Container(
            child: Align(
                alignment: Alignment.topLeft,
                child: (document['LastUpdatedDate'] == null)
                    ? Text('Missing Information')
                    : Text('Last Updated On: ' +
                        document['LastUpdatedDate'].toDate().toString())),
          ),
        ],
      ),
    );
  }
}
