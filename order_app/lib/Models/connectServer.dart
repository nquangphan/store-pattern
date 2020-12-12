import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import './../Constants/evn.dart';

class MySqlConnection {
  static MySqlConnection _instance;
  String serverURL;
  String serverIP;
  static MySqlConnection get instance {
    if (_instance == null) _instance = new MySqlConnection();
    return _instance;
  }

  Future<bool> executeNoneQuery(String query, {List parameter}) async {
    if (parameter != null) {
      query = _addParameter(query, parameter);
    }

    http.Response response = await http.post(
      serverURL,
      body: {ID_EXECUTENONEQUERY: query},
    );

    int number = 0;
    if (response.statusCode == 200) number = int.parse(response.body);
    return number > 0;
  }

  Future<List> executeQuery(String query, {List parameter}) async {
    if (parameter != null) {
      query = _addParameter(query, parameter);
    }
    print('=========REQUEST: $serverURL   $query');
    http.Response response = await http.post(
      serverURL,
      body: {ID_EXECUTEQUERY: query},
    );
    print('===========RESPONSE: ${response.body} CODE: ${response.statusCode}');
    if (response.statusCode == 200) return json.decode(response.body);
    return null;
  }

  String _addParameter(String query, List parameter) {
    /**To return a query have added paramete ralready
     *
     * query = "call USP_Proc( @a , @b , @c )"
     *
     *  parameter = ["123" , "123" , 123 ]
     *
     *  After call  addParameter
     * so result query = "call USP_Proc( '123' , '123' , 123 )"
     * */
    List<String> list = query.split(' ');
    query = "";
    int i = 0;
    list.forEach((String element) {
      if (element.contains('@')) {
        if ((parameter[i] is String || parameter[i] is DateTime) &&
            parameter.length > i)
          query += "\'" + parameter[i++].toString() + "\'";
        else
          query += parameter[i++].toString();
      } else
        query += element;
      query += " ";
    });
    return query;
  }
}
