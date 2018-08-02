import 'package:flutter/material.dart';
import 'tab_controller_demo.dart';
import 'UI/UI_show_tabbar.dart';
import 'package:flutter/cupertino.dart';
import 'camera.dart';
import 'scan_barcode.dart';
import 'video.dart';
import 'audio.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData.dark(),
      home: new MyHomePage(title: 'Flutter Demo'),
      routes: <String, WidgetBuilder>{
        // 这里可以定义静态路由，不能传递参数
        '/ui': (_) => new ShowUIPage(),
        '/tabbar/index': (_) => new TabBarDemo(),
        '/camera': (_) => new CameraPage(),
        '/scanner': (_) => new BarcodeScannerPage(),
        '/video': (_) => new VideoPage(),
        '/audio': (_) => new AudioApp(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<Map<String, String>> list = <Map<String, String>>[];

  @override
  void initState() {
    super.initState();
    list.add({"title": 'UI', 'router': '/ui'});
    list.add({"title": '网络应用', 'router': '/tabbar/index'});
    list.add({"title": '照相机', 'router': '/camera'});
    list.add({"title": '二维码', 'router': '/scanner'});
    list.add({"title": '视频播放', 'router': '/video'});
    list.add({"title": '音频播放', 'router': '/audio'});
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      //侧边栏
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              //Material内置控件
              accountName: new Text('Flutter'), //用户名
              accountEmail: new Text('example@qq.com'), //用户邮箱
              currentAccountPicture: new GestureDetector(
                //用户头像
                onTap: () => print('current user'),
                child: new CircleAvatar(
                  //圆形图标控件
                  backgroundImage: new NetworkImage(
                      'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1533565989&di=cedb81e28ddf947c5a2f947bef0723fa&imgtype=jpg&er=1&src=http%3A%2F%2Fimage.jijidown.com%2Fv1%2Fimage%3Fav%3D2844015%26amp%3Burl%3Dhttp%3A%2F%2Fi1.hdslb.com%2Fvideo%2F27%2F27c66f04b16231f71cc77db449eb796e.jpg%26amp%3Bsign%3D4BBC41376D4B67C6675F1763A34B9AAD'),
                ),
              ),
              decoration: new BoxDecoration(
                //用一个BoxDecoration装饰器提供背景图片
                image: new DecorationImage(
                    fit: BoxFit.fill,
                    image: new NetworkImage(
                        'https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3379816473,2034966035&fm=27&gp=0.jpg')),
              ),
            ),
            new ListTile(
              //第一个功能项
              title: new Text('Entry1'),
              trailing: new Icon(Icons.arrow_drop_up),
            ),
            new ListTile(
              //第二个功能项
              title: new Text('Entry2'),
              trailing: new Icon(Icons.arrow_right),
            ),
            new ListTile(
              //第二个功能项
              title: new Text('Entry3'),
              trailing: new Icon(Icons.arrow_drop_down),
            ),
            new Divider(), //分割线控件
            new ListTile(
              //退出按钮
              title: new Text('Close'),
              trailing: new Icon(Icons.cancel),
              onTap: () => Navigator.of(context).pop(), //点击后收起侧边栏
            ),
          ],
        ),
      ),
      //主页面
      body: new ListView.builder(
        // 这句是在list里面的内容不足一屏时，list可能会滑不动，加上就一直都可以滑动
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: this.list.length,
        itemBuilder: (_, int index) => _createItem(context, list[index]),
      ),
    );
  }

  _createItem(BuildContext context, Map<String, String> map) {
    return new GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(map['router']);
      },
      child: new Column(
        children: <Widget>[
          new SizedBox(
            height: 80.0,
            width: 800.0,
            child: new Padding(
              padding: EdgeInsets.fromLTRB(0.0, 22.0, 0.0, 26.0),
              child: new Text(
                map['title'],
                style: TextStyle(fontSize: 28.0),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Divider(
            height: 1.5,
          )
        ],
      ),
    );
  }
}
