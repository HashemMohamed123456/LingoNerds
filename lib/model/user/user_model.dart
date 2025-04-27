import 'package:flutter/cupertino.dart';

class User {
  static const String collectionName = "User";
  String? id;
  String? name;
  int? age;
  String? email;
  String? birthDate;
  String? languageLevel;

  User({this.id, this.name, this.age, this.email, this.birthDate, this.languageLevel});

  User.fromFireStore(Map<String, dynamic>? data) {
    id = data?["id"];
    name = data?["Name"];
    age = data?["Age"];
    email = data?["Email"];
    birthDate = data?["Birthdate"];
    languageLevel = data?["LanguageLevel"];
    debugPrint("User.fromFireStore: Loaded user - ID: $id, LanguageLevel: $languageLevel");
  }

  Map<String, dynamic> toFireStore() {
    final data = {
      "id": id,
      "Name": name,
      "Age": age,
      "Email": email,
      "Birthdate": birthDate,
      "LanguageLevel": languageLevel,
    };
    debugPrint("User.toFireStore: Saving user - ID: $id, LanguageLevel: $languageLevel");
    return data;
  }
}