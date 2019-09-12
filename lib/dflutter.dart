import 'package:flutter/material.dart';
import 'dart:io';
class DFlutter{



  static Widget thingsIcon(String path,{double height=25, double width}){
    return Image.asset(path, height: height,width: width,);
  }
  static Widget thingListImage(
      {@required File image, double width = 50.0, double height = 50.0}) {
    return Container(
      width: width,
      height: height,
      decoration: new BoxDecoration(
          borderRadius: BorderRadius.circular(7.14),
          shape: BoxShape.rectangle,
          image: new DecorationImage(
              image: image == null
                  ? new AssetImage('assets/graphics/no-photo.png')
                  : new FileImage(image),
              fit: BoxFit.fill)),
    );
  }
}