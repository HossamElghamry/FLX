import 'package:flx/src/models/play_state.dart';
import 'package:rxdart/rxdart.dart';

class PlayBloc {
  Stopwatch _stopwatch = Stopwatch();

  BehaviorSubject<PlayState> _playState$;
  BehaviorSubject<PlayState> get playState$ => _playState$;

  BehaviorSubject<double> _resultTime$;
  BehaviorSubject<double> get resultTime$ => _resultTime$;

  PlayBloc() {
    _playState$ = BehaviorSubject<PlayState>.seeded(PlayState.Start);
    _resultTime$ = BehaviorSubject<double>.seeded(0.0);
  }

  void nextScreen(PlayState currentState) {
    switch (currentState) {
      case PlayState.Start:
        _playState$.add(PlayState.Waiting);
        break;
      case PlayState.Waiting:
        _playState$.add(PlayState.Tap);
        _stopwatch.start();
        break;
      case PlayState.Tap:
        _stopwatch.stop();
        _resultTime$.add(_stopwatch.elapsedMilliseconds.toDouble());
        _playState$.add(PlayState.Results);
        break;
      case PlayState.Results:
        _stopwatch.reset();
        _playState$.add(PlayState.Start);
        break;
      case PlayState.TapError:
        _playState$.add(PlayState.ErrorDisplay);
        break;
      case PlayState.ErrorDisplay:
        _playState$.add(PlayState.Start);
        break;
      default:
        _playState$.add(PlayState.Start);
    }
  }

  void dispose() {
    _playState$.close();
    _resultTime$.close();
  }
}
