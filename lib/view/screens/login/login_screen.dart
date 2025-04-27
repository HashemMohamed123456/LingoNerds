import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lingonerds/core/firebase/firestore_handler.dart';
import 'package:lingonerds/core/routes/routes.dart';
import 'package:lingonerds/core/themes/app_themes.dart';
import 'package:lingonerds/view/widgets/elevated_button_custom.dart';
import 'package:lingonerds/view/widgets/remember_me_widget.dart';
import 'package:lingonerds/view/widgets/text_form_field_custom.dart';
import 'package:lingonerds/view_model/data/bloc/cubit/auth/auth_cubit.dart';
import 'package:lingonerds/view_model/data/bloc/cubit/auth/auth_states.dart';
import '../../widgets/progress_indicator_widget.dart';
import '../../widgets/snackbar_custom.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/images/scaffold.png')),
      ),
      child: BlocConsumer<AuthCubit, AuthStates>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
            var snack = SnackBarCustom.constructSnackBar(
              message: "You're Signed In Successfully!",
              title: 'SUCCESS',
              num: 1,
            );
            ScaffoldMessenger.of(context).showSnackBar(snack);
            FireStoreHandler.checkLanguageLevelAndNavigate(
              context,
              FirebaseAuth.instance.currentUser!.uid,
            );
          } else if (state is UserNotFoundErrorState) {
            var snackBar = SnackBarCustom.constructSnackBar(
              message: "This User isn't found!",
              title: 'Invalid Email',
              num: 0,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else if (state is WrongPasswordErrorState) {
            var snackBar = SnackBarCustom.constructSnackBar(
              message: 'Wrong Password!',
              title: 'Invalid Password',
              num: 0,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else if (state is EmailVerificationRequiredState) {
            var snackBar = SnackBarCustom.constructSnackBar(
              message:
              'A verification email has been sent to ${state.email}. Please verify your email.',
              title: 'Verification Required',
              num: 0,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else if (state is LoginErrorState) {
            var snackBar = SnackBarCustom.constructSnackBar(
              message: state.message,
              title: 'Error',
              num: 0,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Form(
                key: AuthCubit.get(context).loginFormKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.0.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 80, right: 71, top: 99),
                        child: Image.asset(
                          'assets/images/app_logo.png',
                          height: 281.h,
                          width: 261.w,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        'Welcome Back!',
                        style: AppThemes.lightTheme.textTheme.titleLarge,
                      ),
                      SizedBox(height: 55.h),
                      SizedBox(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: TextFormFieldCustom(
                            controller: AuthCubit.get(context).loginEmailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please Enter Your Email";
                              }
                              return null;
                            },
                            hintText: 'Username',
                            prefixIcon: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.person_outline),
                              color: Colors.white,
                            ),
                            onTap: () {},
                          ),
                        ),
                      ),
                      SizedBox(height: 18.h),
                      SizedBox(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8).r,
                          child: TextFormFieldCustom(
                            controller: AuthCubit.get(context).loginPasswordController,
                            suffixIcon: InkWell(
                              onTap: () {
                                AuthCubit.get(context).hideLoginPassword();
                              },
                              child: Icon(
                                AuthCubit.get(context).showLoginPassword
                                    ? FontAwesomeIcons.eyeSlash
                                    : FontAwesomeIcons.eye,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            obscureText: AuthCubit.get(context).obscureLoginText,
                            hintText: 'Password',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please Enter Your Password";
                              }
                              return null;
                            },
                            prefixIcon: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.lock_outline,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15.h),
                      SizedBox(
                        width: 364.w,
                        child: Row(
                          children: [
                            RememberMeWidget(),
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  ScreensRoutes.forgetPasswordScreenRoute,
                                );
                              },
                              child: Text(
                                'Forget Password?',
                                style: AppThemes.lightTheme.textTheme.titleMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15.h),
                      state is LoginLoadingState
                          ? ProgressIndicatorClass.constructProgressIndicator()
                          : ElevatedButtonCustom(
                        onPressed: () {
                          if (AuthCubit.get(context)
                              .loginFormKey
                              .currentState!
                              .validate()) {
                            AuthCubit.get(context).login();
                          }
                        },
                        buttonLabel: 'Login',
                      ),
                      if (state is EmailVerificationRequiredState) ...[
                        SizedBox(height: 10.h),
                        TextButton(
                          onPressed: () {
                            AuthCubit.get(context).resendVerificationEmail();
                          },
                          child: Text(
                            'Resend Verification Email',
                            style: AppThemes.lightTheme.textTheme.titleMedium,
                          ),
                        ),
                      ],
                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't Have An Account?",
                            style: AppThemes.lightTheme.textTheme.titleMedium,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                ScreensRoutes.signUpScreenRoute,
                              );
                            },
                            child: Text(
                              'Sign Up',
                              style: GoogleFonts.anton(
                                decoration: TextDecoration.underline,
                                decorationColor: AppThemes.blueAppColor,
                                fontSize: 20,
                                color: AppThemes.blueAppColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}