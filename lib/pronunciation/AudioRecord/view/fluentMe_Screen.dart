import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'fluentMe_screen_body.dart';
class FluentMeScreen extends StatelessWidget {

  final String postId ;
  const FluentMeScreen({super.key,required this.postId});

  @override
  Widget build(BuildContext context) {
  return FluentMeScreenBody(postId:postId);
  }
}