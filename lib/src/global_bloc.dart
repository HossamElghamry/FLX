import 'dart:convert';

import 'package:flx/src/models/highscore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/modes.dart';

class GlobalBloc {
  BehaviorSubject<List<Highscore>> _highscore$;
  BehaviorSubject<List<Highscore>> get highscore$ => _highscore$;

  GlobalBloc() {
    _highscore$ = BehaviorSubject<List<Highscore>>.seeded(
      [
        Highscore(mode: Modes.Visual, time: 0),
        Highscore(mode: Modes.Vibrate, time: 0),
        Highscore(mode: Modes.Sound, time: 0)
      ],
    );
    retrieveHighscore();
  }

  Future checkHighscore(Highscore highscore) async {
    double oldTime = _highscore$.value
        .firstWhere((test) => test.mode == highscore.mode)
        .time;
    double newTime = highscore.time;

    if (oldTime > newTime || oldTime <= 0) {
      var blocList = _highscore$.value;
      blocList.removeWhere((temp) => temp.getMode == highscore.getMode);
      blocList.add(highscore);
      _highscore$.add(blocList);
      Map<String, dynamic> tempMap = highscore.toJson();
      SharedPreferences sharedUser = await SharedPreferences.getInstance();
      String newHighscoreJson = jsonEncode(tempMap);
      List<String> highscoreJsonList = [];
      if (sharedUser.getStringList('highscores') == null) {
        highscoreJsonList.add(newHighscoreJson);
      } else {
        highscoreJsonList = sharedUser.getStringList('highscores');
        highscoreJsonList.add(newHighscoreJson);
      }
      sharedUser.setStringList('highscores', highscoreJsonList);
    }
  }

  Future retrieveHighscore() async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    List<String> jsonList = sharedUser.getStringList('highscores');
    List<Highscore> prefList = [];
    if (jsonList == null) {
      return;
    } else {
      for (String jsonHighscore in jsonList) {
        Map userMap = jsonDecode(jsonHighscore);
        Highscore tempHighscore = Highscore.fromJson(userMap);
        prefList.add(tempHighscore);
      }
      _highscore$.add(prefList);
    }
  }
}
