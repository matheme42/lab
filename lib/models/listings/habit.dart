import 'package:flutter/material.dart';
import 'package:lab/models/models.dart';


/// la class [Habit] permet de contient les bases d'une habitude
class Habit extends Model {

  /// nom [name] de l'habitude
  String name = "";

  /// description [description] de l'habitude
  /// petit text pour compléter le nom
  /// non obligatoire
  String description = "";

  /// true si l'habitude est actif (Doit être prise en compte dans les calculs)
  /// false si l'habitude est inactif
  bool status = true;

  /// contient la liste complete de toutes les fréquences
  /// (quel a pu avoir également) de l'habitude
  final List<Frequence> frequences = [];

  /// contiens la liste de tous les todoos déjà réalisé
  final List<Todoo> todoos = [];

  late Frequence curFreq;

  /// [fromMap] ce sert de ces parametre pour remplir les différents
  /// champs de l'appelant [this]
  @override
  void fromMap(Map<String, dynamic> data, {Habit? habit}) {
    data.containsKey("name") ? name = data["name"].toString().trim() : 0;
    data.containsKey("status") ? status = data["status"].toString() == "1" : 0;
    data.containsKey("description") ? description = data["description"].toString().trim() : 0;
    super.fromMap(data);
  }


  /// convertie l'appelant [this] en [Map]
  /// [asMap] retourne ensuite l'appelant convertie
  @override
  Map<String, dynamic> asMap() {
    Map<String, dynamic> message = {};
    message['name'] = name;
    message['status'] = status ? 1 : 0;
    message['description'] = description;
    message.addAll(super.asMap());
    return message;
  }

  /// [print] permet de débugger son programme
  /// convertie l'appelant en map et l'affiche en [debugPrint]
  void print() => debugPrint(asMap().toString());
}