import 'dart:async';

import 'package:flutter/material.dart';
import 'package:daily_helper/del/recordtype.dart';

class RecordList extends StatefulWidget {
  const RecordList({Key key, this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() => _RecordList();
}

class _RecordList extends State<RecordList> {
  RecordDBProvider provider;
  List<Record> items;
  @override
  void initState() {
    super.initState();
    _initialProvider();
  }

  void _initialProvider() async {
    if (provider == null) {
      provider = new RecordDBProvider();
      await provider.open("dh.db");
    }
    _getTypes();
  }

  void _getTypes() async {
    var _types = await provider.getRecords( limit: 6);
    if (this.mounted)
      setState(() {
        items = _types;
      });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(title: new Text('Add Category')),
      resizeToAvoidBottomPadding: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row( crossAxisAlignment: CrossAxisAlignment.start,
           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Return'),
              ),
              RaisedButton(
                onPressed: () {},
                child: Text('Sync Firebase'),
              ),
            ],
          ),
          items == null
              ? Container(
                  child: Text('Loading...'),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    padding: const EdgeInsets.only(top: 3.0),
                    //itemExtent: 55.0,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: ObjectKey(items[index]),
                        direction: DismissDirection.horizontal,
                        onDismissed: (DismissDirection direction) =>
                            provider.deleteRecord(items[index].id),
                        background: Container(
                            color: Theme.of(context).primaryColor,
                            child: const ListTile(
                                leading: Icon(Icons.delete,
                                    color: Colors.white, size: 36.0))),
                        secondaryBackground: Container(
                            color: Theme.of(context).primaryColor,
                            child: const ListTile(
                                trailing: Icon(Icons.archive,
                                    color: Colors.white, size: 36.0))),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).canvasColor,
                              border: Border(
                                  bottom: BorderSide(
                                      color: Theme.of(context).dividerColor))),
                          child: ListTile(
                            title: Row(
                              children: <Widget>[
                                Container(
                                  child: Center(
                                    child: Text('${items[index].name}'),
                                  ),
                                  width: 56.0,
                                ),
                                Expanded(
                                  child: Text(
                                    '${items[index].location}',
                                    style: TextStyle(color: Colors.lime[900]),
                                    textScaleFactor: 0.66,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Text(
                              '${items[index].startTime} ~ ${items[index].endTime}',
                              style: TextStyle(color: Colors.blueGrey[600]),
                              textScaleFactor: 0.76,
                            ),
                            isThreeLine: false,
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
