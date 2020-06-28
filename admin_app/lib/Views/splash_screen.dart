import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Controllers/login.controller.dart';
import 'login.view.dart';

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
    Controller.instance.getServerIp(onLoadSuccess: () {
      Navigator.of(context).push(
        new MaterialPageRoute(builder: (context) {
          return LoginScreen();
        }),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(14, 130, 240, 0.2),
      child: Center(
        child: Image.asset(
          'assets/images/app_logo.png',
          width: MediaQuery.of(context).size.width * (0.6),
          height: MediaQuery.of(context).size.height * (0.6),
        ),
      ),
    );
  }
}
