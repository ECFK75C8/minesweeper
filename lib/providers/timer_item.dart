import 'dart:async';
import 'package:flutter/material.dart';

class TimerItem extends ChangeNotifier {
  var _timer;
  int _currentSeconds = 0;
  final _duration = const Duration(seconds: 1);

  String get time {
    int hrs = _currentSeconds ~/ 3600;
    int mins = _currentSeconds % 3600 ~/ 60;
    int secs = _currentSeconds % 3600 % 60;

    return '${hrs.toString().padLeft(2, '0')} : ${mins.toString().padLeft(2, '0')} : ${secs.toString().padLeft(2, '0')}';
  }

  String get timerText {
    int hrs = _currentSeconds ~/ 3600;
    int mins = _currentSeconds % 3600 ~/ 60;
    int secs = _currentSeconds % 3600 % 60;

    if (hrs > 0) {
      return '$hrs hrs';
    } else if (mins > 0) {
      if (mins > 5) return '$mins mins';
      return '$mins ${(mins > 1) ? 'mins' : 'min'} $secs ${(secs > 1) ? 'secs' : 'sec'}';
    } else
      return '$secs ${(secs > 1) ? 'secs' : 'sec'}';
  }

  int get seconds => _currentSeconds;

  set seconds(int secs) {
    _currentSeconds = secs;
    notifyListeners();
  }

  void startTimer() {
    _timer = Timer.periodic(_duration, (timer) {
      _currentSeconds += 1;
      notifyListeners();
    });
  }

  void resetTimer() {
    _timer?.cancel();
    _currentSeconds = 0;
    notifyListeners();
  }

  int stop() {
    _timer?.cancel();
    return _currentSeconds;
  }
}
