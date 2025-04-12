import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lingonerds/core/routes/routes.dart';
import 'package:lingonerds/model/user/user_model.dart';

class FireStoreHandler{
  static CollectionReference<User> getUserCollection(){
    var collection =FirebaseFirestore.instance.collection(User.collectionName).withConverter(
      fromFirestore:(snapshot, options) {
        var data = snapshot.data();
        return User.fromFireStore(data);
      },
      toFirestore:(user, options) {
        return user.toFireStore();
      },);
    return collection;
  }
  static Future<void>createUser(User user){
  var collection=getUserCollection();
  collection.add(user);
  var docRef=collection.doc(user.id);
  return docRef.set(user);
  }
  static Future<void> updateLanguageLevel(String userId, String newLevel) async {
    var collection = getUserCollection();
    var docRef = collection.doc(userId);
    await docRef.update({
      "LanguageLevel": newLevel,
    }).then((_) {
      print("✅ Language Level Updated Successfully");
    }).catchError((error) {
      print("❌ Error updating Language Level: $error");
    });
  }
  static Future<void> checkLanguageLevelAndNavigate(BuildContext context, String userId) async {
    DocumentReference<User> userDocRef = getUserCollection().doc(userId);

    DocumentSnapshot<User> userDoc = await userDocRef.get();

    if (userDoc.exists) {
      String? languageLevel = userDoc.data()?.languageLevel; // Get the field safely

      if (languageLevel != null) {
        // 🔹 Navigate to the specific screen if LanguageLevel is set
        Navigator.pushNamedAndRemoveUntil(context,ScreensRoutes.mainHomeScreen,(route)=>false);
      } else {
        // 🔹 Navigate to the language test screen if LanguageLevel is null
        Navigator.pushNamedAndRemoveUntil(context,ScreensRoutes.languageLevelTestScreenRoute,(route)=>false);
      }
    }
  }
  static Future<T?> getUserField<T>(String userId, String fieldName) async {
    try {
      DocumentReference<User> userDocRef = getUserCollection().doc(userId);
      DocumentSnapshot<User> userDoc = await userDocRef.get();

      if (userDoc.exists) {
        User? user = userDoc.data(); // Get the User object
        if (user == null) return null;

        // Use reflection to access the field dynamically
        Map<String, dynamic> userData = user.toFireStore(); // Convert to a map
        return userData[fieldName] as T?;
      }
    } catch (e) {
      print("❌ Error fetching field '$fieldName': $e");
    }
    return null;
  }

}