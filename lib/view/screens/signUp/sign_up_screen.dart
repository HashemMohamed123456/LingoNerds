import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lingonerds/core/routes/routes.dart';
import 'package:lingonerds/core/themes/app_themes.dart';
import 'package:lingonerds/view/widgets/elevated_button_custom.dart';
import 'package:lingonerds/view/widgets/text_form_field_custom.dart';
import 'package:lingonerds/view_model/data/bloc/cubit/auth/auth_cubit.dart';
import 'package:lingonerds/view_model/data/bloc/cubit/auth/auth_states.dart';

import '../../widgets/progress_indicator_widget.dart';
import '../../widgets/snackbar_custom.dart';
class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/images/scaffold.png'))
      ),
      child: BlocProvider(
  create: (context) => AuthCubit(),
  child: BlocConsumer<AuthCubit,AuthStates>(
  listener: (context, state) {
    if(state is SignUpSuccessState){
      var snack=SnackBarCustom.constructSnackBar(message: "You're Signed Up Successfully ! ", title: 'SUCCESS', num: 1);
      ScaffoldMessenger.of(context).showSnackBar(snack);
      Navigator.pushNamedAndRemoveUntil(context,ScreensRoutes.onboardingScreenRoute,(route)=>false);
    }else if(state is SignUpFirebaseAuthEmailAlreadyInUseErrorState){
      var snackBar=SnackBarCustom.constructSnackBar(message: 'This Email is already in use', title:'Invalid Email', num: 0);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }else if(state is SignUpFirebaseAuthWeakPasswordErrorState){
      var snackBar=SnackBarCustom.constructSnackBar(message:'Weak Password', title:'Invalid Password', num:0);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  },
  builder: (context, state) {
    return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              child: Form(
                key: AuthCubit.get(context).signUpFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Create Your Account',style: AppThemes.lightTheme.textTheme.labelLarge,),
                    SizedBox(height:36.h,),
                    Text('Name',style: AppThemes.lightTheme.textTheme.labelMedium,),
                    SizedBox(height: 11.h,),
                    TextFormFieldCustom(
                      validator: (value){
                        if((value??'').isEmpty){
                          return "Name Can't Be Empty !";
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      controller: AuthCubit.get(context).signUpNameController,
                      hintText: 'Please Enter Your Name',
                      prefixIcon: Icon(Icons.person_outline,color: Colors.white,),
                    ),
                    SizedBox(height: 9.h,),
                    Text('Age',style: AppThemes.lightTheme.textTheme.labelMedium,),
                    SizedBox(height: 11.h,),
                    TextFormFieldCustom(
                      validator: (value){
                        if((value??'').isEmpty){
                          return "Age Can't Be Empty !";
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      controller: AuthCubit.get(context).ageController,
                      hintText: 'Please Enter Your Age',
                      prefixIcon: Icon(FontAwesomeIcons.calendarWeek,color: Colors.white,),
                    ),  SizedBox(height: 9.h,),
                    Text('Email',style: AppThemes.lightTheme.textTheme.labelMedium,),
                    SizedBox(height: 11.h,),
                    TextFormFieldCustom(
                      textInputAction: TextInputAction.next,
                        validator: (value){
                          if((value??"").isEmpty){
                            return 'You must Enter Your Email';
                          }else if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value??'')){
                            return "invalid Email";
                          }
                          return null;
                        },
                      controller:AuthCubit.get(context).signUpEmailController,
                      hintText: 'Please Enter Your Email',
                      prefixIcon: Icon(Icons.mail_outline,color: Colors.white,),
                    ),  SizedBox(height: 9.h,),
                    Text('Password',style: AppThemes.lightTheme.textTheme.labelMedium,),
                    SizedBox(height: 11.h,),
                    TextFormFieldCustom(
                      textInputAction: TextInputAction.next,
                      obscureText: AuthCubit.get(context).obscureText,
                      suffixIcon: InkWell(
                          onTap: (){
                            AuthCubit.get(context).hidePassword();
                          },
                          child: Icon(AuthCubit.get(context).showPassword?FontAwesomeIcons.eyeSlash:FontAwesomeIcons.eye,color: Colors.white,size: 20,)),
                        validator: (value){
                          if((value??"").isEmpty){
                            return 'You must Enter Your Password';
                          }else if(!RegExp(r'(?=.*[a-z])').hasMatch(value??'')){
                            return 'Password needs at least one lower case letter';
                          }else if(!RegExp(r'(?=.*[A-Z])' ).hasMatch(value??'')){
                            return 'Password needs at least one upper case letter';
                          }else if(!RegExp(r'(?=.*?[0-9])').hasMatch(value??"")){
                            return'Password needs at least one digit';
                          }else if(!RegExp(r'(?=.?[!@#\$&~])').hasMatch(value??'')){
                            return'Password needs at least one special character ';
                          }else if(!RegExp(r'.{6,}').hasMatch(value??'')){
                            return 'Password length at least Six characters';
                          }
                          return null;
                        },
                      controller: AuthCubit.get(context).signUpPasswordController,
                      hintText: 'Please Enter Your Password',
                      prefixIcon: Icon(Icons.lock_outline,color: Colors.white,),
                    ),  SizedBox(height: 9.h,),
                    Text('Confirm Password',style: AppThemes.lightTheme.textTheme.labelMedium,),
                    SizedBox(height: 11.h,),
                    TextFormFieldCustom(
                      obscureText: AuthCubit.get(context).obscureConfirmationText,
                        suffixIcon: InkWell(
                            onTap: (){
                              AuthCubit.get(context).hideConfirmationPassword();
                            },
                            child: Icon(AuthCubit.get(context).showConfirmationPassword?FontAwesomeIcons.eyeSlash:FontAwesomeIcons.eye,color: Colors.white,size: 20,)),
                      validator: (value){
                        if((value??'').isEmpty){
                          return 'Please Enter Your Confirmation Password !';
                        }else if(value != AuthCubit.get(context).signUpPasswordController.text){
                          return "It Doesn't Match !";
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      controller: AuthCubit.get(context).signUpConfirmationPasswordController,
                      hintText: 'Confirmation Password',
                      prefixIcon: Icon(Icons.check_box,color: Colors.white,),
                    ),  SizedBox(height: 9.h,),
                    Text('Date',style: AppThemes.lightTheme.textTheme.labelMedium,),
                    SizedBox(height: 11.h,),
                    TextFormFieldCustom(
                      textInputAction: TextInputAction.done,
                      validator: (value){
                        if((value??'').isEmpty){
                          return "Birthdate Can't Be Empty !";
                        }
                        return null;
                      },
                      readOnly: true,
                      controller: AuthCubit.get(context).signUpBirthDateController,
                      onTap: (){
                        showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2002,5,1), lastDate: DateTime.now().add(const Duration(days: 365*5)
                        )
                        ).then((value){
                          if(value!=null){
                            AuthCubit.get(context).signUpBirthDateController.text=DateFormat('yyyy/MM/dd').format(value);
                          }
                        });

                      },
                      hintText: 'Please Enter Your Birthdate',
                      prefixIcon: Icon(Icons.calendar_month_outlined,color: Colors.white,),
                    ),  SizedBox(height: 17.h,),
                    Center(
                      child: State is SignUpLoadingState?ProgressIndicatorClass.constructProgressIndicator():ElevatedButtonCustom(
                        onPressed: (){
                          if(AuthCubit.get(context).signUpFormKey.currentState!.validate()){
                            AuthCubit.get(context).signUp();
                          }
                        },
                        buttonLabel: 'Sign Up',
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Have An Account?",style: AppThemes.lightTheme.textTheme.titleMedium,),
                        TextButton(onPressed:(){
                          Navigator.pushNamed(context,ScreensRoutes.loginScreenRoute);
                        }, child:Text('Login',style: GoogleFonts.anton(
                          decoration: TextDecoration.underline,
                          decorationColor:AppThemes.blueAppColor,
                          fontSize: 20,
                          color: AppThemes.blueAppColor,
                        ),))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
  },
),
),
    );
  }
}
