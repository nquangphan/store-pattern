import 'package:shared_preferences/shared_preferences.dart';

class Dimension {
  static double height = 0.0;
  static double width = 0.0;

  static double getWidth(double size) {
    return width * size;
  }

  static double getHeight(double size) {
    return height * size;
  }
}

class Application {
   static SharedPreferences prefs;
}
