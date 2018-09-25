import 'package:flutter/material.dart';
import 'package:daily_helper/del/recordtype.dart'
class CalAPP extends StatefulWidget{
  const CalAPP({Key key, this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() => _CalAPP();

}
class _CalAPP extends State<CalAPP> {
   RecordTypeProvider provider;

  @override
  void initialState(){
      _initialProvider();
  }
  void _initialProvider() async{
      provider = new RecordTypeProvider();
      await provider.open("dh.db");
  }
  _buttonClick() {
    if( provider != null){
      provider.insert(new RecordType())
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(title: new Text('title')),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              child: TextField(
                 
              ),
            ),
            RaisedButton(
              onPressed: _buttonClick(),
              child: Text('添加类别'),
            )
          ],
        ),
      ),
    );
  }
}
