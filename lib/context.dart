import 'package:flutter/material.dart';
import 'package:lab/controllers/controllers.dart';
import 'package:lab/packages/root/context.dart';
import 'package:provider/provider.dart';

class AppContext extends RootContext {
  final List<Habit> _habits = [];
  final List<Todoo> _todoo = [];

  List<Habit> get habits => _habits;
  List<Todoo> get todoo => _todoo;

  set add(dynamic model) {
    if (model is Habit) {
      _habits.add(model);
    } else if (model is Todoo) {
      _todoo.add(model);
    }
    notifyListeners();
  }

  set remove(dynamic model) {
    if (model is Habit) {
      _habits.remove(model);
    } else if (model is Todoo) {
      _todoo.remove(model);
    }
    notifyListeners();
  }

  @override
  void onTurnBackground() {}


  @override
  void onTurnForeground() {}

  Future<void> _generateTodoo() async {
  }

  @override
  Future<void> configure() async {
    habits.addAll(await HabitudeController().gets());
    for (var habit in habits) {
      habit.frequences.addAll(await FrequenceController().gets(habit: habit));
      habit.curFreq = habit.frequences.firstWhere((e) => e.status == true);
    }
    await _generateTodoo();
  }

  static AppContext of(BuildContext context, {bool listen = false}) {
    return Provider.of<AppContext>(context, listen: listen);
  }

  @override
  Future<void> loading() async {}
}
