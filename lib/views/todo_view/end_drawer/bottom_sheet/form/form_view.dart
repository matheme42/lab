import 'package:flutter/material.dart';
import 'package:lab/views/todo_view/end_drawer/bottom_sheet/form/form_context.dart';
import 'package:lab/views/todo_view/end_drawer/bottom_sheet/form/step1.dart';
import 'package:lab/views/todo_view/end_drawer/bottom_sheet/form/step2.dart';
import 'package:lab/views/todo_view/end_drawer/habit_context.dart';
import 'package:provider/provider.dart';

class HabitFormView extends StatelessWidget {
  const HabitFormView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FormContext(),
      child: Builder(builder: (context) {
        return PageView(
            controller: FormContext.of(context).pageViewController,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              Step1(),
              Step2(),
            ]);
      }),
    );
  }
}
