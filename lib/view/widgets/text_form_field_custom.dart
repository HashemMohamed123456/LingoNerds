import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/themes/app_themes.dart';

class TextFormFieldCustom extends StatelessWidget {
   TextEditingController? controller;
   String? labelText;
   String? Function(String?)? validator;
   void Function(String)? onChanged;
   String? hintText;
   void Function()? onTap;
   Color? fillColor;
   Widget? prefixIcon;
   Color borderColor;
   FocusNode? focusNode;
   TextAlign textAlign;
   int? maxLength;
   TextInputType? keyboardType;
   TextInputAction? textInputAction;
   bool readOnly;
   bool obscureText;
   Widget? suffixIcon;
   TextFormFieldCustom({super.key,
    this.controller,
    this.labelText,
    this.validator,
    this.onChanged,
    this.hintText,
    this.onTap,
    this.fillColor=AppThemes.blueAppColor,
    this.prefixIcon,
    this.borderColor=Colors.transparent,
    this.focusNode,
     this.textAlign=TextAlign.start,
     this.maxLength,
     this.keyboardType,
     this.textInputAction,
     this.readOnly=false,
     this.obscureText=false,
     this.suffixIcon
  });
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly:readOnly,
      obscureText:obscureText,
      textInputAction:textInputAction ,
      keyboardType:keyboardType ,
      maxLength: maxLength,
      style: GoogleFonts.poppins(
        color: Colors.white,
        fontSize: 15
      ),
      textAlign: textAlign,
      focusNode:focusNode ,
        cursorColor: Colors.white,
        cursorErrorColor: AppThemes.textFormFieldErrorBorderColor,
        validator:validator,
        onChanged:onChanged,
        controller: controller,
        onTap: onTap,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          fillColor:fillColor,
          filled:true,
          border: OutlineInputBorder(
            borderRadius:BorderRadius.circular(10),
            borderSide: BorderSide(
              color:borderColor
            )
          ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppThemes.blueAppColor
              ),
            ),
            focusedBorder:OutlineInputBorder(
              borderSide: BorderSide(
                  color: AppThemes.blueAppColor
              ),
            ),
            errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                    color: AppThemes.textFormFieldErrorBorderColor
                )
            ),
            hintText: hintText,
            hintStyle: AppThemes.lightTheme.textTheme.labelSmall,
            labelText: labelText,
            labelStyle: AppThemes.lightTheme.textTheme.labelSmall
        ));
  }
}