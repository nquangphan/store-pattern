import 'package:flutter/material.dart';

import './theme.dart' as theme;

void errorDialog(BuildContext context, String message) {
  if (context != null)
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Lỗi', style: theme.errorTitleStyle),
            content: new Text(message, style: theme.contentStyle),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Ok', style: theme.okButtonStyle),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
}

void successDialog(BuildContext context, String message) {
  if (context != null)
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Thông báo', style: theme.titleStyle),
            content: new Text(message, style: theme.contentStyle),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Ok', style: theme.okButtonStyle),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
}
