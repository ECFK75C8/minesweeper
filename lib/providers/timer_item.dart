import 'dart:async';
import 'package:flutter/material.dart';

class TimerItem extends ChangeNotifier {
  final duration = const Duration(seconds: 1);
  var _timer;
  int _currentSeconds = 0;

  String get timerText {
    int hrs = _currentSeconds ~/ 3600;
    int mins = _currentSeconds % 3600 ~/ 60;
    int secs = _currentSeconds % 3600 % 60;

    return '${hrs.toString().padLeft(2, '0')} : ${mins.toString().padLeft(2, '0')} : ${secs.toString().padLeft(2, '0')}';
  }

  int get seconds => _currentSeconds;

  set seconds(int secs) {
    _currentSeconds = secs;
    notifyListeners();
  }

  void startTimer() {
    _timer = Timer.periodic(duration, (timer) {
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
