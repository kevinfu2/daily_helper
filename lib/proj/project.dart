import 'package:flutter/material.dart';

class MyProj extends StatefulWidget {
  MyProj({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyProj();
}

class _MyProj extends State<MyProj> {
  List _cities = [
    "Cluj-Napoca",
    "Bucuresti",
    "Timisoara",
    "Brasov",
    "Constanta"
  ];

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _selectedItem;
  String _currentItem;

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _selectedItem = _dropDownMenuItems[0].value;
    _currentItem = _dropDownMenuItems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String city in _cities) {
      // here we are creating the drop down menu items, you can customize the item right here
      // but I'll just use a simple text for this
      items.add(new DropdownMenuItem(value: city, child: new Text(city)));
    }
    return items;
  }

  void changedDropDownItem(String selectedCity) {
    print("Selected city $selectedCity, we are going to refresh the UI");
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
            DropdownButton(
              value: _selectedItem,
              items: _dropDownMenuItems,
              onChanged: changedDropDownItem,
            ),
            RaisedButton(
              onPressed: () => setState(() {
                    _currentItem = _selectedItem;
                  }),
              child: Text('添加'),
            )
          ],
        ),
      ),
    );
  }
}
