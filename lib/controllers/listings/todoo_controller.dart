import 'package:lab/controllers/controllers.dart';

class TodooController extends Controller<Todoo>{
  TodooController() : super(Table.todoo);

  Future<List<Todoo>> gets() async {
    Database db = await database;
    List<Map<String, dynamic>> todooListQuery = [];
    List<Todoo> todoo = [];

    todooListQuery = await db.query(table);
    for (var habit in todooListQuery) {
      todoo.add(Todoo()..fromMap(habit));
    }
    return (todoo);
  }
}
