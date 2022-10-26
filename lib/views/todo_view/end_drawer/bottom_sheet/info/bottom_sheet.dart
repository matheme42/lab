import 'package:flutter/material.dart';
import 'package:lab/controllers/controllers.dart';
import 'package:lab/models/models.dart';
import 'package:lab/views/todo_view/end_drawer/bottom_sheet/info/description.dart';
import 'package:lab/views/todo_view/end_drawer/bottom_sheet/info/title.dart';
import 'package:lab/views/todo_view/end_drawer/bottom_sheet/form/form_view.dart';
import 'package:lab/views/todo_view/end_drawer/habit_context.dart';
import 'package:provider/provider.dart';

class FrequenceList extends StatelessWidget {
  final Habit habit;

  const FrequenceList({Key? key, required this.habit}) : super(key: key);

  String _getSubtitle() {
    if (habit.curFreq.name == Frequence.daily) {
      return "1 fois / jour";
    }

    if (habit.curFreq.name == Frequence.mensuel) {
      return "${habit.curFreq.number} fois / mois";
    }
    if (habit.curFreq.number != 0) {
      return "${habit.curFreq.number} fois / semaine";
    }
    return habit.curFreq.stringDays;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: ListTile(
        tileColor: Colors.black12,
        leading: AbsorbPointer(
            absorbing: true,
            child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.add, color: Colors.transparent))),
        trailing: IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        title: Text(habit.curFreq.name,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70)),
        subtitle: Text(_getSubtitle(),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70)),
      ),
    );
  }
}

class HabitBottomSheet extends StatelessWidget {
  const HabitBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HabitContext>(
        builder: (context, habitContext, child) {
        return WillPopScope(
          onWillPop: () async {
            habitContext.add = false;
            habitContext.closeBottomSheet();
            return false;
          },
          child: Builder(builder: (context) {
            Habit? habit = habitContext.selectedHabit;
            if  (habitContext.add) return const HabitFormView();
            if (habit == null) return Container();
            return Banner(
              location: BannerLocation.topEnd,
              color: !habit.status ? Colors.orange : Colors.lightGreen,
              message: !habit.status ? 'Inactif' : 'Actif',
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    centerTitle: true,
                    actions: [
                      IconButton(
                          onPressed: () {}, icon: const Icon(Icons.auto_graph)),
                      const Padding(padding: EdgeInsets.only(left: 40)),
                    ],
                    leading: IconButton(
                      onPressed: () {
                        HabitContext.of(context).selectedHabit = null;
                        HabitContext.of(context).closeBottomSheet();
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                    elevation: 0,
                    title: BottomSheetTitle(habit: habit)),
                body: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FractionallySizedBox(
                      widthFactor: 0.9,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const Divider(color: Colors.transparent),
                            BottomSheetDescription(habit: habit),
                            const Divider(color: Colors.transparent),
                            FrequenceList(habit: habit)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                bottomNavigationBar: BottomNavigationBar(
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(habit.status ? Icons.radio_button_checked : Icons.radio_button_unchecked_outlined),
                      label: habit.status ? 'Desactiver' : 'Activer',
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.delete_outline, color: Colors.orange),
                      label: 'Supprimer',
                    ),
                  ],
                  currentIndex: 0,
                  selectedItemColor: Colors.white70,
                  unselectedItemColor: Colors.orange,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  onTap: (index) async {
                    if (index == 0) {
                      habit.status = !habit.status;
                      HabitudeController().update(habit).then((_) {
                        habitContext.notifie();
                      });
                    }
                    if (index == 1) {
                     for (var freq in habit.frequences) {
                       await FrequenceController().delete(freq);
                     }
                     habit.frequences.clear();
                     await HabitudeController().delete(habit);
                     habitContext.deleteSelectedHabit = null;
                     habitContext.appContext.remove = habit;
                     habitContext.closeBottomSheet();
                    }
                  },
                ),
              ),
            );
          }),
        );
      }
    );
  }
}
