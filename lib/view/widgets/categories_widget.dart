import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lingonerds/model/category/category_model.dart';

import '../../core/themes/app_themes.dart';
class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget({super.key,
    this.categoryTitle,
    this.categoryImage,
    this.onPressed,
    this.categoryModel
  });
final String? categoryTitle;
final String? categoryImage;
final void Function()? onPressed;
final CategoryModel? categoryModel;
  @override
  Widget build(BuildContext context) {
    return  Container(
      width: 180.w,
      decoration: BoxDecoration(
        color: AppThemes.blueAppColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(categoryModel?.image??"",
              fit: BoxFit.cover,width: 132.w,),
            SizedBox(height: 20.h,),
            Expanded(
              child: TextButton(onPressed:onPressed, child: Text(categoryModel?.categoryTitle??"",style: GoogleFonts.anton(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20)
              )
              ),
            )
          ],
        ),
      ),
    );
  }
}
