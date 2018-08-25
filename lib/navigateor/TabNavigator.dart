import 'package:flutter/material.dart';
import 'package:daily_helper/page.dart';
class TabNavigatorRoutes{
  static const String root = '/';
  static const String detail = '/detail';
}
enum TabItem { project, calendar, trace }
class TabNavigator extends StatelessWidget{
  final GlobalKey<NavigatorState> navigatorKey;
  final TabItem tabItem;
  TabNavigator({this.navigatorKey, this.tabItem});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Navigator(
       key: navigatorKey,
        onGenerateRoute: (routeSettins) =>
        MaterialPageRoute(builder: (context){
            return MyPage(title: routeSettins.name,);
        }),
      );
  }

}