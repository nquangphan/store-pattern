import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:order_app/Controllers/home.controller.dart';
import 'package:order_app/Utils/utils.dart';
import 'package:order_app/Views/mainpage.view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key, this.mContext}) : super(key: key);
  final mContext;

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      Controller.instance.getServerIp(onLoadSuccess: () {
        Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) {
            return MainPage(
              mcontext: widget.mContext,
            );
          }),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Dimension.height = MediaQuery.of(context).size.height;
    Dimension.width = MediaQuery.of(context).size.width;
    return Container(
      color: Color.fromRGBO(14, 130, 240, 0.2),
      child: Center(
        child: Image.asset(
          'assets/images/app_logo.png',
          width: Dimension.getWidth(0.6),
          height: Dimension.getWidth(0.6),
        ),
      ),
    );
  }
}
