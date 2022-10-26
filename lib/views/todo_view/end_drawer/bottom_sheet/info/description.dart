import 'package:flutter/material.dart';
import 'package:lab/controllers/controllers.dart';
import 'package:lab/tools/validators.dart';
import 'package:lab/views/todo_view/end_drawer/habit_context.dart';

class BottomSheetDescription extends StatelessWidget {
  final Habit habit;

  const BottomSheetDescription({Key? key, required this.habit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController textController = TextEditingController(
      text: habit.description
    );
    var habitContext = HabitContext.of(context);
    FocusNode focusNode = FocusNode();
    return ValueListenableBuilder<bool>(
        valueListenable: habitContext.editDescriptionValue,
        builder: (context, edit, _) {
          return Row(
            children: [
              edit
                  ? IconButton(
                  onPressed: () {
                    habit.description = textController.text;
                    HabitudeController().update(habit).then((_) {
                      habitContext.editDescriptionValue.value = !habitContext.editDescriptionValue.value;
                    });
                  },
                  icon: const Icon(Icons.check, color: Colors.orange))
                  : IconButton(
                  onPressed: () {
                    habitContext.editTitleValue.value = false;
                    habitContext.editDescriptionValue.value = !habitContext.editDescriptionValue.value;
                    Future.delayed(const Duration(milliseconds: 100))
                        .then((_) {
                      focusNode.requestFocus();
                    });
                  },
                  icon: const Icon(Icons.edit, color: Colors.white70)),
              Expanded(
                child: TextFormField(
                  enabled: edit,
                  focusNode: focusNode,
                  autovalidateMode: AutovalidateMode.always,
                  minLines: 1,
                  maxLines: 5,
                  controller: textController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    labelStyle:
                        const TextStyle(fontSize: 20, color: Colors.white70),
                    labelText: 'Description',
                    floatingLabelAlignment: FloatingLabelAlignment.center,
                    fillColor: Colors.black.withAlpha(12),
                    filled: false,
                    border: InputBorder.none,
                    hintText: 'décrit ton habitude...',
                  ),
                  validator: CustomValidator.max100,
                ),
              ),
            ],
          );
        });
  }
}
