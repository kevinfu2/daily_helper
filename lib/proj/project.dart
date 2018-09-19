import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyProj extends StatefulWidget {
  MyProj({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyProj();
}

class _MyProj extends State<MyProj> {
  String _selectedItem;
  String _currentItem;

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  @override
  void initState() {
    super.initState();
    _currentItem = 'initial';
    _initialSelectItem();
  }

  Future _initialSelectItem() async {
    var snapshot =
        await Firestore.instance.collection("consumetype").getDocuments();
    _dropDownMenuItems = snapshot.documents
        .map((f) => DropdownMenuItem<String>(
              child: Text(f['name']),
              value: f.documentID,
            ))
        .toList();
    setState(() {
      _selectedItem = _dropDownMenuItems[0].value;
      _currentItem = _dropDownMenuItems[0].value;
    });
  }

  void changedDropDownItem(String selectedCity) {
    setState(() {
      _selectedItem = selectedCity;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('项目'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(_currentItem),
            Text("请选择你的项目: "),
            Container(
              padding: EdgeInsets.all(16.0),
            ),
            _dropDownMenuItems == null
                ? Container(
                    child: Text('Loading...'),
                  )
                : DropdownButton(
                    value: _selectedItem,
                    items: _dropDownMenuItems,
                    onChanged: changedDropDownItem,
                  ),
            RaisedButton(
              onPressed: () => setState(() {
                    _currentItem = _selectedItem + DateTime.now().toString();
                  }),
              child: Text('添加'),
            )
          ],
        ),
      ),
    );
  }
}
