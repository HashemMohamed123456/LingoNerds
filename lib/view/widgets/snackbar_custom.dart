import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
class SnackBarCustom{
  static SnackBar constructSnackBar({required String message,required String title,required int num}){
    return SnackBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
            title:title,
            message:message,
            contentType:num==0?
            ContentType.failure:
            num==1?ContentType.success:
            ContentType.warning
        ));
  }
}