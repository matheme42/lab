import 'package:lab/context.dart';
import 'package:lab/packages/root/root.dart';
import 'package:lab/views/todo_view/todo_view.dart';

main() => Root<AppContext>(
    context: AppContext(), routes: {"/": (_) => const TodoView()});
