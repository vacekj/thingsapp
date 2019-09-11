import 'package:flutter/material.dart';
class ThingsSpecialsMethods{



  static Widget thingsIcon(String path,{double height=25, double width}){
    return Image.asset(path, height: height,width: width,);
  }
}