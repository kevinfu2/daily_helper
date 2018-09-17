import 'package:flutter/material.dart';

class MyPage extends StatelessWidget {
  final String title;

  MyPage({this.title});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text(title),
      ),
    );
  }
}
