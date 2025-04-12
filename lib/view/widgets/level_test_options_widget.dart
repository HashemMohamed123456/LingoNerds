import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class OptionsCard extends StatelessWidget {
  const OptionsCard({super.key,this.option,required this.color});
  final String? option;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: ListTile(
        title: Text(
          option??'',style: GoogleFonts.anton(color:Colors.white,fontSize: 22),textAlign: TextAlign.start,),
      ),
    );
  }
}