import 'package:flutter/material.dart';
import 'package:order_app/Views/splash_screen.dart';

import './Constants/theme.dart';
import 'Views/mainpage.view.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Order App',
      theme: new ThemeData(
        brightness: Brightness.light,
        primaryColor: primaryColor,
        accentColor: accentColor,
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(
        mContext: context,
      ),
    );
  }
}
