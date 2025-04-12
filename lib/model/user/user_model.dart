class User{
  static const String collectionName="User";
  String? id;
  String? name;
  int? age;
  String? email;
  String? birthDate;
  String?languageLevel;
  User({this.id, this.name, this.age, this.email, this.birthDate,this.languageLevel});
  User.fromFireStore(Map<String,dynamic>?data){
    id=data?["id"];
    name=data?["Name"];
    age=data?["Age"];
    email=data?["Email"];
    birthDate=data?["Birthdate"];
    languageLevel=data?["LanguageLevel"];
  }
  Map<String,dynamic>toFireStore(){
    return {
      "id":id,
      "Name":name,
      "Age":age,
      "Email":email,
      "Birthdate":birthDate,
      "LanguageLevel":languageLevel
    };
  }
}