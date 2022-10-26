import 'package:flutter/material.dart';
import 'package:lab/context.dart';
import 'package:lab/controllers/controllers.dart';
import 'package:provider/provider.dart';

class FormContext extends ChangeNotifier {

  /// PageController
  final PageController pageViewController = PageController();

  final Habit habit = Habit();
  final Frequence frequence = Frequence();

  /// manage the switch of the step2 of the form
  /// false => select Days
  /// true => select Numbers
  bool _switchState = false;
  bool get switchState => _switchState;
  set switchState(val) => _notify(() => _switchState = val);

  int _number = 1;
  int get number => _number;
  set number(val) => _notify(() => _number = val);


  int days = 0;


  Future<void> acceptHabit(AppContext appContext) async {
    await HabitudeController().insert(habit);
    frequence.habit = habit;
    frequence.date = DateTime.now();
    await FrequenceController().insert(frequence);
    habit.frequences.add(frequence);
    habit.curFreq = frequence;
    appContext.add = habit;
  }

  void _notify(Function f) {
    f();
    notifyListeners();
  }

  static FormContext of(BuildContext context, {bool listen = false}) {
    return Provider.of<FormContext>(context, listen: listen);
  }
}