import 'package:flutter/material.dart';
import 'package:lab/models/models.dart';

class Todoo extends Model {

  /// habit [habit]
  /// attache un [Todoo] a une habitude
  /// une frequence DOIT etre rattacher
  late Habit habit;

  /// date [date]
  /// Donne la date de création du [Todoo]
  late DateTime date;

  /// [fromMap] ce sert de ces parametre pour remplir les différents
  /// champs de l'appelant [this]
  @override
  void fromMap(Map<String, dynamic> data, {Habit? habit}) {
    data.containsKey("date") ? date =  DateTime.parse(data['date']) : 0;
    habit != null ? this.habit = habit : 0;
    super.fromMap(data);
  }


  /// convertie l'appelant [this] en [Map]
  /// [asMap] retourne ensuite l'appelant convertie
  @override
  Map<String, dynamic> asMap() {
    Map<String, dynamic> message = {};
    message['date'] = date.toIso8601String();
    message['habit_id'] = habit.id;
    message.addAll(super.asMap());
    return message;
  }

  /// [print] permet de débugger son programme
  /// convertie l'appelant en map et l'affiche en [debugPrint]
  void print() => debugPrint(asMap().toString());
}