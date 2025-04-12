import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lingonerds/core/routes/routes.dart';
import 'package:lingonerds/core/themes/app_themes.dart';
import 'package:lingonerds/model/category/category_model.dart';
import 'package:lingonerds/view/widgets/categories_widget.dart';
import 'package:lingonerds/view_model/data/bloc/cubit/auth/auth_cubit.dart';
import 'package:lingonerds/view_model/data/bloc/cubit/auth/auth_states.dart';

import '../../../core/firebase/firestore_handler.dart';
import '../../widgets/snackbar_custom.dart';
class HomeScreen extends StatelessWidget {
  List<CategoryModel>categoriesList=[
    CategoryModel(
      image: 'assets/icons/chalkboard.png',
      categoryTitle: 'Quizzes'
    ),
    CategoryModel(
      image: 'assets/icons/dictionary.png',
      categoryTitle: 'Dictionary'
    ),
    CategoryModel(
      image: 'assets/icons/speaking.png',
      categoryTitle: 'Conversation'
    ),
    CategoryModel(
      image: 'assets/icons/word-of-mouth.png',
      categoryTitle: 'Pronunciation'
    ),
  ];
  void handleMenuSelection(String value, BuildContext context) {
    switch (value) {
      case 'Settings':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Settings selected')),
        );
        break;
      case 'Profile':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile selected')),
        );
        break;
      case 'Logout':

        break;
    }
  }
    HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(
          'assets/images/scaffold.png'
        ))
      ),
      child: BlocProvider(
  create: (context) => AuthCubit(),
  child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            BlocConsumer<AuthCubit,AuthStates>(
  listener: (context, state) {
    if(state is SignOutSuccessState){
      var snack=SnackBarCustom.constructSnackBar(message: "You're Signed Out Successfully ! ", title: 'SUCCESS', num: 1);
      ScaffoldMessenger.of(context).showSnackBar(snack);
      Navigator.pushNamedAndRemoveUntil(context,ScreensRoutes.loginScreenRoute,(route)=>false);
    }
  },
  builder: (context, state) {
    return PopupMenuButton<String>(
              icon: Icon(Icons.menu,color: AppThemes.blueAppColor,),
                color: AppThemes.blueAppColor, // Background color of the popup
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), // Rounded corners
                ),
                onSelected: (value)=>handleMenuSelection(
                value,
                context),itemBuilder:(context){
              return [
                PopupMenuItem(
                  value: "Settings",
                  child: Text("Settings",style: AppThemes.lightTheme.textTheme.labelSmall,),
                ),
                PopupMenuItem(
                  value: "Profile",
                  child: Text("Profile",style: AppThemes.lightTheme.textTheme.labelSmall,),
                ),
                PopupMenuItem(
                  value: "Logout",
                  child: InkWell(child: Text("Logout",style:AppThemes.lightTheme.textTheme.labelSmall,),onTap: (){
                    AuthCubit.get(context).signOut();
                  },),
                ),
              ];
            });
  },
)
          ],
        ),
      body:Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Center(
          child: Column(
            children: [
              Text('Ready To Learn !?',style: AppThemes.lightTheme.textTheme.labelLarge,),
              SizedBox(height: 20.h,),
              Expanded(
                child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,),itemCount: categoriesList.length,itemBuilder:(context,index){
                  return CategoriesWidget(
                    onPressed: (){
                      if(categoriesList[index].categoryTitle=="Quizzes"){
                        Navigator.pushNamed(context, ScreensRoutes.vocabularyTestsScreenRoute);
                      }else if(categoriesList[index].categoryTitle=="Dictionary"){
                        Navigator.pushNamed(context, ScreensRoutes.dictionaryScreenRoute);
                      }else if(categoriesList[index].categoryTitle=="Conversation"){
                        Navigator.pushNamed(context,ScreensRoutes.conversationScreenRoute);
                      }else{
                        Navigator.pushNamed(context,ScreensRoutes.pronunciationTestScreen);
                      }
                    },
                    categoryImage: categoriesList[index].image,categoryTitle: categoriesList[index].categoryTitle,categoryModel:categoriesList[index],);
                }),
              )
            ],
          ),
        ),
      ) 
    
    ,),
),
    );
  }
}
