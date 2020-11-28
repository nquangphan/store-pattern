import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:order_app/Constants/theme.dart';
import 'package:order_app/Models/home.model.dart';
import 'package:order_app/Models/login.model.dart';
import 'package:order_app/Views/cart.view.dart';
import 'package:order_app/home/bloc/table_list/table_list_bloc.dart';
import 'package:user_repository/user_repository.dart';

class TableListScreen extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => BlocProvider(
        create: (context) {
          return TableListBloc();
        },
        child: TableListScreen(),
      ),
    );
  }

  TableListScreen({key, this.account}) : super(key: key);

  final Account account;

  @override
  State<StatefulWidget> createState() {
    return new _TableListScreenState();
  }
}

class _TableListScreenState extends State<TableListScreen> {
  AppTable _selectedTable;
  TableListBloc _tableListBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _tableListBloc.stopBackgroundTask();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _tableListBloc = BlocProvider.of(context);
    return Scaffold(
      body:
          BlocBuilder<TableListBloc, TableListState>(builder: (context, state) {
        return state == TableListState.IDLE
            ? SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.all(5.0),
                  child: StreamBuilder<List<AppTable>>(
                      stream: _tableListBloc.tableListStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          return Wrap(
                            alignment: WrapAlignment.spaceEvenly,
                            runSpacing: 20,
                            spacing: 8,
                            children: List<Widget>.generate(
                                snapshot.data.length, (index) {
                              return _buildTable(context, snapshot.data[index]);
                            }),
                          );
                        } else {
                          return Container();
                        }
                      }),
                ),
              )
            : Center(child: CircularProgressIndicator());
      }),
    );
  }

  Widget _buildTable(BuildContext context, AppTable table) {
    return new GestureDetector(
      onTap: () {
        setState(() {
          _selectedTable = table;
        });
        _tableListBloc.add(OpenCart(table, context));
      },
      child: new Container(
          padding: EdgeInsets.zero,
          margin: EdgeInsets.zero,
          child: new Card(
            color: table.status == 1 ? Colors.green : primaryColor,
            child: new Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Icon(
                    table.status == 1 ? Icons.people : Icons.people_outline,
                    size: 20.0,
                    color:
                        table.status == 1 ? Colors.redAccent : Colors.redAccent,
                  ),
                ),
                // new Expanded(child: new Container()),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 30.0, bottom: 30.0, right: 16.0),
                    child: new Text(
                      'Bàn ' + table.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: fontColorLight,
                          fontFamily: 'Arial',
                          fontSize: 20.0),
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
