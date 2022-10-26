import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lab/context.dart';
import 'package:lab/models/models.dart';
import 'package:provider/provider.dart';

class HabitContext extends ChangeNotifier {
  final AppContext appContext;

  late StreamSubscription streamSubScription;

  HabitContext(this.appContext) {
    appContext.addListener(notifie);
    streamSubScription = appContext.onKeyboardChange.stream.listen(onKeyboardChange);
  }

  void onKeyboardChange(bool state) {
    if (state == false) {
      editDescriptionValue.value = false;
      editTitleValue.value = false;
    }
  }

  @override
  void dispose() {
    appContext.removeListener(notifie);
    streamSubScription.cancel();
    super.dispose();
  }

  final sheetController = DraggableScrollableController();

  final ValueNotifier<bool> editDescriptionValue = ValueNotifier<bool>(false);

  final ValueNotifier<bool> editTitleValue = ValueNotifier<bool>(false);

  bool _add = false;

  bool get add => _add;

  set add(v) => notifie(f: () {
    _selectedHabit = null;
    _add = v;
  });


  Habit? _selectedHabit;

  Habit? get selectedHabit => _selectedHabit;

  set deleteSelectedHabit(v) => _selectedHabit = v;

  set selectedHabit(value) => notifie(f: () {
        _add = false;
        editDescriptionValue.value = false;
        editTitleValue.value = false;
        _selectedHabit = value;
      });

  Future<void> openBottomSheet() {
    return sheetController.animateTo(0.7,
        duration: const Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  Future<void> closeBottomSheet() {
    return sheetController.animateTo(0.0,
        duration: const Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void notifie({Function? f}) {
    if (f != null) f();
    notifyListeners();
  }

  static HabitContext of(BuildContext context, {bool listen = false}) {
    return Provider.of<HabitContext>(context, listen: listen);
  }
}
