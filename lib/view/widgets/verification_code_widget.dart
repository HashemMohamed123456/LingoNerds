import 'package:flutter/material.dart';
import 'package:lingonerds/view/widgets/text_form_field_custom.dart';

import '../../core/themes/app_themes.dart';
class VerificationCodeWidget extends StatelessWidget {
  const VerificationCodeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        width: 50,
        height: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppThemes.blueAppColor,

        ),
        child: Center(
          child: TextFormFieldCustom(
            textAlign: TextAlign.center,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
          ),
        ),
      ),
    );
  }
}
