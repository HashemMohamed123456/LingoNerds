import 'package:flutter/material.dart';
import 'package:lingonerds/core/themes/app_themes.dart';
class GrammarTestsScreen extends StatelessWidget {
  const GrammarTestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/images/scaffold.png'))
      ),
      child: Scaffold(appBar: AppBar(
        backgroundColor: Colors.transparent,
        title:Text('Grammar Tests',style: AppThemes.lightTheme.textTheme.labelLarge,),
      ),),
    );
  }
}
