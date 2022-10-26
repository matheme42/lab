import 'package:flutter/material.dart';
import 'package:lab/models/models.dart';


/// la class [Frequence] permet de définir quel fréquence sont disponible
/// pour définir une habitude.

class Frequence extends Model {

  /// listing des différents nom disponibles
  /// pour définir une Frequence
  static const String daily = "Daily";
  static const String hebdo = "Hebdo";
  static const String mensuel = "mensuel";

  /// nom [name] de la fréquence
  /// il existe 3 types de fréquence
  /// Daily, Hebdo, Mensuel
  String name = "";

  /// days [days] utile si la fréquence et hebdomadaire
  /// [days] & 1  - Lun
  /// [days] & 2  - Mar
  /// [days] & 4  - Mer
  /// [days] & 8  - Jeu
  /// [days] & 16 - Ven
  /// [days] & 32 - Sam
  /// [days] & 64 - Dim
  int days = 0;

  /// number [number] utile en toutes circonstances
  /// Defini combien de fois l'habitude devra être réalisé
  /// en 1 jour/semaine/mois
  int number = 0;


  /// défini si la fréquence est active [status] ou non
  bool status = true;


  /// date [date]
  /// donne la date de création de la frequence
  late DateTime date;


  /// habit [habit]
  /// attache une frequence a une habitude
  /// une frequence DOIT etre rattacher
  late Habit habit;


  /// [fromMap] ce sert de ces parametre pour remplir les différents
  /// champs de l'appelant [this]
  @override
  void fromMap(Map<String, dynamic> data, {Habit? habit}) {
    data.containsKey("name") ? name = data["name"].toString().trim() : 0;
    data.containsKey("days") ? days = int.parse(data["days"].toString()) : 0;
    data.containsKey("number") ? number = int.parse(data["number"].toString()) : 0;
    data.containsKey("date") ? date =  DateTime.parse(data['date']) : 0;
    data.containsKey("status") ? status =  data["status"].toString() == "1" : 0;
    habit != null ? this.habit = habit : 0;
    super.fromMap(data);
  }


  /// convertie l'appelant [Frequence] en [Map]
  /// [asMap] retourne ensuite l'appelant convertie
  @override
  Map<String, dynamic> asMap() {
    Map<String, dynamic> message = {};
    message['name'] = name.toString();
    message['days'] = days;
    message['number'] = number;
    message['date'] = date.toIso8601String();
    message['status'] = status ? 1 : 0;
    message['habit_id'] = habit.id;
    message.addAll(super.asMap());
    return message;
  }

  String get stringDays {
    String str = "";

    str = days & 1 != 0 ?  "$str lun" : str;
    str = days & 2 != 0 ?  "$str mar" : str;
    str = days & 4 != 0  ?  "$str mer" : str;
    str = days & 8 != 0 ?  "$str jeu" : str;
    str = days & 16 != 0  ?  "$str ven" : str;
    str = days & 32 != 0  ?  "$str sam" : str;
    str = days & 64 != 0  ?  "$str dim" : str;

    return str;
  }

  /// [print] permet de débugger son programme
  /// convertie l'appelant en map et l'affiche en [debugPrint]
  void print() => debugPrint(asMap().toString());
}
