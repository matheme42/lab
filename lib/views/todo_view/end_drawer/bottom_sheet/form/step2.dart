import 'package:day_picker/day_picker.dart';
import 'package:flutter/material.dart';
import 'package:lab/context.dart';
import 'package:lab/controllers/controllers.dart';
import 'package:lab/views/todo_view/end_drawer/bottom_sheet/form/form_context.dart';
import 'package:lab/views/todo_view/end_drawer/habit_context.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

class Step2 extends StatelessWidget {
  const Step2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget widget = const SizedBox.shrink();

    switch (FormContext.of(context).frequence.name) {
      case Frequence.daily:
        widget = const Step2Daily();
        break;
      case Frequence.hebdo:
        widget = const Step2Hebdo();
        break;
      case Frequence.mensuel:
        widget = const Step2Mens();
        break;
    }

    return Scaffold(
      backgroundColor: Colors.white54,
      body: Center(
        child: Padding(padding: const EdgeInsets.all(8.0), child: widget),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.deepPurple,
          onPressed: () {
            FormContext formContext = FormContext.of(context);
            AppContext appContext = AppContext.of(context);
            Frequence freq = formContext.frequence;

            if (freq.name == Frequence.daily) {
              freq.number = formContext.number;
            } else if (freq.name == Frequence.hebdo) {
              if (formContext.switchState == false) {
                freq.days = formContext.days;
              } else {
                freq.number = formContext.number;
              }
            } else {
              freq.number = formContext.number;
            }
            formContext.acceptHabit(appContext).then((_) {
              HabitContext.of(context).add = false;
              HabitContext.of(context).closeBottomSheet();
            });
          },
          label: const Text('Suivant')),
    );
  }
}

class Step2Daily extends StatelessWidget {
  const Step2Daily({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

class Step2Mens extends StatelessWidget {
  const Step2Mens({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Divider(color: Colors.transparent),
        Consumer<FormContext>(builder: (context, formData, widget) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                colors: [Color(0xFFE55CE4), Colors.deepPurple],
                tileMode: TileMode.repeated,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: NumberPicker(
                value: FormContext.of(context, listen: true).number,
                minValue: 1,
                axis: Axis.horizontal,
                maxValue: 10,
                infiniteLoop: true,
                haptics: true,
                selectedTextStyle: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
                textStyle: const TextStyle(color: Colors.white),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white),
                ),
                onChanged: (value) {
                  FormContext.of(context).number = value;
                },
              ),
            ),
          );
        }),
        const Divider(color: Colors.transparent),
      ],
    );
  }
}

class Step2Hebdo extends StatelessWidget {
  const Step2Hebdo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<DayInWeek> days = [
      DayInWeek("Lun"),
      DayInWeek("Mar"),
      DayInWeek("Mer"),
      DayInWeek("Jeu"),
      DayInWeek("Ven"),
      DayInWeek("Sam"),
      DayInWeek("Dim"),
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Jours'),
            Switch(
                value: FormContext.of(context, listen: true).switchState,
                onChanged: (val) => FormContext.of(context).switchState = val),
            const Text('nombres'),
          ],
        ),
        const Divider(color: Colors.transparent),
        Consumer<FormContext>(builder: (context, formData, widget) {
          bool value = !formData.switchState;
          return AbsorbPointer(
              absorbing: !value,
              child: Opacity(
                opacity: value ? 1 : 0.3,
                child: SelectWeekDays(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  days: days,
                  border: false,
                  boxDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      colors: value
                          ? [const Color(0xFFE55CE4), Colors.deepPurple]
                          : [Colors.grey, Colors.grey],
                      tileMode: TileMode
                          .repeated, // repeats the gradient over the canvas
                    ),
                    color: Colors.grey,
                  ),
                  onSelect: (List<dynamic> values) {
                    int days = 0;
                    days = values.contains('Lun') ? days | 1 : days;
                    days = values.contains('Mar') ? days | 2 : days;
                    days = values.contains('Mer') ? days | 4 : days;
                    days = values.contains('Jeu') ? days | 8 : days;
                    days = values.contains('Ven') ? days | 16 : days;
                    days = values.contains('Sam') ? days | 32 : days;
                    days = values.contains('Dim') ? days | 64 : days;
                    FormContext.of(context).days = days;
                  },
                ),
              ));
        }),
        const Divider(color: Colors.transparent),
        Consumer<FormContext>(builder: (context, formData, widget) {
          bool value = formData.switchState;
          return AbsorbPointer(
            absorbing: !value,
            child: Opacity(
              opacity: value ? 1 : 0.3,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    colors: value
                        ? [const Color(0xFFE55CE4), Colors.deepPurple]
                        : [Colors.grey, Colors.grey],
                    tileMode: TileMode.repeated,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: NumberPicker(
                    value: FormContext.of(context, listen: true).number,
                    minValue: 1,
                    axis: Axis.horizontal,
                    maxValue: 10,
                    infiniteLoop: true,
                    haptics: true,
                    selectedTextStyle: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    textStyle: const TextStyle(color: Colors.white),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white),
                    ),
                    onChanged: (value) {
                      FormContext.of(context).number = value;
                    },
                  ),
                ),
              ),
            ),
          );
        }),
        const Divider(color: Colors.transparent),
        const Divider(color: Colors.transparent),
      ],
    );
  }
}
