import 'package:flutter/material.dart';

import '../Constants/queries.dart';
import '../Controllers/menu.controller.dart';
import '../Utils/utils.dart';

class SettingScreen extends StatefulWidget {
  SettingScreen({Key key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  TextEditingController textEditingController;
  bool checkboxValue;
  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController(
        text: Application.prefs.getInt(BONUS_PRICE).toString());
    checkboxValue = Application.prefs.getBool(ENABLE_BONUS_PRICE);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Text('Bật giá tết: '),
                Checkbox(
                  value: checkboxValue,
                  onChanged: (value) async {
                    await Application.prefs
                        .setBool(ENABLE_BONUS_PRICE, !checkboxValue);

                    await Controller.instance.foods(force: true);
                    setState(() {
                      checkboxValue = !checkboxValue;
                    });
                  },
                ),
              ],
            ),
            Text('Giá thêm'),
            TextField(
              controller: textEditingController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                var price = int.tryParse(value);
                if (price != null) {
                  Application.prefs.setInt(BONUS_PRICE, price);
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 28.0),
              child: Center(
                child: RaisedButton(
                  child: Text('Lưu'),
                  onPressed: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    var price = int.tryParse(textEditingController.text);
                    if (price != null) {
                      Application.prefs.setInt(BONUS_PRICE, price);
                      await Controller.instance.foods(force: true);
                    }
                  },
                ),
              ),
            ),
          ],
        ));
  }
}
