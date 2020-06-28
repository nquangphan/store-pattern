import 'package:flutter/material.dart';
import 'dart:math';

class MyColors {
  static const Color pinkColor = Color(0xffe61c5a);
  static const Color organgeColor = Color(0xfff05f10);
  static const Color greenColor = Color(0xff00d44f);
  static const Color whiteColor = Color(0xffffffff);
  static const Color blackColor = Color.fromRGBO(21, 21, 21, 1.0);
  static const Color blueColor = Color.fromRGBO(14, 130, 240, 1.0);
  static const Color lightBlueColor = Color.fromRGBO(14, 130, 240, 0.2);

  static const Color yellowColor = Color(0xfff7b500);
  static const Color greyHighColor = Color(0xff303030);
  static const Color greyBoldColor = Color(0xff636363);
  static const Color greyLowColor = Color.fromRGBO(239, 240, 241, 1.0);
  static const Color greyHexThree11Color = Color(0xff111111);
  static const Color mainBgColor = Color.fromRGBO(26, 26, 29, 1.0);
  static const Color redColor = Color(0xffe02020);
  static const Color darkColor = Color(0xff151515);
  static const Color greyColor = Color(0xff878a9a);
  static const Color whiteOpacity = Color.fromRGBO(255, 255, 255, 0.45);

  static Random random = new Random();
  static Color randomColor() {
    return Color.fromARGB(255, 150 + random.nextInt(255 - 150),
        150 + random.nextInt(255 - 150), 150 + random.nextInt(255 - 150));
  }
}
