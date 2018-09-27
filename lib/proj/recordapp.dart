import 'dart:async';
import 'package:daily_helper/proj/recordlist.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:daily_helper/del/recordtype.dart';

class RecordApp extends StatefulWidget {
  RecordApp({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RecordApp();
}

class _RecordApp extends State<RecordApp> {
  String _selectedItem;
  Record _record = Record.init();
  RecordDBProvider provider;

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  @override
  void initState() {
    super.initState();
    _selectedItem = "loading";
    _initialSelectItem();
  }

  Future _initialSelectItem() async {
    if (provider == null) {
      provider = new RecordDBProvider();
      await provider.open("dh.db");
      await provider.getRecordTypes().then((items) {
        if (items != null) {
          _dropDownMenuItems = items
              .map((f) => DropdownMenuItem<String>(
                    child: Text(f.name),
                    value: f.name,
                  ))
              .toList();
          if (this.mounted)
            setState(() {
              _selectedItem = items[0].name;
            });
        } else
          _dropDownMenuItems = <DropdownMenuItem<String>>[
            DropdownMenuItem<String>(
              child: Text('loading'),
              value: "loading",
            )
          ];
      });

      await provider.getStartedRecord().then((value) {
        if (value != null && this.mounted)
          setState(() {
            _record = value;
          });
        if (_record.latitude == 0.0) _updatePosition();
      });
    }
  }

  void changedDropDownItem(String selected) {
    if (this.mounted)
      setState(() {
        _selectedItem = selected;
      });
  }

  Future _onPress() async {
    if (_record.name != _selectedItem) {
      if (_record.id != null) {
        _record.endTime = DateTime.now();
        await provider
            .updateRecord(_record)
            .then((int) => _record = Record.init());
      }
      if (this.mounted)
        setState(() {
          _record.name = _selectedItem;
          _record.startTime = DateTime.now();
        });
      _record = await provider.insertRecord(_record);
      _updatePosition();
    }
  }

  Future _updatePosition() async {
    await Geolocator()
        .getCurrentPosition(LocationAccuracy.high)
        .then((position) {
      if (this.mounted)
        setState(() {
          _record.latitude = position.latitude;
          _record.longtitude = position.longitude;
        });
      provider.updateRecord(_record);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Items'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Text(_record.latitude.toString()),
                  Text(_record.longtitude.toString()),
                ],
              ),
            ),
            Text(_record.startTime.toString()),
            Text(_record.name),
            Text("Select your item: "),
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
              onPressed: _onPress,
              child: Text('Add'),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RecordList()),
                );
              },
              child: Text('View'),
            ),
          ],
        ),
      ),
    );
  }
}
