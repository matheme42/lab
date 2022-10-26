import 'package:lab/controllers/controllers.dart';

class HabitudeController extends Controller<Habit>{
  HabitudeController() : super(Table.habitude);

  Future<List<Habit>> gets() async {
    Database db = await database;
    List<Map<String, dynamic>> habitListQuery = [];
    List<Habit> habits = [];

    habitListQuery = await db.query(table);
    for (var habit in habitListQuery) {
      habits.add(Habit()..fromMap(habit));
    }
    return (habits);
  }
}
