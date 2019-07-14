import 'dart:async';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flx/src/global_bloc.dart';
import 'package:flx/src/models/highscore.dart';
import 'package:flx/src/models/modes.dart';
import 'package:provider/provider.dart';

class UserStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GlobalBloc globalBloc = Provider.of<GlobalBloc>(context);

    return Material(
      color: Colors.deepPurpleAccent,
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: StreamBuilder<List<Highscore>>(
            stream: globalBloc.highscore$,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }
              double visualHighscore = snapshot.data
                      .firstWhere((test) => test.mode == Modes.Visual)
                      .time /
                  1000;
              double vibrateHighscore = snapshot.data
                      .firstWhere((test) => test.mode == Modes.Vibrate)
                      .time /
                  1000;
              double soundHighscore = snapshot.data
                      .firstWhere((test) => test.mode == Modes.Sound)
                      .time /
                  1000;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  HighscoreTile(mode: "Visual", time: visualHighscore),
                  HighscoreTile(mode: "Vibrate", time: vibrateHighscore),
                  HighscoreTile(mode: "Sound", time: soundHighscore),
                ],
              );
            }),
      ),
    );
  }
}

class HighscoreTile extends StatelessWidget {
  final String mode;
  final double time;

  HighscoreTile({Key key, this.mode, this.time}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Container(
        height: 75,
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          color: Colors.purple,
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
                color: Colors.black54,
                offset: Offset(4, 8),
                blurRadius: 5,
                spreadRadius: 2),
          ],
        ),
        child: Center(
          child: Text(
            time <= 0
                ? mode + ": Null"
                : mode + ": " + time.toString() + " secs",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class StatsAnimation extends StatefulWidget {
  @override
  _StatsAnimationState createState() => _StatsAnimationState();
}

class _StatsAnimationState extends State<StatsAnimation> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(milliseconds: 3200),
      () {
        Navigator.of(context).pushReplacementNamed('/stats');
      },
    );
  }

  Widget build(BuildContext context) {
    return Material(
      color: Colors.deepPurpleAccent,
      child: Center(
        child: Container(
          child: Center(
            child: FlareActor(
              "assets/animations/personal_stats_white.flr",
              alignment: Alignment.center,
              fit: BoxFit.contain,
              animation: "animate",
            ),
          ),
        ),
      ),
    );
  }
}
