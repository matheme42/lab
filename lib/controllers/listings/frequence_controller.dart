import 'package:lab/controllers/controllers.dart';

class FrequenceController extends Controller<Frequence> {
  FrequenceController() : super(Table.frequence);

  Future<List<Frequence>> gets({required Habit habit}) async {
    Database db = await database;
    List<Map<String, dynamic>> freqListQuery = [];
    List<Frequence> freqs = [];

    freqListQuery = await db.query(table, where: 'habit_id = ?', whereArgs: [habit.id]);
    for (var frequence in freqListQuery) {
      freqs.add(Frequence()..fromMap(frequence, habit: habit));
    }
    return (freqs);
  }
}