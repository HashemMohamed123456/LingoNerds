import 'package:flutter/material.dart';
import 'package:lingonerds/core/themes/app_themes.dart';
class ConversationSimulationScreen extends StatelessWidget {
  const ConversationSimulationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/images/scaffold.png'))
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text("Conversation Simulation",style: AppThemes.lightTheme.textTheme.labelLarge,),
        ),
      ),
    );
  }
}
