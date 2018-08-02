import 'package:flutter/material.dart';
import 'web_list.dart';

class TabBarDemo extends StatefulWidget {
  static var urlList = <dynamic>[]; //所有网址
  static var urlLikeList = <dynamic>[]; //喜欢的网址

  @override
  State<StatefulWidget> createState() {
    return new _TabBarDemoState();
  }
}

class _TabBarDemoState extends State<TabBarDemo>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void dispose() {
    //释放资源
    _tabController.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Flutter Demo'),
        bottom: new TabBar(
          unselectedLabelColor: Colors.grey,
          tabs: <Widget>[
            new Tab(icon: new Icon(Icons.navigation), text: '导航'),
            new Tab(icon: new Icon(Icons.favorite), text: '喜爱'),
          ],
          controller: _tabController,
        ),
      ),
      body: new TabBarView(
        controller: _tabController,
        children: <Widget>[
          new HomePage(),
          new LikedPage(),
        ],
      ),
    );
  }
}
