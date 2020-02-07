import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';

class Counter with ChangeNotifier {
  int _count = 0;
  int get count => _count;

  bool get showClickerOptions => _count > 10 || _autoClickers > 0 ||  _autoClickMultiplier > 1;

  int _autoClickers = 0;
  int get autoClickers => _autoClickers;
  int get autoClickerCost => (10*pow(2, _autoClickers)).floor();
  bool get canAffordAnAutoClicker => _count >= autoClickerCost;


  int _autoClickMultiplier = 1;
  int get autoClickMultiplier => _autoClickMultiplier;
  int get autoClickerMultiplierCost => (100*pow(10, _autoClickMultiplier)).floor();
  bool get canAffordAnAutoClickMultiplier => _count >= autoClickerMultiplierCost;

  bool _timerRunning = false;


  void increment([int count = 1]) {
    _count = _count + (count * _autoClickMultiplier);
    notifyListeners();
  }


  void buyAutoClicker() {
    int cost = autoClickerCost;
    _autoClickers++;
    if(_timerRunning == false) {
      setupAutoClickLoop();
    }
    _count = _count-cost;
    notifyListeners();
  }


  void sellAutoClicker() {
    // sell for third current price
    int cost = autoClickerCost;
    _autoClickers--;
    _count = _count+(cost/3).floor();
    notifyListeners();
  }


  void setupAutoClickLoop() {
    print("setup timer");
    _timerRunning = true;
    Timer.periodic(new Duration(milliseconds: 200), (timer) {
      //debugPrint(timer.tick);
      increment(autoClickers);
    });
  }


  void buyAutoClickMultiplier() {
    int cost = autoClickerMultiplierCost;
    _autoClickMultiplier++;
    _count = _count-cost;
    notifyListeners();
  }


  void sellAutoClickMultiplier() {
    if(_autoClickMultiplier == 1) return;
    // sell for third current price
    int cost = autoClickerMultiplierCost;
    _autoClickMultiplier--;
    _count = _count+(cost/3).floor();
    notifyListeners();
  }
}