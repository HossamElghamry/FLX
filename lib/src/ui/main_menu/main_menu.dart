import 'package:flutter/material.dart';
import 'package:flx/src/models/modes.dart';
import 'package:flx/src/ui/play_screen/play_screen.dart';

class MainMenu extends StatefulWidget {
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  final PageController viewController =
      PageController(viewportFraction: 0.8, initialPage: 0);

  @override
  Widget build(BuildContext context) {
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
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
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
      ),
    );
  }

  void dispose() {
    super.dispose();
    viewController.dispose();
  }
}

class ModeCard extends StatelessWidget {
  Modes mode;
  String modeName;
  IconData modeIcon;

  ModeCard(this.mode) {
    switch (mode) {
      case Modes.Visual:
        modeName = "Visual Mode";
        modeIcon = Icons.touch_app;
        break;
      case Modes.Vibrate:
        modeName = "Vibrate Mode";
        modeIcon = Icons.vibration;
        break;
      case Modes.Sound:
        modeName = "Sound Mode";
        modeIcon = Icons.surround_sound;
        break;
    }
  }

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
              if (mode == Modes.Visual) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlayScreen(
                          Modes.Visual,
                        ),
                  ),
                );
              } else if (mode == Modes.Vibrate) {
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
                    modeName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                  ),
                  Icon(
                    modeIcon,
                    color: Colors.white,
                    size: 120,
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
