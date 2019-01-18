import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vibrate/vibrate.dart';


GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class VibrationMode extends StatefulWidget{
  bool first = true;
  bool early = false;
  double _highscore = 0;
  @override
  State createState() => new VibrationModeState(); 
}

int next(int min, int max) => min + Random().nextInt(max - min);

class VibrationModeState extends State<VibrationMode> with SingleTickerProviderStateMixin{
  
  String screen;
  var _screenColor = Colors.indigo;
  Stopwatch _stopwatch = new Stopwatch();
  var t = new Timer(Duration(seconds:0), ()=>{});

  void initState(){
    super.initState();
    // getHighscore();
    screen = "Flexing";
    t = Timer(Duration(milliseconds: next(1500,5500)), () => _handleScreen());
  }

  Future _waitFlex() async {
    _stopwatch..reset();
    this.setState((){
      screen = "Flexing";
      _screenColor = Colors.indigo;
    });
    t = Timer(Duration(milliseconds: next(1500,5500)), () => _handleScreen());
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
          Vibrate.feedback(FeedbackType.medium);
          screen = "TapNow";
      });
        
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
        screen = "Flexing";
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
        _screenColor = Colors.indigo;
        screen = "Flexing";
      });
    }
  }

  Widget _buildScreen(){
     if (screen == "Flexing"){
        return Text("Tap when the phone vibrates!", style: new TextStyle(color: Colors.white, 
        fontSize: 22.0, fontWeight: FontWeight.bold));
     }
    else if (screen == "TapNow"){
        _stopwatch..start();
        return Text("Tap when the phone vibrates!", style: new TextStyle(color: Colors.white, 
        fontSize: 25.0, fontWeight: FontWeight.bold));
    }
    else if (screen == "Early"){
      return Text("Cheater!\nYou Pressed Early!",textAlign: TextAlign.center, 
      style: new TextStyle(color: Colors.white, 
      fontSize: 30.0, fontWeight: FontWeight.bold));
    }
    else if (screen == "Results"){
      return Text("Your Flex Time\n\n${_stopwatch.elapsed.inMilliseconds/1000} Seconds!", 
      textAlign: TextAlign.center, 
      style: new TextStyle(color: Colors.white, fontSize: 35.0, fontWeight: FontWeight.bold));
    }
    return Container();
  }
  
  @override
  void dispose(){
    t.cancel();
    super.dispose();
  }

  Widget build(BuildContext context){
    return new Material(
        color: _screenColor,
        child: new InkWell(
          splashColor: Colors.deepPurpleAccent,
          onTap: ()=> screen=="Results"||screen=="Early"? _waitFlex(): _handleScreen(),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Hero(
                tag: "HeroModeIcon1",
                child: Icon(Icons.vibration,color: Colors.white,size: 60,),),
              SizedBox(
                height: 350.0,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildScreen(),
                  ],
                ),
              )
            ],
          )
        )
      );
  }
}