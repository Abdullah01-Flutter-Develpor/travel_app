import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class appTextstyle{

  static TextStyle normalText ({double fontSize = 18,FontWeight fontWeight = FontWeight.normal,Color Colors = Colors.black}){
    return GoogleFonts.outfit(fontSize: fontSize,fontWeight: fontWeight,color: Colors,);

  }

}

