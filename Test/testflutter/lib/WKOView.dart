import 'package:flutter/material.dart';
import 'main.dart';

class WKOView extends StatelessWidget { 
  final String assets;
  final String descript;
  final DateTime timedue;
  final String id;
  final String prio;
  final String type;
  final String person;
  WKOView(
      {Key key,
      @required this.assets,
      this.descript,
      this.timedue,
      this.id,
      this.prio,
      this.type,
      this.person})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('$assets', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.grey.shade100,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_sharp,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
              if(closestBuilding != null && assets == closestBuilding.description)
                distanceWidget(),
              ListTile(
                title:
                    Text('ID#:', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('   $id'),
              ),
              ListTile(
                title: Text('Description:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('   $descript'),
              ),
              ListTile(
                title: Text('Due Date:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('   $timedue'),
              ),
              ListTile(
                title: Text('Priority:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('   $prio'),
              ),
              ListTile(
                title: Text('Type:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('   $type'),
              ),
              ListTile(
                title: Text('Personnel:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(' $person'),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget distanceWidget(){
    print(isInside);
    if(isInside == true){
      return ListTile(
              title: 
                Text('Distance: ', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(' Inside'),
              );
    }else{
      return ListTile(
              title: 
                Text('Distance: ', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(' ${(distance * 3.28084).round()} ft'),
              );
    }
  }
}
