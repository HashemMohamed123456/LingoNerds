import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lingonerds/core/firebase/firebase_auth_codes.dart';
import 'package:lingonerds/core/firebase/firestore_handler.dart';
import 'package:lingonerds/model/user/user_model.dart' as my_user;
import 'package:lingonerds/view_model/data/bloc/cubit/auth/auth_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../local/local_data.dart';
class AuthCubit extends Cubit<AuthStates>{
  AuthCubit() : super(AuthInitState());
  static AuthCubit get(context)=>BlocProvider.of<AuthCubit>(context);
  TextEditingController signUpNameController=TextEditingController();
  TextEditingController ageController=TextEditingController();
  TextEditingController signUpEmailController=TextEditingController();
  TextEditingController signUpPasswordController=TextEditingController();
  TextEditingController signUpConfirmationPasswordController=TextEditingController();
  TextEditingController signUpBirthDateController=TextEditingController();
  TextEditingController loginEmailController=TextEditingController();
  TextEditingController loginPasswordController=TextEditingController();
  GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  bool showPassword=false;
  bool obscureText=true;
  bool showConfirmationPassword=false;
  bool obscureConfirmationText=true;
  bool showLoginPassword=false;
  bool obscureLoginText=true;
  void hidePassword(){
    showPassword=!showPassword;
    obscureText=!obscureText;
    emit(ShowOrHidePasswordSuccessState());
  }
  void hideLoginPassword(){
    showLoginPassword=!showLoginPassword;
    obscureLoginText=!obscureLoginText;
    emit(ShowOrHideLoginPasswordSuccessState());
  }
  void hideConfirmationPassword(){
    showConfirmationPassword=!showConfirmationPassword;
    obscureConfirmationText=!obscureConfirmationText;
    emit(ShowOrHideConfirmationPasswordSuccessState());
  }
signUp()async{
    emit(SignUpLoadingState());
  try {
    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: signUpEmailController.text,
      password:signUpPasswordController.text,
    );
    await FireStoreHandler.createUser(my_user.User(
      id:credential.user!.uid,
      name: signUpNameController.text,
      age: int.parse(ageController.text),
      birthDate:signUpBirthDateController.text,
      email: signUpEmailController.text
    ));
    emit(SignUpSuccessState());
  } on FirebaseAuthException catch (e) {
    if (e.code == FirebaseAuthCodes.weakPassword) {
      print('The password provided is too weak.');
      emit(SignUpFirebaseAuthWeakPasswordErrorState());
    } else if (e.code == FirebaseAuthCodes.emailAlreadyInUse) {
      print('The account already exists for that email.');
      emit(SignUpFirebaseAuthEmailAlreadyInUseErrorState());
    }
  } catch (e) {
    print(e);
    emit(SignUpOtherErrorState());
  }
}
Future<void>login()async{
    emit(LoginLoadingState());
    try {
      final userCredential=await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: loginEmailController.text,
          password:loginPasswordController.text);
      print(userCredential.user!.uid);
      // Store login state in SharedPreferences
      LocalData.set(key: "isLoggedIn", value: true);
      LocalData.set(key: "userId", value: userCredential.user!.uid);
      emit(LoginSuccessState());
    }on FirebaseAuthException catch(e){
      if (e.code == FirebaseAuthCodes.userNotFound) {
        emit(UserNotFoundErrorState());
      } else if (e.code ==FirebaseAuthCodes.wrongPassword) {
        emit(WrongPasswordErrorState());
      }
    }catch(error){
      print(error);
      emit(LoginOtherErrorState());
    }
}
signOut()async{
    emit(SignOutLoadingState());
    await FirebaseAuth.instance.signOut();
    LocalData.set(key:"isLoggedIn", value:false);
    LocalData.removeData(key:"userId");
    emit(SignOutSuccessState());
}
}