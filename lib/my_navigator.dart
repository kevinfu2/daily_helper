import 'package:flutter/material.dart';
import 'page.dart';
import 'package:daily_helper/navigateor/TabNavigator.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyHomePage();
  }
}

class _MyHomePage extends State<MyHomePage> {
  static const tabs = <TabItem>[
    TabItem(name: "项目", icon: Icons.access_alarm, route: "/project"),
    TabItem(name: "日历", icon: Icons.calendar_today,route: "/calendar"),
    TabItem(name: "轨迹", icon: Icons.map,route: "/trace"),
  ];

  TabItem _currentTab = tabs[0];

  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = Map.fromIterable(tabs,
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
      appBar: _buildAppbar(),
      body: Stack(
        children: tabs.map(_buildNavitationBarItem).toList(),
      ),
      bottomNavigationBar: bottomBar,
    );
  }

  Widget _buildNavitationBarItem(TabItem tabItem) {
    return Offstage(
      offstage: _currentTab != tabItem,
      child: TickerMode(
        enabled: _currentTab == tabItem,
        child: Navigator(
          initialRoute: tabItem.route,
          key: navigatorKeys[tabItem],
          onGenerateRoute: (routeSettings) {
            print(routeSettings.name);
            return MaterialPageRoute(
              builder: (context) => MyPage(
                    title: _currentTab.name,
                  ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppbar() {
    return AppBar(
      elevation: 1.0,
      title: Text('测试标题'),
      centerTitle: true,
    );
  }

  List<BottomNavigationBarItem> _getBottomBarItem() {
    return tabs.map( (e)=> BottomNavigationBarItem(
        icon:  Icon( e.icon,
         color: _currentTab == e ? Theme.of(context).primaryColor : Colors.grey
        ),
        title: Text(e.name,
         style: TextStyle(
          color: _currentTab == e ? Theme.of(context).primaryColor : Colors.grey
         ),
        ),

      ) ).toList();
  }
}
