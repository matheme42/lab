import 'package:flutter/material.dart';
import 'package:lab/views/todo_view/end_drawer/habit_view.dart';

class TodoView extends StatelessWidget {
  const TodoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const HabitView(),
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Todo'),
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/triskel_background.jpg'),
                fit: BoxFit.fill)),
        child: FractionallySizedBox(
          widthFactor: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Text("A faire Aujoud'hui"),
              Text("A venir cette semaine"),
              Text("A venir Ce mois-ci"),
            ],
          ),
        ),
      ),
    );
  }

}