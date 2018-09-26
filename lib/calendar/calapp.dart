import 'dart:async';

import 'package:flutter/material.dart';
import 'package:daily_helper/del/recordtype.dart';

class CalAPP extends StatefulWidget {
  const CalAPP({Key key, this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() => _CalAPP();
}

class _CalAPP extends State<CalAPP> {
  RecordTypeProvider provider;
  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initialProvider();
    myController.text = 'hello';
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myController.dispose();
    super.dispose();
  }

  void _initialProvider() async {
    provider = new RecordTypeProvider();
    await provider.open("dh.db");
  }

  void _buttonClick() {
    _insert();
  }

  Future _insert() async {
    if (provider != null) {
      var record = await provider.insert(new RecordType(myController.text));
      print(record.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      //appBar: new AppBar(title: new Text('title')),

       resizeToAvoidBottomPadding: false,
      body: Container(
        child:
         ListView( 
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: myController,
                decoration: InputDecoration(
                   hintText: "please input new category",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: RaisedButton(
                onPressed: _buttonClick,
                child: Text('Add'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
