abstract class  AuthStates{}
class AuthInitState extends AuthStates{}
class SignUpSuccessState extends AuthStates{}
class SignUpFirebaseAuthWeakPasswordErrorState extends AuthStates{}
class SignUpFirebaseAuthEmailAlreadyInUseErrorState extends AuthStates{}
class SignUpLoadingState extends AuthStates{}
class SignUpOtherErrorState extends AuthStates{}
class ShowOrHidePasswordSuccessState extends AuthStates{}
class ShowOrHideConfirmationPasswordSuccessState extends AuthStates{}
class ShowOrHideLoginPasswordSuccessState extends AuthStates{}
class LoginLoadingState extends AuthStates{}
class LoginSuccessState extends AuthStates{}
class LoginErrorState extends AuthStates{}
class UserNotFoundErrorState extends AuthStates{}
class WrongPasswordErrorState extends AuthStates{}
class LoginOtherErrorState extends AuthStates{}
class SignOutLoadingState extends AuthStates{}
class SignOutSuccessState extends AuthStates{}