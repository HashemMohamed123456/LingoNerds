import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lingonerds/core/routes/routes.dart';
import 'package:lingonerds/model/user/user_model.dart';

class FireStoreHandler {
  static CollectionReference<User> getUserCollection() {
    var collection = FirebaseFirestore.instance.collection(User.collectionName).withConverter(
      fromFirestore: (snapshot, options) {
        var data = snapshot.data();
        return User.fromFireStore(data);
      },
      toFirestore: (user, options) {
        return user.toFireStore();
      },
    );
    return collection;
  }

  static Future<void> createUser(User user) async {
    debugPrint("FireStoreHandler: Inside createUser() for UID: ${user.id}");
    var collection = getUserCollection();
    var docRef = collection.doc(user.id);
    // Check to avoid overwriting
    var existing = await docRef.get(const GetOptions(source: Source.server));
    if (!existing.exists) {
      await docRef.set(user);
      debugPrint("FireStoreHandler: ✅ User created with LanguageLevel: ${user.languageLevel}");
    } else {
      debugPrint("FireStoreHandler: ℹ️ User already exists");
    }
  }

  static Future<void> updateLanguageLevel(String userId, String newLevel) async {
    try {
      var collection = getUserCollection();
      var docRef = collection.doc(userId);
      await docRef.update({
        "LanguageLevel": newLevel,
      });
      debugPrint("FireStoreHandler: ✅ LanguageLevel updated to $newLevel for UID: $userId");
    } catch (error) {
      debugPrint("FireStoreHandler: ❌ Error updating LanguageLevel: $error");
      rethrow;
    }
  }

  static Future<void> checkLanguageLevelAndNavigate(BuildContext context, String userId) async {
    DocumentReference<User> userDocRef = getUserCollection().doc(userId);
    DocumentSnapshot<User> userDoc = await userDocRef.get(const GetOptions(source: Source.server));

    if (userDoc.exists) {
      String? languageLevel = userDoc.data()?.languageLevel;
      debugPrint("FireStoreHandler: checkLanguageLevelAndNavigate - LanguageLevel: $languageLevel");
      if (languageLevel != null) {
        Navigator.pushNamedAndRemoveUntil(context, ScreensRoutes.mainHomeScreen, (route) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(context, ScreensRoutes.languageLevelTestScreenRoute, (route) => false);
      }
    }
  }

  static Future<T?> getUserField<T>(String userId, String fieldName) async {
    try {
      DocumentReference<User> userDocRef = getUserCollection().doc(userId);
      DocumentSnapshot<User> userDoc = await userDocRef.get(const GetOptions(source: Source.server));
      if (userDoc.exists) {
        User? user = userDoc.data();
        if (user == null) return null;
        Map<String, dynamic> userData = user.toFireStore();
        debugPrint("FireStoreHandler: Fetched $fieldName: ${userData[fieldName]}");
        return userData[fieldName] as T?;
      }
      debugPrint("FireStoreHandler: User document does not exist for UID: $userId");
      return null;
    } catch (e) {
      debugPrint("FireStoreHandler: ❌ Error fetching field '$fieldName': $e");
      rethrow;
    }
  }

  static Future<User?> getUser(String userId) async {
    try {
      DocumentReference<User> userDocRef = getUserCollection().doc(userId);
      DocumentSnapshot<User> userDoc = await userDocRef.get(const GetOptions(source: Source.server));
      final user = userDoc.data();
      debugPrint("FireStoreHandler: Fetched user - UID: $userId, LanguageLevel: ${user?.languageLevel}");
      return user;
    } catch (e) {
      debugPrint("FireStoreHandler: ❌ Error fetching user: $e");
      return null;
    }
  }

  static Future<void> updateUser({
    required String userId,
    String? name,
    int? age,
    String? email,
    String? birthDate,
  }) async {
    try {
      final userDoc = getUserCollection().doc(userId);
      final updateData = <String, dynamic>{};
      if (name != null) updateData['Name'] = name;
      if (age != null) updateData['Age'] = age;
      if (email != null) updateData['Email'] = email;
      if (birthDate != null) updateData['Birthdate'] = birthDate;

      if (updateData.isNotEmpty) {
        await userDoc.update(updateData);
        debugPrint('FireStoreHandler: ✅ User updated successfully for UID: $userId');
      }
    } catch (e) {
      debugPrint('FireStoreHandler: ❌ Error updating user: $e');
      rethrow;
    }
  }
}