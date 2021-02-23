import 'package:flutter/material.dart';
import 'package:testflutter/HomeScreen.dart';
import 'package:testflutter/TestingPage.dart';
import 'package:testflutter/services/location.dart';
import 'services/location.dart';
import 'package:geolocator/geolocator.dart';
import 'main.dart';
import 'services/location.dart';





class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}





class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final double controlHeight = 50.0;
  final double controlWidth = 350.0;


  //String username = 'Branden';
  String password = '';
  String errorText = '';

  @override
  void initState(){
    super.initState();
  }

void click() {
  String user = 'Branden';
  //Position position = get_current_location();
  Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(user: user)));
}

  @override
  Widget build(BuildContext context) {


//Username for login process
    final usernameField = TextField( 
      obscureText: false,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Username",
        border:
          OutlineInputBorder())
    );

//Password for login process   
    final passwordField = TextField(
    
      obscureText: true,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Password",
        border: 
          OutlineInputBorder()),
      
    ); 

//Login button
    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xFFDE2328),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width * 0.70,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          //print(geolocs.length);
          //get_current_location();
          click();
        },
        child: Text("login",
          textAlign: TextAlign.center, style: TextStyle(fontSize: 20.0),
          )
      )
    );
   
    
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Center(
        child: Container(
          color: Color(0xFFD6D6D6),
          child: Padding(
            padding: 
              const EdgeInsets.fromLTRB(50, 20, 50, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 200.0,
                    width: 200.0,
                    child: Image.asset("images/logo.jpg", fit: BoxFit.contain)
                  ),
                  //SizedBox(height: 45.0),
                  Padding(padding: EdgeInsets.only(top: 20.0)),
                  usernameField,
                  SizedBox(height: 10.0),
                  passwordField,
                  FlatButton(
                    onPressed: null, 
                    child: Text(
                      'Forgot Password',
                      style: TextStyle(color: Color(0xFFDE2328), fontSize: 15.0)
                    )),
                 // SizedBox(height: 35.0),
                  loginButton,
                //  SizedBox(height: 15.0), 

                ],
              )
              ),
          )
        ,)

      
    );
  }
}