import 'package:flutter/material.dart';

/// La class défini ci-dessous [UndefinedView] représente la vue
/// par default lorsque qu'une route demandé a l'aide d'un [Navigator]
/// n'est pas disponible
///
/// Elle prend un parametre [name] qui correspond a la route demandé
class UndefinedView extends StatelessWidget {
  /// nom [name] de la route non définie
  /// cause de l'appel de ce Widget
  final String? name;

  const UndefinedView({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        title: const Text(
          'Route non définie',
          textScaleFactor: 1.5,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.yellow),
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.wifi_off_outlined, color: Colors.yellow),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("IT'S NOT THE WAY !! GO AWAY")));
              })
        ],
      ),
      body: FractionallySizedBox(
        widthFactor: 1,
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
            Colors.deepOrange,
            Colors.red,
            Colors.deepOrangeAccent
          ])),
          child: FractionallySizedBox(
            widthFactor: 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Verifié que le nom:",
                    textScaleFactor: 1.5,
                    style: TextStyle(color: Colors.yellow)),
                const Divider(color: Colors.transparent),
                Text("'$name'",
                    textScaleFactor: 1.5,
                    style: const TextStyle(color: Colors.yellow)),
                const Divider(color: Colors.transparent),
                const Text("soit associé à une route éxistante",
                    textScaleFactor: 1.5,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.yellow)),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton:
          const Text('404 Not Found', textAlign: TextAlign.right),
    );
  }
}
