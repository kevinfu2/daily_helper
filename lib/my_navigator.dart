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
  TabItem _currentTab = TabItem.project;
  int _currentIndex = 0;
  final _views = <Widget>[];

  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.red: GlobalKey<NavigatorState>(),
    TabItem.green: GlobalKey<NavigatorState>(),
    TabItem.blue: GlobalKey<NavigatorState>(),
  };
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    final bottomBar = BottomNavigationBar(
      onTap: (int index) {
        setState(() {
          _currentIndex = index;
        });
      },
      items: _getBottomBarItem(),
      currentIndex: 0,
      type: BottomNavigationBarType.fixed,
    );

    return Scaffold(
      appBar: _buildAppbar(),
      body: _buildBody(),
      bottomNavigationBar: bottomBar,
    );
  }

  Widget _buildBody() {
    return Stack(
      children: <Widget>[
        Offstage(
          offstage: _currentIndex != 0,
          child: TickerMode(
              enabled: _currentIndex == 0,
              child: MyPage(
                title: 'first',
              )),
        ),
        Offstage(
          offstage: _currentIndex != 1,
          child: TickerMode(
            enabled: _currentIndex == 1,
            child: MaterialApp(
                home: MyPage(
              title: 'second',
            )),
          ),
        ),
      ],
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
    final items = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: const Icon(Icons.access_alarm),
        title: Text('项目'),
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.calendar_today),
        title: Text('日历'),
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.map),
        title: Text('轨迹'),
      ),
    ];
    return items;
  }
}
