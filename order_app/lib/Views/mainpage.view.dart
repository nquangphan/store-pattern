import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart';

import './../Constants/theme.dart';
import './../Models/login.model.dart';
import './history.view.dart';
import './home.view.dart';
import './profile.view.dart';

class MainPage extends StatefulWidget {
  MainPage({key, this.mcontext, this.account}) : super(key: key);

  final BuildContext mcontext;
  final Account account;

  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _screenNumber = 0;
  String _screenName = 'Danh sách bàn';
  Account account;

  Drawer _buildDrawer(BuildContext context) {
    return new Drawer(
      child: new ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          new DrawerHeader(
              child: new Container(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    new Container(
                        width: 90.0,
                        height: 90.0,
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: account.image.isEmpty
                                    ? new AssetImage(
                                        'assets/images/account.png',
                                      )
                                    : new MemoryImage(
                                        account.image,
                                      )))),
                    new Text(
                      account.displayName,
                      overflow: TextOverflow.ellipsis,
                      style: new TextStyle(
                          color: accentColor,
                          fontFamily: 'Arial',
                          fontSize: 20.0),
                    ),
                  ],
                ),
              ),
              decoration: new BoxDecoration(color: primaryColor)),
          new ListTile(
            leading: new Icon(
              Icons.home,
              color: fontColorLight,
              size: 19.0,
            ),
            title: new Text(
              'Home',
              style: new TextStyle(
                  fontFamily: 'Arial', color: fontColor, fontSize: 16.0),
            ),
            onTap: () {
              setState(() {
                this._screenNumber = 0;
                this._screenName = 'Danh sách bàn';
              });
              Navigator.pop(context);
            },
          ),
          new ListTile(
            leading: new Icon(
              Icons.history,
              color: fontColorLight,
              size: 19.0,
            ),
            title: new Text(
              'Lịch sử',
              style: new TextStyle(
                  fontFamily: 'Arial', color: fontColor, fontSize: 16.0),
            ),
            onTap: () {
              setState(() {
                this._screenNumber = 1;
                this._screenName = 'Lịch sử';
              });
              Navigator.pop(context);
            },
          ),
          new ListTile(
            leading: new Icon(
              Icons.person,
              color: fontColorLight,
              size: 19.0,
            ),
            title: new Text(
              'Tài khoản',
              style: new TextStyle(
                  fontFamily: 'Arial', color: fontColor, fontSize: 16.0),
            ),
            onTap: () {
              setState(() {
                this._screenNumber = 2;
                this._screenName = 'Thông tin của tôi';
              });
              Navigator.pop(context);
            },
          ),
          new ListTile(
            leading: new Icon(
              Icons.exit_to_app,
              color: fontColorLight,
              size: 19.0,
            ),
            title: new Text(
              'Đăng xuất',
              style: new TextStyle(
                  fontFamily: 'Arial', color: fontColor, fontSize: 16.0),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(widget.mcontext);
            },
          ),
          new Divider(
            indent: 16.0,
          ),
          new ListTile(
            leading: new Icon(
              Icons.settings,
              color: fontColorLight,
              size: 19.0,
            ),
            title: new Text(
              'Cài đặt',
              style: new TextStyle(
                  fontFamily: 'Arial', color: fontColor, fontSize: 16.0),
            ),
            onTap: () {
              setState(() {
                this._screenNumber = 3;
                this._screenName = 'Cài đặt';
              });
              Navigator.pop(context);
            },
          ),
          new ListTile(
            leading: new Icon(
              Icons.info,
              color: fontColorLight,
              size: 19.0,
            ),
            title: new Text(
              'Thông tin',
              style: new TextStyle(
                  fontFamily: 'Arial', color: fontColor, fontSize: 16.0),
            ),
            onTap: () {
              setState(() {
                this._screenNumber = 4;
                this._screenName = 'Thông tin';
              });
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  Widget _buildScreen(BuildContext context) {
    switch (this._screenNumber) {
      case 0:
        return new HomeScreen(
          account: account,
        );
      case 1:
        return new HistoryScreen();
      case 2:
        return new ProfileScreen(
          account: account,
        );
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Account>(
      future: LoginModel.instance.login('test'),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          account = snapshot.data;
          return Container(
              child: new Scaffold(
                  appBar: new AppBar(
                    title: new Text(
                      _screenName,
                      style: new TextStyle(
                          color: accentColor, fontFamily: 'Arial'),
                    ),
                    iconTheme: new IconThemeData(color: accentColor),
                    centerTitle: true,
                    actions: <Widget>[
                      _screenNumber == 0
                          ? new IconButton(
                              icon: new Icon(Icons.refresh),
                              color: accentColor,
                              onPressed: () {
                                setState(() {});
                              },
                            )
                          : new IconButton(
                              icon: new Icon(Icons.refresh),
                              color: primaryColor,
                              onPressed: () {
                                setState(() {});
                              },
                            )
                    ],
                  ),
                  resizeToAvoidBottomPadding: false,
                  body: _buildScreen(context),
                  drawer: this._buildDrawer(context)));
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
