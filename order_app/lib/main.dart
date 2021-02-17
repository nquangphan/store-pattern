import 'package:flutter/material.dart';
import 'package:order_app/Views/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './Constants/theme.dart';
import 'Constants/queries.dart';
import 'Utils/utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initApp().then((value) => runApp(new MyApp()));
}

Future<void> initApp() async {
  Application.prefs = await SharedPreferences.getInstance();
  try {
    if (Application.prefs.getInt(BONUS_PRICE) == null)
      Application.prefs.setInt(BONUS_PRICE, 0);
  } catch (e) {
    Application.prefs.setInt(BONUS_PRICE, 0);
  }

  try {
    if (Application.prefs.getBool(ENABLE_BONUS_PRICE) == null)
      Application.prefs.setBool(ENABLE_BONUS_PRICE, false);
  } catch (e) {
    Application.prefs.setBool(ENABLE_BONUS_PRICE, false);
  }
}

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
