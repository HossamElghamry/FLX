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
      print("jjgsss");
      var blocList = _highscore$.value;
      blocList.removeWhere((temp) => temp.getMode == highscore.getMode);

      SharedPreferences sharedUser = await SharedPreferences.getInstance();
      Map<String, dynamic> tempMap = highscore.toJson();
      String newHighscoreJson = jsonEncode(tempMap);
      List<String> highscoreJsonList = [];
      print(sharedUser.getStringList('highscores'));
      if (sharedUser.getStringList('highscores') == null) {
        highscoreJsonList.add(newHighscoreJson);
        for (int i = 0; i < 2; i++) {
          String unchangedHighscoreJson = jsonEncode(blocList[i].toJson());
          highscoreJsonList.add(unchangedHighscoreJson);
        }
      } else {
        List<String> prefBeforeDecodeList =
            sharedUser.getStringList('highscores');
        List<Highscore> prefList = [];
        for (String jsonHighscore in prefBeforeDecodeList) {
          Map userMap = jsonDecode(jsonHighscore);
          Highscore tempHighscore = Highscore.fromJson(userMap);
          if (tempHighscore.mode != highscore.mode) {
            prefList.add(tempHighscore);
          }
        }
        for (int i = 0; i < 2; i++) {
          String unchangedHighscoreJson = jsonEncode(prefList[i].toJson());
          highscoreJsonList.add(unchangedHighscoreJson);
        }
        highscoreJsonList.add(newHighscoreJson);
      }
      sharedUser.setStringList('highscores', highscoreJsonList);
      blocList.add(highscore);
      _highscore$.add(blocList);
    }
  }

  Future retrieveHighscore() async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    List<String> jsonList = sharedUser.getStringList('highscores');
    List<Highscore> prefList = [];
    if (jsonList == null) {
      print("hujef");
      return;
    } else {
      print("DJBJKD");
      for (String jsonHighscore in jsonList) {
        Map userMap = jsonDecode(jsonHighscore);
        Highscore tempHighscore = Highscore.fromJson(userMap);
        prefList.add(tempHighscore);
      }
      _highscore$.add(prefList);
    }
  }
}
