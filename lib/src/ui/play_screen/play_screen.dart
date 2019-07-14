import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flx/src/global_bloc.dart';
import 'package:flx/src/models/highscore.dart';
import 'package:flx/src/models/modes.dart';
import 'package:flx/src/models/play_state.dart';
import 'package:flx/src/ui/play_screen/play_screen_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audio_cache.dart';

int next(int min, int max) => min + Random().nextInt(max - min);

class PlayScreen extends StatefulWidget {
  Modes mode;
  PlayScreen(this.mode);

  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  PlayBloc playBloc;
  Random rng = Random();
  MaterialColor screenColor;
  String screenText = '';
  Stopwatch stopwatch;
  Duration waitTime;
  static AudioCache audioPlayer;
  Timer _timer = Timer(Duration(minutes: 0), () => {});

  void initState() {
    super.initState();
    playBloc = PlayBloc();
    screenColor = Colors.deepPurple;
    audioPlayer = AudioCache();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalBloc globalBloc = Provider.of<GlobalBloc>(context);

    return StreamBuilder<MapEntry<PlayState, double>>(
      stream: Observable.combineLatest2(
        playBloc.playState$,
        playBloc.resultTime$,
        (a, b) => MapEntry(a, b),
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        final state = snapshot.data.key;
        final resultTime = (widget.mode == Modes.Sound)
            ? snapshot.data.value - 300 //Compensating audio delay (300 ms)
            : snapshot.data.value;

        globalBloc
            .checkHighscore(Highscore(mode: widget.mode, time: resultTime));

        playScreenInfoSet(state, widget.mode);
        return GestureDetector(
          onTap: () {
            if (_timer.isActive) {
              _timer.cancel();
              playBloc.nextScreen(PlayState.TapError);
            } else {
              playBloc.nextScreen(state);
            }
          },
          child: Material(
            color: screenColor,
            child: Center(
              child: Text(
                (state == PlayState.Results)
                    ? screenText + '\n${resultTime / 1000} Seconds!'
                    : screenText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void playScreenInfoSet(PlayState state, Modes mode) {
    switch (state) {
      case PlayState.Start:
        screenColor = Colors.deepPurple;
        screenText = "Tap to Start";
        break;

      case PlayState.Waiting:
        screenColor = Colors.blue;
        if (mode == Modes.Visual) {
          screenText = "Tap when the screen color changes!";
        } else if (mode == Modes.Vibrate) {
          screenText = "Tap when your\nphone vibrates!";
        } else {
          screenText = "Tap when you hear\nthe sound!";
        }
        waitTime = Duration(milliseconds: next(1500, 5500));
        _timer = Timer(waitTime, () => playBloc.nextScreen(state));
        break;

      case PlayState.Tap:
        if (mode == Modes.Vibrate) {
          Vibration.vibrate(duration: 500);
        } else if (mode == Modes.Sound) {
          audioPlayer.play("sound/Beep.mp3");
        } else {
          screenColor = Colors.green;
          screenText = "Tap Now!";
        }
        break;

      case PlayState.Results:
        screenColor = Colors.purple;
        screenText = "Your FLX time";
        break;

      case PlayState.ErrorDisplay:
        screenColor = Colors.red;
        screenText = "You Pressed Early!";
        break;

      default:
        screenColor = Colors.deepPurple;
        screenText = "Tap to Start!";
    }
  }
}
