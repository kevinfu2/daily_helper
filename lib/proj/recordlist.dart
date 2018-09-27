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
  void _getTypes() async{
    var _types = await provider.getRecords();
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
          RaisedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Return'),
          ),
          items == null
              ? Container(
                  child: Text('Loading...'),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    padding: const EdgeInsets.only(top: 10.0),
                    itemExtent: 55.0,
                    itemBuilder: (context, index) {
                      return ListTile(
                          key: ValueKey(items[index].id),
                          title: Container(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: const Color(0x80000000)),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            padding: const EdgeInsets.all(10.0),
                            child: new Row(
                              children: <Widget>[
                                new Expanded(
                                  child: Text(items[index].name),
                                ),
                                Text(items[index].id.toString()),
                              ],
                            ),
                          ),
                          onTap: () {
                            provider.deleteRecord(items[index].id);
                            _getTypes();
                          },);
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
