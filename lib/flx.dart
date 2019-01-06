import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_sign_in/google_sign_in.dart';
import './HOF.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:vibrate/vibrate.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

const alarmAudioPath = "Beep.mp3";

Future<void> _handleSignIn() async {
  try {
    await _googleSignIn.signIn();
  } catch (error) {
    print(error);
  }
}

class Flx extends StatefulWidget{
  bool first = true;
  bool early =false;
  double _highscore = 0;
  @override
  State createState() => new FlxState(); 
}

int next(int min, int max) => min + Random().nextInt(max - min);

class FlxState extends State<Flx> with SingleTickerProviderStateMixin{

    final Iterable<Duration> pauses = [
      const Duration(milliseconds: 500),
      const Duration(milliseconds: 1000),
      const Duration(milliseconds: 500),
    ];

  Animation<double> _fontSizeAnimation;
  AnimationController _fontSizeController; 

  static AudioCache player = new AudioCache();
  
  String screen,text,mode;
  var _screenColor = Colors.indigo;
  Stopwatch _stopwatch = new Stopwatch();
  var t = new Timer(Duration(seconds:0), ()=>{});

  void initState(){
    super.initState();
    _handleSignIn();
    // getHighscore();
    _fontSizeController = new AnimationController(duration: new Duration(milliseconds: 1500), vsync: this);
    _fontSizeAnimation= new CurvedAnimation(parent: _fontSizeController, curve: Curves.elasticInOut);
    _fontSizeAnimation.addListener(() =>this.setState(() {}) );
    _fontSizeController.forward();
    screen = "Home";
    text = "Tap to Flex!";
    mode = "Tap";
  }

   void dispose(){
    _fontSizeController.dispose();
    super.dispose();
  }

