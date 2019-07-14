import 'package:flutter/material.dart';
import 'package:flx/src/global_bloc.dart';
import 'package:flx/src/models/highscore.dart';
import 'package:flx/src/models/modes.dart';
import 'package:flx/src/ui/play_screen/play_screen.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:provider/provider.dart';

class MainMenu extends StatefulWidget {
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  final PageController viewController =
      PageController(viewportFraction: 0.8, initialPage: 0);

  @override
  Widget build(BuildContext context) {
    //final GlobalBloc globalBloc = Provider.of<GlobalBloc>(context);

    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) - 120;

    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 0,
        title: Text(
          "FLX",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              "Test your Reflexes",
              style: TextStyle(color: Colors.white, fontSize: 28),
            ),
            Container(
              height: itemHeight,
              child: PageView(
                controller: viewController,
                children: [
                  ModeCard(Modes.Visual),
                  ModeCard(Modes.Vibrate),
                  ModeCard(Modes.Sound),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void dispose() {
    super.dispose();
    viewController.dispose();
  }
}

class ModeCard extends StatefulWidget {
  Modes mode;
  String modeName;
  String animationPath;

  ModeCard(this.mode) {
    switch (mode) {
      case Modes.Visual:
        modeName = "Visual Mode";
        animationPath = "assets/animations/tap_animation.flr";
        break;
      case Modes.Vibrate:
        modeName = "Vibrate Mode";
        animationPath = "assets/animations/vibrate_animation.flr";
        break;
      case Modes.Sound:
        modeName = "Sound Mode";
        animationPath = "assets/animations/sound_animation.flr";
        break;
    }
  }

  @override
  _ModeCardState createState() => _ModeCardState();
}

class _ModeCardState extends State<ModeCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Card(
        elevation: 8.0,
        color: Colors.purple,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(width: 8, color: Colors.white),
          ),
          child: InkWell(
            onTap: () {
              if (widget.mode == Modes.Visual) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlayScreen(
                          Modes.Visual,
                        ),
                  ),
                );
              } else if (widget.mode == Modes.Vibrate) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlayScreen(
                          Modes.Vibrate,
                        ),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlayScreen(
                          Modes.Sound,
                        ),
                  ),
                );
              }
            },
            splashColor: Colors.indigo,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    widget.modeName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  Container(
                    height: 300,
                    child: FlareActor(
                      widget.animationPath,
                      color: Colors.white,
                      alignment: Alignment.center,
                      fit: BoxFit.contain,
                      animation: "animate",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
