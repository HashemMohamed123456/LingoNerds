import 'package:flutter/material.dart';
import 'package:lingonerds/core/themes/app_themes.dart';
class RememberMeWidget extends StatefulWidget {
  const RememberMeWidget({
    super.key,
  });
  @override
  State<RememberMeWidget> createState() => _RememberMeWidgetState();
}
class _RememberMeWidgetState extends State<RememberMeWidget> {
  bool? isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
            side: BorderSide(color:AppThemes.blueAppColor),
            value: isChecked,
            activeColor: AppThemes.blueAppColor,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onChanged: (newValue) {
              isChecked = newValue;
              setState(() {});
            }),
        Text(
          'Remember me',
          style:AppThemes.lightTheme.textTheme.labelMedium,
        )
      ],
    );
  }
}