  void _dialog(){
    showDialog(context: context, 
    builder: (_)=> AlertDialog(
          title: new Text("How to Play"),
          content: new Text("Wait for green screen to pop up\n\nTap immediately after seeing it\nto measure your response time!\n"
          ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
        )   
      );
    }

  Future _waitFlex() async {
    this.setState((){
      screen = "Flexing";
    });
    t = Timer(Duration(seconds: next(1,5)), () => _handleScreen());
   }
  
  void _handleScreen() async{

     if(screen == "Flexing"){
       if(t.isActive){
         t.cancel();
         this.setState((){
           _screenColor = Colors.red;
           screen = "Early";
         });

      }else{
        this.setState((){
          if(mode == "Tap"){ _screenColor = Colors.green;}
          else if (mode == "Sound") {player.play(alarmAudioPath);}
          else if (mode == "Vibrate") {Vibrate.feedback(FeedbackType.heavy);}
          screen = "TapNow";
      });
        _stopwatch..start();
      }
    }

     else if(screen == "TapNow"){
      _stopwatch..stop();
      this.setState((){
        _screenColor = Colors.indigo;
        screen = "Results";
      });
    }

    else if (screen=="Early"){
      this.setState((){
        _screenColor = Colors.indigo;
        screen = "Home";
      });
    }

    else if(screen == "Results"){
      if(widget.first) {
        widget._highscore = (_stopwatch.elapsed.inMilliseconds/1000).toDouble();
        widget.first =false;
        await Firestore.instance.collection('score').
        document('${_googleSignIn.currentUser.id}').
        setData({ 'score': _stopwatch.elapsed.inMilliseconds/1000,"Username":_googleSignIn.currentUser.displayName});
    }

      else if (widget._highscore > (_stopwatch.elapsed.inMilliseconds/1000)){
        //Insert Highscore in Firebase
        await Firestore.instance.collection('score').
        document('${_googleSignIn.currentUser.id}').
        setData({'score': _stopwatch.elapsed.inMilliseconds/1000,"Username":_googleSignIn.currentUser.displayName});

        widget._highscore = _stopwatch.elapsed.inMilliseconds/1000;
      }

      this.setState((){
        _stopwatch..reset();
        _screenColor = Colors.indigo;
        screen = "Home";
      });
    }
  }

  Widget _buildScreen(){
    if(screen =="Home"){
      return Text("Tap to Flex!", style: new TextStyle(color: Colors.white, 
      fontSize: _fontSizeAnimation.value * 50, fontWeight: FontWeight.bold));
    }
    else if (screen == "Flexing"){
      if(mode == "Tap"){
        return Text("Tap when the screen turns green!", style: new TextStyle(color: Colors.white, 
        fontSize: 20.0, fontWeight: FontWeight.bold));
      }else if(mode == "Sound"){
        return Text("Tap when you hear the sound!", style: new TextStyle(color: Colors.white, 
        fontSize: 20.0, fontWeight: FontWeight.bold));
      }else if(mode == "Vibrate"){
        return Text("Tap when your phone vibrates!", style: new TextStyle(color: Colors.white, 
        fontSize: 20.0, fontWeight: FontWeight.bold));
      }
    }
    else if (screen == "TapNow"){
      if(mode == "Tap"){
        return Text("Tap NOW!", style: new TextStyle(color: Colors.white, 
        fontSize: 20.0, fontWeight: FontWeight.bold));
      }else if(mode == "Sound"){
        return Text("Tap when you hear the sound!", style: new TextStyle(color: Colors.white, 
        fontSize: 20.0, fontWeight: FontWeight.bold));
      }else if(mode == "Vibrate"){
        return Text("Tap when your phone vibrates!", style: new TextStyle(color: Colors.white, 
        fontSize: 20.0, fontWeight: FontWeight.bold));
      }
    }
    else if (screen == "Early"){
      return Text("You Pressed Early!", style: new TextStyle(color: Colors.white, 
      fontSize: 30.0, fontWeight: FontWeight.bold));
    }
    else if (screen == "Results"){
      return Text("Your Flex Time\n\n${_stopwatch.elapsed.inMilliseconds/1000} Seconds!", 
      textAlign: TextAlign.center, 
      style: new TextStyle(color: Colors.white, fontSize: 35.0, fontWeight: FontWeight.bold));
    }
    return Container();
  }

  Widget _buildUI(){
    return new Material(
        color: _screenColor,
        child: new InkWell(
          splashColor: Colors.green,
          onTap: ()=> screen=="Home"? _waitFlex(): _handleScreen(),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            screen == "Home"? 
            Text("Current mode: $mode",textAlign: TextAlign.center, 
                  style: new TextStyle(color: Colors.white, fontSize: 20.0, 
                  fontWeight: FontWeight.bold)):Container(),

            SizedBox(
              height: 350.0,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildScreen(),

                  screen == "Home"? Text("\n\nYour Best Flex\n${widget._highscore} Seconds!",
                  textAlign: TextAlign.center, 
                  style: new TextStyle(color: Colors.white, fontSize: _fontSizeAnimation.value *20.0, 
                  fontWeight: FontWeight.bold))
                  :Container()

                ],
              ),
            )
            ],
          )
        )
      );
  }

  void _toTap(){
    this.setState((){
        mode = "Tap"; 
      });
    Navigator.of(context).pop();
  }
  void _toSound(){
      this.setState((){
          mode = "Sound"; 
        });
      Navigator.of(context).pop();
  }
  void _toVibrate(){
    this.setState((){
        mode = "Vibrate"; 
      });
    Navigator.of(context).pop();
  }

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("Flex"),backgroundColor: Colors.blueAccent,),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("Hossam Elghamry"),
              accountEmail: Text("h.elghamry@nu.edu.eg"),
            ),
            ListTile(title: Text("Tap Mode"),trailing: Icon(Icons.touch_app),
                      onTap:() => _toTap()),
            ListTile(title: Text("Sound Mode"),trailing: Icon(Icons.surround_sound),
                      onTap:()=> _toSound()),
            ListTile(title: Text("Vibration Mode"),trailing: Icon(Icons.vibration),
                      onTap:()=> _toVibrate()),
            Divider(),
            ListTile(title: Text("Leaderboard"),trailing: Icon(Icons.first_page), 
                     onTap:()=>Navigator.of(context).push(new MaterialPageRoute(builder: 
                            (BuildContext context)=> new HighscoreList())) ,),

            ListTile(title: Text("How to Play"),trailing: Icon(Icons.question_answer),onTap: ()=>_dialog(),),
            ListTile(title: Text("Settings"),trailing: Icon(Icons.settings),),
            ListTile(title: Text("About"),trailing: Icon(Icons.recent_actors),)
          ],
        ),
      ),

      body: _buildUI(),
    );
  }
}

