import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lab/controllers/controllers.dart';
import 'package:lab/views/todo_view/end_drawer/habit_context.dart';

class BottomSheetTitle extends StatelessWidget {
  final Habit habit;

  const BottomSheetTitle({Key? key, required this.habit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController textController = TextEditingController(
      text: habit.name
    );
    FocusNode focusNode = FocusNode();
    var habitContext = HabitContext.of(context);
    return ValueListenableBuilder<bool>(
      valueListenable: habitContext.editTitleValue,
      builder: (BuildContext context, edit, Widget? child) {
        if (edit == false) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                flex: 4,
                  child: AutoSizeText(habit.name, minFontSize: 2, maxLines: 1)),
              Flexible(
                child: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    habitContext.editTitleValue.value = !habitContext.editTitleValue.value;
                    habitContext.editDescriptionValue.value = false;
                    Future.delayed(const Duration(milliseconds: 100)).then((_) {
                      focusNode.requestFocus();
                    });
                  },
                ),
              ),
            ],
          );
        }
        return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(
            child: TextFormField(
              focusNode: focusNode,
              controller: textController,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.check, color: Colors.orange),
            padding: EdgeInsets.zero,
            onPressed: () {
              HabitudeController().update(habit).then((value) {
                habit.name = textController.text;
                habitContext.editTitleValue.value = !habitContext.editTitleValue.value;
              });
            },
          ),
        ]);
      },
    );
  }
}
