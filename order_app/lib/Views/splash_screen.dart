import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:order_app/Controllers/home.controller.dart';
import 'package:order_app/Controllers/menu.controller.dart' as Menu;
import 'package:order_app/Utils/utils.dart';
import 'package:order_app/Views/mainpage.view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key, this.mContext}) : super(key: key);
  final mContext;

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String message = '';
  @override
  void initState() {
    super.initState();
    message = 'Getting server IP';
    Controller.instance.getServerIp(onLoadSuccess: () {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        setState(() {
          message = 'Fetching list food';
        });
      });
      Menu.Controller.instance.foods().then((value) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(
            builder: (context) {
              return WillPopScope(
                onWillPop: () async {
                  await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: new Text('Thông báo'),
                          content: new Text('Bạn có chắc chắn muốn thoát'),
                          actions: <Widget>[
                            new FlatButton(
                              child: new Text('Ok'),
                              onPressed: () {
                                SystemNavigator.pop();
                              },
                            ),
                            new FlatButton(
                              child: new Text('Hủy'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        );
                      });
                  return false;
                },
                child: MainPage(
                  mcontext: widget.mContext,
                ),
              );
            },
          ), (a) => false);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Dimension.height = MediaQuery.of(context).size.height;
    Dimension.width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromRGBO(14, 130, 240, 0.2),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/app_logo.png',
                  width: Dimension.getWidth(0.6),
                  height: Dimension.getWidth(0.6),
                ),
              ),
              Text(
                message,
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
