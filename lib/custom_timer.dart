import 'dart:async';

class CustomTimer {
  late Timer _timer;
  late Function() _callback;
  late Duration _waitTime;
  bool _isActive = false;

  CustomTimer(Duration waitTime, Function() callback) {
    _waitTime = waitTime;
    _callback = callback;
  }

  void startTimer() {
    stopTimer();
    _timer = Timer.periodic(_waitTime, (timer) {
      _callback();
    });
    _isActive = true;
  }

  void stopTimer() {
    if (_isActive) {
      _timer.cancel();
      _isActive = false;
    }
  }

  void changeWaitTime(Duration newWaitTime) {
    stopTimer();
    _waitTime = newWaitTime;
    startTimer();
  }

  void changeTempo(int tempo, {bool restart = false}) {
    stopTimer();
    _waitTime = Duration(milliseconds: 1000 ~/ (tempo / 60));
    restart ? startTimer() : null;
  }
}
