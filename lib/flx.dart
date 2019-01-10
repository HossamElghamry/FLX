import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_sign_in/google_sign_in.dart';
import './HOF.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:vibrate/vibrate.dart';
import './ModeList.dart';

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

  void _dialogHTP(){
    showDialog(context: context, 
    builder: (_)=> AlertDialog(
          title: new Text("How to Play"),
          content: new Text("Wait for green screen to pop up\n\nTap immediately after seeing it\nto measure your response time!\n"
          ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
        )   
      );
    }
  
  void _toTap(){
  }
  void _toSound(){
  }
  void _toVibrate(){
  }

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("FLEX"),),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("Hossam Elghamry"),
              accountEmail: Text("h.elghamry@nu.edu.eg"),
            ),
            ListTile(title: Text("About Tap Mode"),trailing: Icon(Icons.touch_app),
                      onTap:() => _toTap()),
            ListTile(title: Text("About Sound Mode"),trailing: Icon(Icons.surround_sound),
                      onTap:()=> _toSound()),
            ListTile(title: Text("About Vibration Mode"),trailing: Icon(Icons.vibration),
                      onTap:()=> _toVibrate()),
            Divider(),
            ListTile(title: Text("Global Leaderboard"),trailing: Icon(Icons.first_page), 
                     onTap:()=>Navigator.of(context).push(new MaterialPageRoute(builder: 
                            (BuildContext context)=> new HighscoreList())) ,),

            ListTile(title: Text("How to Play"),trailing: Icon(Icons.question_answer),onTap: ()=>_dialogHTP(),),
            ListTile(title: Text("Settings"),trailing: Icon(Icons.settings),),
            ListTile(title: Text("About"),trailing: Icon(Icons.recent_actors),)
          ],
        ),
      ),

      body: ModePage(),
    );
  }
}

