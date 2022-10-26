import 'package:flutter/material.dart';
import 'package:lab/models/models.dart';
import 'package:lab/views/todo_view/end_drawer/habit_context.dart';

class HabitTile extends StatelessWidget {
  final Habit habit;
  final int index;

  const HabitTile({Key? key, required this.habit, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool sens = index % 2 == 0;
    return Align(
      alignment: sens ? Alignment.topLeft : Alignment.topRight,
      child: FractionallySizedBox(
        widthFactor: 0.8,
        child: Card(
          color: sens
              ? Colors.brown.withAlpha(150)
              : Colors.blueGrey.withAlpha(150),
          elevation: 30,
          child: ListTile(
            onTap: () {
              HabitContext.of(context).openBottomSheet();
              HabitContext.of(context).selectedHabit = habit;
            },
            title: Text(habit.name,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white)),
            leading: sens
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset('assets/triiskel.png'),
                  )
                : Text(
                    habit.status ? 'Actif' : 'Inactif',
                    style: TextStyle(
                        color: !habit.status
                            ? Colors.red
                            : Colors.lightGreenAccent),
                  ),
            trailing: sens
                ? Text(
                    habit.status ? 'Actif' : 'Inactif',
                    style: TextStyle(
                        color: !habit.status
                            ? Colors.red
                            : Colors.lightGreenAccent),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset('assets/triiskel.png'),
                  ),
          ),
        ),
      ),
    );
  }
}
