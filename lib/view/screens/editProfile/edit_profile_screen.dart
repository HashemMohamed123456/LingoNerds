import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/routes/routes.dart';
import '../../../core/themes/app_themes.dart';
import '../../../view_model/data/bloc/cubit/auth/auth_cubit.dart';
import '../../../view_model/data/bloc/cubit/auth/auth_states.dart';
import '../../widgets/elevated_button_custom.dart';
import '../../widgets/progress_indicator_widget.dart';
import '../../widgets/snackbar_custom.dart';
import '../../widgets/text_form_field_custom.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/images/scaffold.png')),
      ),
      child: BlocProvider(
        create: (context) => AuthCubit()..loadUserData(),
        child: BlocConsumer<AuthCubit, AuthStates>(
          listener: (context, state) {
            if (state is LoadingUserDataState) {
              Center(child: ProgressIndicatorClass.constructProgressIndicator());
            } else if (state is ProfileUpdateSuccessState) {
              var snack = SnackBarCustom.constructSnackBar(
                  message: "Profile Edited Successfully!", title: 'SUCCESS', num: 1);
              ScaffoldMessenger.of(context).showSnackBar(snack);
            } else if (state is ProfileUpdateErrorState) {
              var snack = SnackBarCustom.constructSnackBar(
                  message: 'Error Updating Profile', title: 'Error', num: 0);
              ScaffoldMessenger.of(context).showSnackBar(snack);
            }else if (state is ProfileUpdateErrorState) {
              var snack = SnackBarCustom.constructSnackBar(
                message: state.error.contains('requires-recent-login')
                    ? 'Session expired. Please log in again to update your email.'
                    : state.error,
                title: 'Error',
                num: 0,
              );
              ScaffoldMessenger.of(context).showSnackBar(snack);
            }
          },
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                title: Text(
                  'Edit Your Profile',
                  style: AppThemes.lightTheme.textTheme.labelLarge,
                ),
              ),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SingleChildScrollView(
                    child: Form(
                      key: AuthCubit.get(context).editingProfileFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20.h),
                          Text(
                            'What Do You Want to Change?',
                            style: AppThemes.lightTheme.textTheme.labelLarge,
                          ),
                          SizedBox(height: 36.h),
                          Text(
                            'Name',
                            style: AppThemes.lightTheme.textTheme.labelMedium,
                          ),
                          SizedBox(height: 11.h),
                          TextFormFieldCustom(
                            validator: (value) {
                              if ((value ?? '').isEmpty) {
                                return "Name Can't Be Empty!";
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                            controller: AuthCubit.get(context).changingNameController,
                            hintText: 'Please Enter Your Name',
                            prefixIcon: const Icon(
                              Icons.person_outline,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 9.h),
                          Text(
                            'Age',
                            style: AppThemes.lightTheme.textTheme.labelMedium,
                          ),
                          SizedBox(height: 11.h),
                          TextFormFieldCustom(
                            validator: (value) {
                              if ((value ?? '').isEmpty) {
                                return "Age Can't Be Empty!";
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                            controller: AuthCubit.get(context).changingAgeController,
                            hintText: 'Please Enter Your Age',
                            prefixIcon: const Icon(
                              FontAwesomeIcons.calendarWeek,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 9.h),
                          Text(
                            'Email',
                            style: AppThemes.lightTheme.textTheme.labelMedium,
                          ),
                          SizedBox(height: 11.h),
                          TextFormFieldCustom(
                            readOnly: true,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if ((value ?? "").isEmpty) {
                                return 'You must Enter Your Email';
                              } else if (!RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value ?? '')) {
                                return "Invalid Email";
                              }
                              return null;
                            },
                            controller: AuthCubit.get(context).changingEmailController,
                            hintText: 'Please Enter Your Email',
                            prefixIcon: const Icon(
                              Icons.mail_outline,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 9.h),
                          Text(
                            'Current Password (for change)',
                            style: AppThemes.lightTheme.textTheme.labelMedium,
                          ),
                          SizedBox(height: 11.h),
                          TextFormFieldCustom(
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if ((value ?? "").isEmpty &&
                                  AuthCubit.get(context)
                                      .changingEmailController
                                      .text !=
                                      AuthCubit.get(context).userData?.email) {
                                return 'Password is required for change ';
                              }
                              return null;
                            },
                            controller:
                            AuthCubit.get(context).currentPasswordController,
                            hintText: 'Enter Current Password',
                            obscureText: true,
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 9.h),
                          Text(
                            'Birth Date',
                            style: AppThemes.lightTheme.textTheme.labelMedium,
                          ),
                          SizedBox(height: 11.h),
                          TextFormFieldCustom(
                            textInputAction: TextInputAction.done,
                            validator: (value) {
                              if ((value ?? '').isEmpty) {
                                return "Birthdate Can't Be Empty!";
                              }
                              return null;
                            },
                            readOnly: true,
                            controller:
                            AuthCubit.get(context).changingBirthDateController,
                            onTap: () {
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              ).then((value) {
                                if (value != null) {
                                  AuthCubit.get(context)
                                      .changingBirthDateController
                                      .text = DateFormat('yyyy/MM/dd').format(value);
                                }
                              });
                            },
                            hintText: 'Please Enter Your Birthdate',
                            prefixIcon: const Icon(
                              Icons.calendar_month_outlined,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 50.h),
                          Center(
                            child: state is ProfileUpdatingState
                                ? ProgressIndicatorClass.constructProgressIndicator()
                                : ElevatedButtonCustom(
                              onPressed: () {
                                if (AuthCubit.get(context)
                                    .editingProfileFormKey
                                    .currentState!
                                    .validate()) {
                                  AuthCubit.get(context)
                                      .updateUserProfile(
                                    name: AuthCubit.get(context)
                                        .changingNameController
                                        .text,
                                    age: AuthCubit.get(context)
                                        .changingAgeController
                                        .text,
                                    email: AuthCubit.get(context)
                                        .changingEmailController
                                        .text,
                                    birthDate: AuthCubit.get(context)
                                        .changingBirthDateController
                                        .text,
                                    currentPassword:
                                    AuthCubit.get(context)
                                        .currentPasswordController
                                        .text,
                                  ).then((_) {
                                    Navigator.pop(context, true);
                                  }).catchError((e) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBarCustom.constructSnackBar(
                                        message: e.toString(),
                                        title: 'Error',
                                        num: 0,
                                      ),
                                    );
                                  });
                                }
                              },
                              buttonLabel: 'Edit',
                            ),
                          ),
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