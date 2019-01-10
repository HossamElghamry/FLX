import 'package:flutter/material.dart';
import 'dart:math';
import './vibrateMode.dart';
import './tapMode.dart';
import './soundMode.dart';

class ModePage extends StatefulWidget{
  @override
  State createState() => new ModePageState(); 
}

class ModePageState extends State<ModePage> {
  final List<String> title = ["TAP", "VIBRATION","SOUND"];
  final List<IconData> icons = [Icons.touch_app, Icons.vibration,Icons.surround_sound];
  // static final List<Color> screencolorList = [Colors.deepPurpleAccent,Colors.deepPurpleAccent,
  //                                             Colors.deepPurpleAccent,Colors.deepPurpleAccent, 
  //                                             Colors.black26];
  // static final random = new Random();

  // var screenColor = screencolorList[0 + random.nextInt(screencolorList.length - 0)];
  // var screenCounter=0;
  
  // void _changeScreenColor(){
  //   if(screenCounter == screencolorList.length-1) screenCounter =-1;
  //   this.setState((){
  //       screenCounter++;
  //     });
  // }
  void _managePages(String title){
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
    return Container(
        color: Colors.deepPurpleAccent,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text("Select Game Mode!",style: TextStyle(color:Colors.white,
              fontWeight: FontWeight.bold,fontSize: 30)),
              SizedBox(
                height: MediaQuery.of(context).size.height/2,
                child: PageView.builder(
                  itemCount: title.length,
                  controller: PageController(viewportFraction: 0.8),
                  itemBuilder: (BuildContext context, int itemIndex) {
                    return _buildCarouselItem(context, itemIndex);
                  },
                ),
              )
            ],
          )
        )
    );
  }

  Widget _buildCarouselItem(BuildContext context, int itemIndex) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: InkWell(
        onTap: ()=> _managePages(title[itemIndex]),
        highlightColor: Colors.white,
        splashColor: Colors.purple,
        child:Card(
          color:Colors.purple[300],
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(title[itemIndex], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 30) ,),
                Icon(icons[itemIndex],color: Colors.white,size: 60,)
              ],
            ),
          ),
        ),
      )
    );
  }
}