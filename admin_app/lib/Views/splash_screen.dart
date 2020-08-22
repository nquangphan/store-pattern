import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:order_app/Views/mainPage.view.dart';

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
      Controller.instance.login('test', 'abc').then((value) {
        Navigator.of(context).push(
          new MaterialPageRoute(builder: (context) {
            return new MainPage(
              context: context,
              account: Controller.instance.account,
            );
          }),
        );
      });

      // Navigator.of(context).push(
      //   new MaterialPageRoute(builder: (context) {
      //     return LoginScreen();
      //   }),
      // );
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
