import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lingonerds/core/themes/app_themes.dart';
import 'package:lingonerds/view/widgets/elevated_button_custom.dart';
import 'package:lingonerds/view/widgets/progress_indicator_widget.dart';
import 'package:lingonerds/view/widgets/text_form_field_custom.dart';
import 'package:lingonerds/view_model/data/bloc/cubit/dictionary/dictionary_cubit.dart';
import '../../widgets/snackbar_custom.dart';
class DictionaryScreen extends StatelessWidget {
  const DictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => DictionaryCubit(),
  child: BlocConsumer<DictionaryCubit,DictionaryState>(
  listener: (context, state) {
    if(state is DictionaryDefinitionLoadingErrorState){
      var snack=SnackBarCustom.constructSnackBar(message: state.message, title: 'Error', num: 0);
      ScaffoldMessenger.of(context).showSnackBar(snack);
    }else if(state is PlayingAudioErrorState){
      var snack=SnackBarCustom.constructSnackBar(message: state.message, title: 'Error', num: 0);
      ScaffoldMessenger.of(context).showSnackBar(snack);
    }
  },
  builder: (context, state) {
    var cubit=DictionaryCubit.get(context);
    final currentWord = cubit.dictionaryController.text;
    final showDefinitions = cubit.lastDefinitions != null &&cubit.lastWord == currentWord && currentWord.isNotEmpty;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/images/scaffold.png'))
      ),
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(onPressed: (){
              cubit.refreshDefinitions();
            }, icon: Icon(FontAwesomeIcons.refresh,size: 30,color: AppThemes.blueAppColor,))
          ],
          backgroundColor: Colors.transparent,
          title: Text("Dictionary",style:AppThemes.lightTheme.textTheme.labelLarge,),
        ),
        body: Padding(
          padding:EdgeInsets.symmetric(horizontal:10.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: 50.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppThemes.yellowAppColor
                  ),
                    child: Center(child: Text('Here is Your Lingo Dictionary!',style:AppThemes.lightTheme.textTheme.labelLarge,))),
                SizedBox(height: 25.h,),
                TextFormFieldCustom(hintText: 'Enter Your Word',prefixIcon: Icon(FontAwesomeIcons.book,color: Colors.white,size: 15,),controller: cubit.dictionaryController,),
                SizedBox(height: 25.h,),
                ElevatedButtonCustom(
                  backgroundColor: Colors.blueGrey,
                  onPressed: (){
                    if (cubit.dictionaryController.text.isNotEmpty) {
                      cubit.fetchDefinitions(cubit.dictionaryController.text);
                    }
                    else{
                      var snack=SnackBarCustom.constructSnackBar(message: "Please Enter Your Word", title: 'Warning', num: 0);
                      ScaffoldMessenger.of(context).showSnackBar(snack);
                    }
                  },
                  buttonLabel: "Search",
                ),
                SizedBox(height: 25.h,),
                if(showDefinitions)
                SizedBox(
                  width: double.infinity,
                  height:400.h,
                  child: state is DictionaryDefinitionLoadingState?Center(child: ProgressIndicatorClass.constructProgressIndicator(),):Card(
                    color:Colors.white,child: Padding(
                      padding:EdgeInsets.symmetric(horizontal:8.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(child: Text('Definitions',style: AppThemes.lightTheme.textTheme.titleMedium,)),
                        SizedBox(height:10.h,),
                        Expanded(
                          child: ListView.builder(itemBuilder:(context,index){
                            return Padding(
                              padding:  EdgeInsets.symmetric(vertical: 8.h),
                              child: Text('${index+1}-${cubit.lastDefinitions![index]}',style: AppThemes.lightTheme.textTheme.titleMedium,),
                            );
                          },itemCount: cubit.lastDefinitions!.length,),
                        ),
                      ],
                                      ),
                    ),),
                ),
                SizedBox(height: 25.h,),
                if(showDefinitions)
                Container(
                  width: double.infinity,
                  height: 70.h,
                  decoration: BoxDecoration(
                    color: AppThemes.blueAppColor,
                    borderRadius: BorderRadius.circular(12)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                   Text(cubit.dictionaryController.text,style:GoogleFonts.anton(color: Colors.white,fontSize: 30),),
                   IconButton(onPressed: (){
                     cubit.playAudioForWord(word:currentWord);
                   }, icon:state is PlayingAudioLoadingState?ProgressIndicatorClass.constructProgressIndicator(size: 20):Icon(FontAwesomeIcons.play,color: Colors.white,size: 20,))
                  ],),
                )
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
