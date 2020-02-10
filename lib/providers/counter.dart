import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_incremental/models/progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Counter with ChangeNotifier {

  SharedPreferences prefs;
  Progress progress;

  bool get showClickerOptions => progress != null &&  (progress.count> 10 || progress.autoClickers > 0 ||  progress.autoClickersMultiplier > 1);

  int get autoClickerCost => (10*pow(2, progress.autoClickers)).floor();
  bool get canAffordAnAutoClicker => progress.count >= autoClickerCost;

  int get autoClickerMultiplierCost => (10*pow(5, progress.autoClickersMultiplier)).floor();
  bool get canAffordAnAutoClickMultiplier => progress.count >= autoClickerMultiplierCost;

  bool get timerCanBeIncreased => progress.timerSpeed > 100;
  int get increaseTimerCost => (10*pow(10, progress.increaseTimerPurchases)).floor();
  bool get canAffordIncreaseTimer=> progress.count >= increaseTimerCost;
  bool _timerRunning = false;
  Timer _timer;


  Future<void> init() async {
    if(progress != null) return;
    prefs = await SharedPreferences.getInstance();
    //prefs.clear();
    String saveData = prefs.getString("progress");
    if(saveData != null) {
      progress = Progress.fromJson(jsonDecode(saveData));
      setupAutoClickLoop();
    } else {
      progress = Progress(
        clicks: 0,
        count: 0,
        autoClickers: 0,
        autoClickersMultiplier: 1,
        increaseTimerPurchases: 0,
        timerSpeed: 1000,
      );
      prefs.setString("progress", jsonEncode(progress.toJson()));
    }
    return;
  }


  void saveProgress() {
    prefs.setString("progress", jsonEncode(progress.toJson()));
  }


  void increment([int count = 1]) {
    int newClicks = count * progress.autoClickersMultiplier;
    progress.clicks = progress.clicks + newClicks;
    progress.count = progress.count + newClicks;
    notifyListeners();
  }


  void buyAutoClicker() {
    int cost = autoClickerCost;
    progress.autoClickers++;
    if(_timerRunning == false) {
      setupAutoClickLoop();
    }
    progress.count = progress.count-cost;
    notifyListeners();
  }


  void sellAutoClicker() {
    // sell for third current price
    int cost = autoClickerCost;
    progress.autoClickers--;
    progress.count = progress.count+(cost/3).floor();
    notifyListeners();
  }


  void setupAutoClickLoop() {
    if(_timer != null) {
      print("cancel old timer");
      _timer.cancel();
    }
    print("setup timer @ ${progress.timerSpeed}");
    _timerRunning = true;
    _timer = Timer.periodic(new Duration(milliseconds: progress.timerSpeed), (timer) {
      //debugPrint(timer.tick);
      increment(progress.autoClickers);
      saveProgress();
    });
  }


  void buyAutoClickMultiplier() {
    int cost = autoClickerMultiplierCost;
    progress.autoClickersMultiplier++;
    progress.count = progress.count-cost;
    notifyListeners();
  }


  void sellAutoClickMultiplier() {
    if(progress.autoClickersMultiplier == 1) return;
    // sell for third current price
    int cost = autoClickerMultiplierCost;
    progress.autoClickersMultiplier--;
    progress.count = progress.count+(cost/3).floor();
    notifyListeners();
  }


  void buyIncreaseSpeed() {
    if(!timerCanBeIncreased) return;
    int cost = increaseTimerCost;
    progress.timerSpeed = progress.timerSpeed - 100;
    progress.increaseTimerPurchases++;
    progress.count = progress.count-cost;
    notifyListeners();
    setupAutoClickLoop();
  }
}