import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class TabItem {
  const TabItem({this.name, this.icon, this.route});

  @required
  final String name;
  @required
  final String route;
  @required
  final IconData icon;
}
