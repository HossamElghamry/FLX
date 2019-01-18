import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_sign_in/google_sign_in.dart';
import './HOF.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:vibrate/vibrate.dart';
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
  static final AudioCache player = new AudioCache();

  void _howtoTap(){
    showDialog(context: context, 
    builder: (_)=> AlertDialog(
          title: new Column(
            children: <Widget>[
              Text("How to Play\n",textAlign: TextAlign.center,),
              Text("Tap Mode",textAlign: TextAlign.center,style: TextStyle(fontSize: 25),),
              Icon(Icons.touch_app,size: 30,),
            ],
          ),
          content: new Text("Wait for green screen to pop up\n\nTap immediately after seeing it to measure your reflex time!\n"
          ,textAlign: TextAlign.center, style: TextStyle(fontSize: 15),),
          actions: <Widget>[
            FlatButton(
              child: Text("Close"),
              onPressed: () {Navigator.of(context).pop();},
            ),
          ],
        )   
      );
  }

  void _howtoVibrate(){
    showDialog(context: context, 
    builder: (_)=> AlertDialog(
          title: new Column(
            children: <Widget>[
              Text("How to Play\n",textAlign: TextAlign.center,),
              Text("Vibration Mode",textAlign: TextAlign.center,style: TextStyle(fontSize: 25),),
              Icon(Icons.vibration,size: 30,),
            ],
          ),
          content: Text("Wait for your phone to vibrate\n\nTap immediately after sensing it to measure your reflex time!\n"
          ,textAlign: TextAlign.center,style: TextStyle(fontSize: 15),),
          actions: <Widget>[
            FlatButton(
              child: Text("Test Vibration"),
              onPressed: () {Vibrate.feedback(FeedbackType.medium);},
            ),
            FlatButton(
              child: Text("Close"),
              onPressed: () {Navigator.of(context).pop();},
            ),
          ],
        )   
      );
  }

  void _howtoSound(){
    showDialog(context: context, 
    builder: (_)=> AlertDialog(
          title: Column(
            children: <Widget>[
              Text("How to Play\n",textAlign: TextAlign.center,),
              Text("Sound Mode",textAlign: TextAlign.center,style: TextStyle(fontSize: 25),),
              Icon(Icons.surround_sound,size: 30,),
            ],
          ),
          content: Text("Wait for the sound to play\n\nTap immediately after hearing it to measure your reflex time!\n"
          ,textAlign: TextAlign.center, style: TextStyle(fontSize: 15),),
          actions: <Widget>[
            FlatButton(
              child: Text("Test Sound"),
              onPressed: () {player.play(alarmAudioPath);},
            ),
            FlatButton(
              child: Text("Close"),
              onPressed: () {Navigator.of(context).pop();},
            ),
          ],
        )   
      );
  }
  
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
                      onTap:() => _howtoTap()),
            ListTile(title: Text("About Vibration Mode"),
                      trailing: Icon(Icons.vibration),
                      onTap:()=> _howtoVibrate()),
            ListTile(title: Text("About Sound Mode"),
                     trailing: Icon(Icons.surround_sound),
                     onTap:()=> _howtoSound(),),
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

