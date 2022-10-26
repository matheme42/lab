import 'package:flutter/material.dart';
import 'package:lab/context.dart';
import 'package:lab/views/todo_view/end_drawer/bottom_sheet/info/bottom_sheet.dart';
import 'package:lab/views/todo_view/end_drawer/habit_context.dart';
import 'package:lab/views/todo_view/end_drawer/habit_tile.dart';
import 'package:provider/provider.dart';

class HabitView extends StatelessWidget {
  const HabitView({Key? key}) : super(key: key);

  void goto(BuildContext context) {
    if (HabitContext.of(context).add) return;
    HabitContext.of(context).add = true;
    HabitContext.of(context).openBottomSheet();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => HabitContext(AppContext.of(context)),
      child: Builder(builder: (context) {
        return Scaffold(
            appBar: AppBar(
              leading: const SizedBox.shrink(),
              backgroundColor: Colors.green,
              title: const Text('Tes Habitudes'),
              actions: [
                Consumer<HabitContext>(builder: (context, habitContext, _) {
                  if (habitContext.add) {
                    return IconButton(
                        onPressed: () {
                          habitContext.closeBottomSheet();
                          habitContext.add = false;
                        },
                        icon: const Icon(Icons.keyboard_return));
                  }
                  return IconButton(
                      onPressed: () => goto(context),
                      icon: const Icon(Icons.add));
                })
              ],
            ),
            body: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/triskel_background.jpg'),
                      fit: BoxFit.fill)),
              child:
                  Consumer<HabitContext>(builder: (context, habitContext, _) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ListView.builder(
                      itemCount: habitContext.appContext.habits.length,
                      itemBuilder: (context, index) {
                        return HabitTile(
                            habit: habitContext.appContext.habits[index],
                            index: index);
                      }),
                );
              }),
            ),
            bottomSheet: DraggableScrollableSheet(
                maxChildSize: 0.7,
                initialChildSize: 0.0,
                minChildSize: 0.0,
                snap: true,
                expand: false,
                controller: HabitContext.of(context).sheetController,
                builder: (context, scrollController) {
                  return Container(
                      decoration: const BoxDecoration(
                        gradient:
                            LinearGradient(begin: Alignment.topLeft, colors: [
                          Colors.blueGrey,
                          Colors.green,
                          Colors.blueGrey,
                        ]),
                      ),
                      child: SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: scrollController,
                          child: Builder(builder: (context) {
                            var m = MediaQuery.of(context);
                            double height =
                                m.size.height * 0.64 + m.viewInsets.bottom;
                            return SizedBox(
                                height: height,
                                child: const HabitBottomSheet());
                          })));
                }));
      }),
    );
  }
}
