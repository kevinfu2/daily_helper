import 'package:flutter/material.dart';
import 'trace/trace.dart';
import 'proj/project.dart';
import 'calendar/firebase.dart';
import 'calendar/calapp.dart';
import 'calendar/textfield.dart';

class TabItem {
  const TabItem({this.name, this.icon, this.route});
  @required
  final String name;
  @required
  final String route;
  @required
  final IconData icon;
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyHomePage();
  }
}

class _MyHomePage extends State<MyHomePage> {
  static const tabs = <TabItem>[
    TabItem(name: "项目", icon: Icons.access_alarm, route: "/"),
    TabItem(name: "日历", icon: Icons.calendar_today, route: "/"),
    TabItem(name: "轨迹", icon: Icons.map, route: "/"),
  ];

  TabItem _currentTab = tabs[0];

  static Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys =
      Map.fromIterable(tabs,
          key: (item) => item, value: (item) => GlobalKey<NavigatorState>());

  @override
  Widget build(BuildContext context) {
    final bottomBar = BottomNavigationBar(
      onTap: (int index) {
        setState(() {
          _currentTab = tabs[index];
        });
      },
      items: _getBottomBarItem(),
      currentIndex: 0,
      type: BottomNavigationBarType.fixed,
    );

    return Scaffold(
      // appBar: _buildAppbar(),
      body: Stack(
        children: tabs.map<Widget>(_buildNavitationBarItem).toList(),
      ),
      bottomNavigationBar: bottomBar,
    );
  }

  Widget _navigate(BuildContext context) {
    if (_currentTab.name == '轨迹')
      return Trace();
    else if (_currentTab.name == '日历')
      return CalAPP(
        title: _currentTab.name,
      );
    else
      return MyProj();
  }

  Widget _buildNavitationBarItem(TabItem tabItem) {
    return Offstage(
      offstage: _currentTab != tabItem,
      child: new TickerMode(
        enabled: true,
        child: Navigator(
          initialRoute: tabItem.route,
          key: navigatorKeys[tabItem],
          onGenerateRoute: (routeSettings) {
            print(routeSettings.name + ' ' + tabItem.name);
            return MaterialPageRoute(
              builder: (context) => _navigate(context),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppbar() {
    return AppBar(
      elevation: 1.0,
      title: Text('Hello, Word'),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.menu),
        tooltip: 'Navigate Menu',
        onPressed: null,
      ),
      actions: <Widget>[
        IconButton(
          onPressed: null,
          icon: Icon(Icons.search),
          tooltip: 'Search',
        ),
      ],
    );
  }

  List<BottomNavigationBarItem> _getBottomBarItem() {
    return tabs
        .map((e) => BottomNavigationBarItem(
              icon: Icon(e.icon,
                  color: _currentTab == e
                      ? Theme.of(context).primaryColor
                      : Colors.grey),
              title: Text(
                e.name,
                style: TextStyle(
                    color: _currentTab == e
                        ? Theme.of(context).primaryColor
                        : Colors.grey),
              ),
            ))
        .toList();
  }
}
