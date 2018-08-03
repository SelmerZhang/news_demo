/*import 'package:flutter/material.dart';
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
*/

import 'package:flutter/material.dart';
import 'web_list.dart';
import 'dart:convert';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/cupertino.dart';

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
  Map<String, dynamic> data;
  String fileDir;
  String cacheDir;

  @override
  void dispose() {
    //释放资源
    _tabController.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
    _getFilePath();
    _httpClient();
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
          new ListView(children: data != null ? _getItem() : _loading()),
          new LikedPage(),
        ],
      ),
    );
  }

  //获取文件路径
  void _getFilePath() async {
    fileDir = (await getApplicationDocumentsDirectory()).path;
    cacheDir = (await getTemporaryDirectory()).path;
    File file = new File('$fileDir/like_data');
    if (file.existsSync()) {
      String json = file.readAsStringSync();
      TabBarDemo.urlLikeList.clear();
      TabBarDemo.urlLikeList = jsonDecode(json);
    }
  }

  //发起http请求
  void _httpClient() async {
    var json;

    var httpClient = new HttpClient();
    //通过网络请求获得json数据
    var request = await httpClient
        .getUrl(Uri.parse("https://www.apiopen.top/journalismApi"));
    var response = await request.close();
    //解析json数据
    if (response.statusCode == HttpStatus.OK) {
      json = await response.transform(utf8.decoder).join();
      //将解析完的json数据保存到data中，保存的数据类型是List<dynamic>
      var convertDataToJson = jsonDecode(json)["data"]; //["tech"];
      if (this.mounted == true) {
        //在setState之前需要检查该对象是否还存在，可能在某个延迟调用setState的时候，该对象已经销毁
        setState(() {
          data = convertDataToJson;
        });
      }
    } else {
      print('Error getting IP address:\n Http status ${response.statusCode}');
    }
  }

  //_loading函数在未加载出数据时显示加载动画
  List<Widget> _loading() {
    return <Widget>[
      new Container(
        height: 300.0,
        child: new Center(
            child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new CupertinoActivityIndicator(
              radius: 15.0,
            ),
            new Text("正在加载"),
          ],
        )),
      )
    ];
  }

  //对data中的每个数据渲染UI，返回一个widget列表
  List<Widget> _getItem() {
    List<Widget> ret = new List<Widget>();
    data.forEach((key, value) {
      List module = value;
      List<Widget> mod = module.map((item) {
        TabBarDemo.urlList.add(item);
        //读到的数据可能存在所有值为null的脏数据，需要去掉
        if (item["title"] == null) {
          return new Container();
        }
        return new Card(
          shape: Border(),
          child: new Padding(
            padding: const EdgeInsets.all(7.0),
            child: _getRowWidget(item),
          ),
          elevation: 0.0,
          margin: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
        );
      }).toList();
      ret.addAll(mod);
    });
    return ret;

    /*List tech=data["tech"];
    return tech.map((item) {
      TabBarDemo.urlList.add(item);
      return new Card(
        child: new Padding(
          padding: const EdgeInsets.all(7.0),
          child: _getRowWidget(item),
        ),
        elevation: 5.0,
        margin: const EdgeInsets.all(7.0),
      );
    }).toList();*/
  }

  //对数据渲染UI
  Widget _getRowWidget(item) {
    final bool liked = TabBarDemo.urlLikeList.map((f) {
      return f["docid"];
    }).contains(item["docid"]);
    return new Row(
      children: <Widget>[
        new Container(
          alignment: Alignment.centerLeft,
          child: new GestureDetector(
            //该组件对应可以相应相关动作，对组件进行了一层包装
            onTap: () {
              //点击事件最终会触发该方法
              if (item["picInfo"].length > 0)
                launch("${item["picInfo"][0]["url"]}");
            },
            child: new ClipRect(
              child: //new Image.file(file_dir), 验证图片下载与本地io是否成功
                  new FadeInImage.assetNetwork(
                placeholder: "images/ic_shop_normal.png",
                //从网站上读的数据存在部分没有图片，需要判断
                image: item["picInfo"].length == 0
                    ? "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1532698709281&di=b19d89c4889006966a4ace22c40a197c&imgtype=0&src=http%3A%2F%2Fimgqn.koudaitong.com%2Fupload_files%2F2015%2F04%2F08%2FFkcwV9ezJBjSDEXATlHuCh_4J589.jpg%2521580x580.jpg"
                    : "${item["picInfo"][0]["url"]}",
                width: 150.0,
                height: 90.0,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ),
        new Container(
          width: 15.0,
        ),
        new Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: new Column(
            children: <Widget>[
              new Container(
                alignment: Alignment.centerLeft,
                child: new GestureDetector(
                  //该组件对应可以相应相关动作，对组件进行了一层包装
                  onTap: () {
                    //点击事件最终会触发该方法
                    launch("${item["link"]}");
                  },
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(
                        "${item["title"]}".trim(),
                        style: new TextStyle(
                          fontSize: 22.0,
                        ),
                        maxLines: 1,
                      ),
                      new Text(
                        "${item["digest"]}......",
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
              new Container(
                height: 30.0,
                alignment: Alignment.center,
                child: new GestureDetector(
                  //该组件对应可以相应相关动作，对组件进行了一层包装
                  onTap: () async {
                    //点击事件最终会触发该方法
                    setState(() {
                      if (liked) {
                        var removeitem;
                        for (var url in TabBarDemo.urlLikeList) {
                          if (url["docid"] == item["docid"]) removeitem = url;
                        }
                        TabBarDemo.urlLikeList.remove(removeitem);
                        print("remove");
                      } else {
                        TabBarDemo.urlLikeList.add(item);
                        print("add");
                      }
                    });
                    //更新喜爱列表后，更改本地文件，下载或删除图片
                    if (liked) {
                      String deleteDir = '$fileDir/${item["docid"]}.png';
                      File filepath = new File(deleteDir);
                      try {
                        filepath.delete();
                        print("delete succeed!");
                      } catch (e) {
                        print(e);
                      }
                    } else {
                      Dio dio = new Dio();
                      String saveDir = '$fileDir/${item["docid"]}.png';
                      try {
                        if (item["picInfo"].length == 0) {
                          Response response = await dio.download(
                              "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1532698709281&di=b19d89c4889006966a4ace22c40a197c&imgtype=0&src=http%3A%2F%2Fimgqn.koudaitong.com%2Fupload_files%2F2015%2F04%2F08%2FFkcwV9ezJBjSDEXATlHuCh_4J589.jpg%2521580x580.jpg",
                              saveDir,
                              // Listen the download progress.
                              onProgress: (received, total) {
                            print((received / total * 100).toStringAsFixed(0) +
                                "%");
                          });
                          print(response.statusCode);
                        } else {
                          Response response = await dio
                              .download("${item["picInfo"][0]["url"]}", saveDir,
                                  // Listen the download progress.
                                  onProgress: (received, total) {
                            print((received / total * 100).toStringAsFixed(0) +
                                "%");
                          });
                          print(response.statusCode);
                        }
                        print("download succeed!");
                      } catch (e) {
                        print(e);
                      }
                    }
                    File fileLike = File('$fileDir/like_data');
                    fileLike.createSync();
                    String json = JSON.encode(TabBarDemo.urlLikeList);
                    fileLike.writeAsStringSync(json);
                  },
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Icon(
                        liked ? Icons.favorite : Icons.favorite_border,
                        color: liked ? Colors.red : null,
                      ),
                      new Text("喜欢"),
                    ],
                  ),
                ),
              )
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        ),
      ],
    );
  }
}
