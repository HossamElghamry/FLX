import 'package:flutter/material.dart';
import './vibrateMode.dart';
import './tapMode.dart';
import './soundMode.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:vibrate/vibrate.dart';


class ModePage extends StatefulWidget{
  @override
  State createState() => new ModePageState(); 
}

class ModePageState extends State<ModePage> {
  final List<String> title = ["TAP", "VIBRATION","SOUND","SPLITSCREEN\nTAP"];
  final List<IconData> icons = [Icons.touch_app, Icons.vibration,Icons.surround_sound,Icons.call_split];
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

  void _playMode(String title){
    if (title == "TAP"){
      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=> new TapMode()));
    }else if(title == "VIBRATION"){
      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=> new VibrationMode()));
    }else if(title == "SOUND"){
      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=> new SoundMode()));
    }
  }

  @override
  
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    return Container(
        color: Colors.deepPurpleAccent,
        child: GridView.count(
          primary: false,
          crossAxisSpacing: 2.0,
          crossAxisCount: 2,
          childAspectRatio: (itemWidth / itemHeight),
          children: <Widget>[
            _buildModeCard(context, 0),
            _buildModeCard(context, 1),
            _buildModeCard(context, 2),
            _buildModeCard(context, 3)
          ],
        )
    );
  }

  Widget _buildModeCard(BuildContext context, int itemIndex) {
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(width: 5,color: Colors.white)
          ),
        child:Card(
          color: Colors.purple[300],
          child: InkWell(
            onTap: ()=> _playMode(title[itemIndex]),
            onLongPress: (){
              if (title[itemIndex] == "TAP"){
                _howtoTap();
              }else if(title[itemIndex] == "VIBRATION"){
                _howtoVibrate();
              }else if(title[itemIndex] == "SOUND"){
                _howtoSound();
              }
            },
            splashColor: Colors.indigo,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(title[itemIndex], textAlign: TextAlign.center 
                    ,style: TextStyle(color: Colors.white, 
                    fontWeight: FontWeight.bold,fontSize: 22) ,),
                    Hero(
                      tag: "HeroModeIcon$itemIndex",
                      child: Icon(icons[itemIndex],color: Colors.white,size: 60,),
                    )
                  ],
                ),
              ),
          )
        ),
      ) 
    );
  }
}