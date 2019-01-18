import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_sign_in/google_sign_in.dart';
import './HOF.dart';
import './ModeList.dart';

const alarmAudioPath = "Beep.mp3";

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

Future<void> _handleSignIn() async {
  try {
    await _googleSignIn.signIn();
  } catch (error) {
    print(error);
  }
}

class Flx extends StatefulWidget{
  @override
  State createState() => new FlxState(); 
}

class FlxState extends State<Flx> with SingleTickerProviderStateMixin{
  
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("FLEX",), centerTitle: true ,
      elevation: 0.0, backgroundColor: Colors.deepPurpleAccent,),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("Hossam Elghamry"),
              accountEmail: Text("h.elghamry@nu.edu.eg"),
            ),
            ListTile(title: Text("About Tap Mode"),
                      trailing: Icon(Icons.touch_app),
                      onTap:() => {}),
            ListTile(title: Text("About Vibration Mode"),
                      trailing: Icon(Icons.vibration),
                      onTap:()=> {}),
            ListTile(title: Text("About Sound Mode"),
                     trailing: Icon(Icons.surround_sound),
                     onTap:()=>{}),
            Divider(),
            ListTile(title: Text("Global Leaderboard"),trailing: Icon(Icons.first_page), 
                     onTap:()=>Navigator.of(context).push( MaterialPageRoute(builder: 
                            (BuildContext context)=> HighscoreList())) ,),
            ListTile(title: Text("Settings"),trailing: Icon(Icons.settings),),
            ListTile(title: Text("About"),trailing: Icon(Icons.recent_actors),)
          ],
        ),
      ),

      body: ModePage(),
      
    );
  }
}

