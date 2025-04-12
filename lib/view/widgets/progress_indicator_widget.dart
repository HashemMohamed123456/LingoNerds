import 'package:flutter/cupertino.dart';
import 'package:lingonerds/core/themes/app_themes.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ProgressIndicatorClass{
  static Center constructProgressIndicator({double size=50}){
    return Center(
      child: LoadingAnimationWidget.flickr(leftDotColor: AppThemes.blueAppColor, rightDotColor:AppThemes.yellowAppColor, size: size),
    );
  }
}
