import 'package:daily_helper/calendar/firebase.dart';
import 'package:daily_helper/proj/recordapp.dart';
import 'package:flutter/material.dart';
import 'trace/trace.dart';
import 'proj/cateapp.dart';

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
  Map<String, FocusScopeNode> _focusNodes = {
    "项目": FocusScopeNode(),
    "日历": FocusScopeNode(),
    "轨迹": FocusScopeNode(),
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _focusNodes["项目"].detach();
    _focusNodes["日历"].detach();
    _focusNodes["轨迹"].detach();
    super.dispose();
  }

  TabItem _currentTab = tabs[0];

  static Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys =
      Map.fromIterable(tabs,
          key: (item) => item, value: (item) => GlobalKey<NavigatorState>());

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).setFirstFocus(_focusNodes[_currentTab.name]);
    final bottomBar = BottomNavigationBar(
      onTap: (int index) {
        setState(() {
          _currentTab = tabs[index];
          FocusScope.of(context).setFirstFocus(_focusNodes[_currentTab.name]);
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
      return FirebaseApp(
        title: _currentTab.name,
      );
    else
      return RecordApp();
  }

  Widget _buildNavitationBarItem(TabItem tabItem) {
    return Offstage(
      offstage: _currentTab != tabItem,
      child: new TickerMode(
        enabled: true,
        child: FocusScope(
          node: _focusNodes[tabItem.name],
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
