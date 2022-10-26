import 'dart:async';

import 'package:flutter/material.dart';

import 'root.dart';

/// Chaque application ce doit d'avoir un contexte d'execution
/// la class ci-dessous [RootContext] correspond au partern de
/// base
/// Cette class est à associé avec la class [Root]
///
/// [onKeyboardChange] est appelé a chaque fois que le clavier
/// change d'état. Peut-être utile dans certain cas.
/// false --> Keyboard is close
/// true  --> Keyboard is open
///
/// [onTurnBackground] est appelé a chaque fois que l'application
/// passe en arrière plan
///
/// [onTurnForeground] est appelé a chaque fois que l'application
/// passe en avant plan
///
/// [configure] est appelé a chaque démarrage de l'application
/// peut être utilisé pour initialisé le context
/// elle est executé derrière le SPLASH screen
///
/// [loading] est appelé après la fonction configure
/// et apres le chargement de la [MaterialApp]
/// Possibilité de l'associer avec une vue [Widget]
///
/// [RootContext] est défini en abstract est ne peut
/// donc pas etre utilisé en tant que tel
/// elle doit être hérité.
abstract class RootContext extends ChangeNotifier {
  /// Est appelé a chaque fois que le clavier
  /// change d'état. Peut-être utile dans certain cas.
  /// state == false --> Keyboard is close
  /// state == true  --> Keyboard is open
  StreamController <bool>onKeyboardChange = StreamController<bool>.broadcast();

  /// est appelé a chaque fois que l'application passe en arrière plan
  void onTurnBackground();

  /// est appelé a chaque fois que l'application passe en avant plan
  void onTurnForeground();

  /// est appelé a chaque démarrage de l'application
  /// peut être utilisé pour initialisé le context
  /// elle est executé derrière le SPLASH screen
  Future<void> configure();

  /// est appelé après la fonction configure
  /// et apres le chargement de la [MaterialApp]
  /// Possibilité de l'associer avec une vue [Widget]
  Future<void> loading();
}
