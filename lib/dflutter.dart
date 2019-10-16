import 'package:flutter/material.dart';
import 'dart:io';

class DFlutter {
  static Widget thingsIcon(String path, {double height = 25, double width}) {
    return Image.asset(
      path,
      height: height,
      width: width,
    );
  }

  static Widget thingsListImage(
      {@required File image,
      double width = 50.0,
      double height = 50.0,
      String noImagePath}) {
    return Container(
      width: width,
      height: height,
      decoration: new BoxDecoration(
          borderRadius: BorderRadius.circular(7.14),
          shape: BoxShape.rectangle,
          image: new DecorationImage(
              image: image == null
                  ? noImagePath == null
                      ? new AssetImage('assets/graphics/no-photo.png')
                      : new AssetImage(noImagePath)
                  : new FileImage(image),
              fit: BoxFit.fill)),
    );
  }
}
