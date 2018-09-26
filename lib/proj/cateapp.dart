import 'dart:async';

import 'package:flutter/material.dart';
import 'package:daily_helper/del/recordtype.dart';

class CategoryAPP extends StatefulWidget {
  const CategoryAPP({Key key, this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() => _CalAPP();
}

class _CalAPP extends State<CategoryAPP> {
  RecordDBProvider provider;
  final myController = TextEditingController();
  List<RecordType> types;
  @override
  void initState() {
    super.initState();
    _initialProvider();
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myController.dispose();
    super.dispose();
  }

  void _initialProvider() async {
    if (provider == null) {
      provider = new RecordDBProvider();
      await provider.open("dh.db");
    }
    _getTypes();
  }

  void _buttonClick() {
    _insert();
    _getTypes();
  }

  Future _insert() async {
    if (provider != null && myController.text.isNotEmpty) {
      await provider.insertRecordType(new RecordType(myController.text));
    }
  }

  Future _getTypes() async {
    var _types = await provider.getRecordTypes();
    if (this.mounted)
      setState(() {
        types = _types;
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
          TextField(
            controller: myController,
            decoration: InputDecoration(
              hintText: "please input new category",
            ),
          ),
          RaisedButton(
            onPressed: _buttonClick,
            child: Text('Add'),
          ),
          types == null
              ? Container(
                  child: Text('Loading...'),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: types.length,
                    padding: const EdgeInsets.only(top: 10.0),
                    itemExtent: 55.0,
                    itemBuilder: (context, index) {
                      return ListTile(
                          key: ValueKey(types[index].id),
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
                                  child: Text(types[index].name),
                                ),
                                Text(types[index].id.toString()),
                              ],
                            ),
                          ),
                          onTap: () {
                            provider.deleteRecordType(types[index].id);
                            _getTypes();
                          });
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
