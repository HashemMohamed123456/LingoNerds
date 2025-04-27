import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:lingonerds/core/firebase/firebase_auth_codes.dart';
import 'package:lingonerds/core/firebase/firestore_handler.dart';
import 'package:lingonerds/model/user/user_model.dart' as my_user;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../local/local_data.dart';
import 'auth_states.dart';



class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitState());
  static AuthCubit get(context) => BlocProvider.of<AuthCubit>(context);

  TextEditingController signUpNameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController signUpEmailController = TextEditingController();
  TextEditingController signUpPasswordController = TextEditingController();
  TextEditingController signUpConfirmationPasswordController = TextEditingController();
  TextEditingController signUpBirthDateController = TextEditingController();
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();
  TextEditingController changingNameController = TextEditingController();
  TextEditingController changingAgeController = TextEditingController();
  TextEditingController changingEmailController = TextEditingController();
  TextEditingController changingBirthDateController = TextEditingController();
  TextEditingController currentPasswordController = TextEditingController();
  GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> editingProfileFormKey = GlobalKey<FormState>();

  my_user.User? _userData;
  my_user.User? get userData => _userData;

  bool showPassword = false;
  bool obscureText = true;
  bool showConfirmationPassword = false;
  bool obscureConfirmationText = true;
  bool showLoginPassword = false;
  bool obscureLoginText = true;

  void hidePassword() {
    showPassword = !showPassword;
    obscureText = !obscureText;
    emit(ShowOrHidePasswordSuccessState());
  }

  void hideLoginPassword() {
    showLoginPassword = !showLoginPassword;
    obscureLoginText = !obscureLoginText;
    emit(ShowOrHideLoginPasswordSuccessState());
  }

  void hideConfirmationPassword() {
    showConfirmationPassword = !showConfirmationPassword;
    obscureConfirmationText = !obscureConfirmationText;
    emit(ShowOrHideConfirmationPasswordSuccessState());
  }

  Future<void> signUp() async {
    emit(SignUpLoadingState());
    try {
      debugPrint("AuthCubit: Creating Firebase user...");
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: signUpEmailController.text,
        password: signUpPasswordController.text,
      );
      debugPrint("AuthCubit: Firebase user created");
      await credential.user?.sendEmailVerification();
      debugPrint("AuthCubit: Verification email sent");
      debugPrint("AuthCubit: Writing to Firestore...");
      await FireStoreHandler.createUser(my_user.User(
        id: credential.user!.uid,
        name: signUpNameController.text,
        age: int.parse(ageController.text),
        birthDate: signUpBirthDateController.text,
        email: signUpEmailController.text,
        languageLevel: 'A1', // Set default level
      ));
      debugPrint("AuthCubit: Firestore write complete");
      emit(SignUpSuccessState());
    } on FirebaseAuthException catch (e) {
      if (e.code == FirebaseAuthCodes.weakPassword) {
        debugPrint('AuthCubit: The password provided is too weak.');
        emit(SignUpFirebaseAuthWeakPasswordErrorState());
      } else if (e.code == FirebaseAuthCodes.emailAlreadyInUse) {
        debugPrint('AuthCubit: The account already exists for that email.');
        emit(SignUpFirebaseAuthEmailAlreadyInUseErrorState());
      }
    } catch (e) {
      debugPrint("AuthCubit: SignUp error: $e");
      emit(SignUpOtherErrorState());
    }
  }

  Future<void> login() async {
    emit(LoginLoadingState());
    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: loginEmailController.text,
        password: loginPasswordController.text,
      );
      final user = userCredential.user;
      if (user != null) {
        LocalData.set(key: "isLoggedIn", value: true);
        LocalData.set(key: "userId", value: user.uid);
        debugPrint("AuthCubit: Login successful, UID: ${user.uid}");
        emit(LoginSuccessState());
      } else {
        debugPrint("AuthCubit: Login failed, no user");
        emit(LoginErrorState('Login failed'));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == FirebaseAuthCodes.userNotFound) {
        debugPrint("AuthCubit: User not found");
        emit(UserNotFoundErrorState());
      } else if (e.code == FirebaseAuthCodes.wrongPassword) {
        debugPrint("AuthCubit: Wrong password");
        emit(WrongPasswordErrorState());
      } else {
        debugPrint("AuthCubit: Login error: ${e.message}");
        emit(LoginErrorState(e.message ?? 'Login failed'));
      }
    } catch (error) {
      debugPrint("AuthCubit: Login other error: $error");
      emit(LoginOtherErrorState());
    }
  }

  Future<void> resendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        debugPrint("AuthCubit: Resent verification email to ${user.email}");
        emit(EmailVerificationRequiredState(user.email!));
      }
    } catch (e) {
      debugPrint('AuthCubit: Error resending verification email: $e');
      emit(LoginErrorState('Failed to resend verification email'));
    }
  }

  Future<void> signOut() async {
    emit(SignOutLoadingState());
    await FirebaseAuth.instance.signOut();
    LocalData.set(key: "isLoggedIn", value: false);
    LocalData.removeData(key: "userId");
    _userData = null;
    debugPrint("AuthCubit: Signed out");
    emit(SignOutSuccessState());
  }

  Future<String?> fetchUserData({required String data}) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        debugPrint('AuthCubit: No user is signed in');
        return null;
      }
      final value = await FireStoreHandler.getUserField(user.uid, data);
      debugPrint("AuthCubit: Fetched $data: $value");
      return value;
    } catch (e) {
      debugPrint('AuthCubit: Error fetching $data: $e');
      rethrow;
    }
  }

  Future<void> loadUserData() async {
    emit(LoadingUserDataState());
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        debugPrint('AuthCubit: No user is signed in');
        emit(LoadingUserDataErrorState(message: 'No user is signed in'));
        return;
      }
      final userData = await FireStoreHandler.getUser(user.uid);
      if (userData == null) {
        debugPrint('AuthCubit: User data not found');
        emit(LoadingUserDataErrorState(message: 'User data not found'));
        return;
      }
      _userData = userData;
      changingNameController.text = userData.name ?? '';
      changingAgeController.text = userData.age?.toString() ?? '';
      changingEmailController.text = userData.email ?? '';
      changingBirthDateController.text = userData.birthDate ?? '';
      debugPrint("AuthCubit: Loaded user data - Name: ${userData.name}, Level: ${userData.languageLevel}");
      emit(UserDataLoadedState(userData));
    } catch (e) {
      debugPrint("AuthCubit: Error loading user data: $e");
      emit(LoadingUserDataErrorState(message: e.toString()));
    }
  }

  Future<void> updateUserProfile({
    required String name,
    required String age,
    required String birthDate,
    required String email,
    required String currentPassword,
  }) async {
    emit(ProfileUpdatingState());
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        debugPrint("AuthCubit: No user logged in");
        throw Exception('No user logged in');
      }

      // Check if email has changed
      bool emailChanged = email != user.email;

      if (emailChanged) {
        // Re-authenticate the user first
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );
        await user.reauthenticateWithCredential(credential);
        debugPrint("AuthCubit: Re-authenticated user for email change");

        // Update email
        await user.updateEmail(email);
        debugPrint("AuthCubit: Updated email to $email");
      }

      // Update Firestore
      int? parsedAge = int.tryParse(age);
      await FireStoreHandler.updateUser(
        userId: user.uid,
        name: name,
        age: parsedAge,
        email: email,
        birthDate: birthDate,
      );
      debugPrint("AuthCubit: Updated Firestore - Name: $name, Email: $email, Birthdate: $birthDate");

      // Update local controllers
      changingNameController.text = name;
      changingAgeController.text = age;
      changingEmailController.text = email;
      changingBirthDateController.text = birthDate;
      currentPasswordController.clear();

      emit(ProfileUpdateSuccessState());
      await loadUserData();
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'requires-recent-login':
          errorMessage = 'Please re-login and try again';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address';
          break;
        case 'email-already-in-use':
          errorMessage = 'Email already in use';
          break;
        case 'weak-password':
          errorMessage = 'Password is too weak';
          break;
        default:
          errorMessage = e.message ?? 'Error updating profile';
      }
      debugPrint("AuthCubit: Profile update error: $errorMessage");
      emit(ProfileUpdateErrorState(errorMessage));
    } catch (e) {
      debugPrint("AuthCubit: Profile update other error: $e");
      emit(ProfileUpdateErrorState(e.toString()));
    }
  }
}