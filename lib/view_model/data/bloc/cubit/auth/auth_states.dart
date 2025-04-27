import 'package:lingonerds/model/user/user_model.dart' as my_user;

abstract class AuthStates {}

class AuthInitState extends AuthStates {}
class SignUpSuccessState extends AuthStates {}
class SignUpFirebaseAuthWeakPasswordErrorState extends AuthStates {}
class SignUpFirebaseAuthEmailAlreadyInUseErrorState extends AuthStates {}
class SignUpLoadingState extends AuthStates {}
class SignUpOtherErrorState extends AuthStates {}
class ShowOrHidePasswordSuccessState extends AuthStates {}
class ShowOrHideConfirmationPasswordSuccessState extends AuthStates {}
class ShowOrHideLoginPasswordSuccessState extends AuthStates {}
class LoginLoadingState extends AuthStates {}
class LoginSuccessState extends AuthStates {}
class LoginErrorState extends AuthStates {
  final String message;
  LoginErrorState(this.message);
}
class UserNotFoundErrorState extends AuthStates {}
class WrongPasswordErrorState extends AuthStates {}
class LoginOtherErrorState extends AuthStates {}
class SignOutLoadingState extends AuthStates {}
class SignOutSuccessState extends AuthStates {}
class FetchingUserDataLoadingErrorState extends AuthStates {
  final String message;
  FetchingUserDataLoadingErrorState({required this.message});
}
class FetchingUserDataLoadingState extends AuthStates {}
class FetchingUserDataLoadingSuccessState extends AuthStates {}
class LoadingUserDataState extends AuthStates {}
class UserDataLoadedState extends AuthStates {
  final my_user.User userData;
  UserDataLoadedState(this.userData);
}
class LoadingUserDataErrorState extends AuthStates {
  final String message;
  LoadingUserDataErrorState({required this.message});
}
class ProfileUpdatingState extends AuthStates {}
class ProfileUpdateSuccessState extends AuthStates {}
class ProfileUpdateErrorState extends AuthStates {
  final String error;
  ProfileUpdateErrorState(this.error);
}
class EmailVerificationRequiredState extends AuthStates {
  final String email;
  EmailVerificationRequiredState(this.email);
}