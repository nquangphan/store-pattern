import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:order_app/Views/splash_screen.dart';
import 'package:order_app/app.dart';
import './Constants/theme.dart';
import 'Views/mainpage.view.dart';

import 'package:flutter/widgets.dart';
import 'package:user_repository/user_repository.dart';

// void main() => runApp(new MyApp());

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return new MaterialApp(
//       title: 'Order App',
//       theme: new ThemeData(
//         brightness: Brightness.light,
//         primaryColor: primaryColor,
//         accentColor: accentColor,
//       ),
//       debugShowCheckedModeBanner: false,
//       home: SplashScreen(
//         mContext: context,
//       ),
//     );
//   }
// }


void main() {
  runApp(App(
    authenticationRepository: AuthenticationRepository(),
    userRepository: UserRepository(),
  ));
}
