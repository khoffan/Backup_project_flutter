import 'package:flutter/foundation.dart';

class TimerInfo extends ChangeNotifier {
  int _timeRamining = 50;

  int getTimerDuration() => _timeRamining;

  updateTimer() {
    _timeRamining--;
    notifyListeners();
  }
}
