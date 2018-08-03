import 'package:flutter/material.dart';
import 'dart:async';

class UIpage2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
      print('bulid page2');
    return new UIPageState2();
  }
}

class UIPageState2 extends State<UIpage2> {
  final TrackingScrollController _scrollController =
      new TrackingScrollController();
  List<String> list = <String>[];
  String ver = ' V1';
  int vernum = 1;

  // 是否有下一页
  bool isMore = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    _loadMoreData();
  }

  Future<Null> _loadMoreData() {
    return _getData();
  }

  // 请求首页数据
  Future<Null> _getData() {
    this.isLoading = true;
    final Completer<Null> completer = new Completer<Null>();

    new Timer(Duration(seconds: 2), () {
      for (int i = 0; i < 20; i++) {
        list.add('Example ${list.length+1}');
      }

      if (this.list.length >= 60) {
        this.isMore = false;
      } else {
        this.isMore = true;
      }

      this.isLoading = false;
      completer.complete(null);
      if (mounted) setState(() {});
    });

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return new NotificationListener(
      onNotification: _onNotification,
      child: new RefreshIndicator(
        //下拉刷新
        onRefresh: () {
          Completer cmpl = new Completer<Null>();
          new Timer(Duration(seconds: 2), () {
            if (mounted) {
              setState(() {
                vernum++;
                ver = ' V$vernum';
              });
            }

            cmpl.complete(null);
          });

          return cmpl.future;
        },
        child: new ListView.builder(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: itemCount(),
          itemBuilder: (context, int index) => _createItem(context, index),
        ),
      ),
    );
  }

  int itemCount() {
    if (this.list.length > 0) {
      return this.list.length ~/ 2 + 1;
    }

    return 0;
  }

  bool _onNotification(ScrollEndNotification notification) {
      if (_scrollController.mostRecentlyUpdatedPosition.maxScrollExtent <=
          _scrollController.offset) {
        // 要加载更多
        if (this.isMore && !this.isLoading) {
          // 有下一页
          _loadMoreData();
          setState(() {});
        } else {}
      }
    

    return true;
  }

  String _getLoadMoreString() {
    if (this.isMore && !this.isLoading) {
      return '上拉加载更多';
    } else if (!this.isMore) {
      return '没有更多了';
    } else {
      return '加载中...';
    }
  }

  _createItem(BuildContext context, int index) {
    if (index * 2 + 1 < list.length) {
      return _createArticleItem(context, index);
    }

    return new Container(
      height: 44.0,
      child: new Center(
        child: new Text(_getLoadMoreString()),
      ),
    );
  }

  _createArticleItem(BuildContext context, int index) {
    return new Container(
      height: 200.0,
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Card(
            margin: EdgeInsets.all(10.0),
            child: new SizedBox(
              height: 240.0,
              width: 360.0,
              child: Center(
                child: Text('${list[index*2]} $ver'),
              ),
            ),
          ),
          //最后一行如果只有一个item则只显示一张卡片
          index * 2 + 1 > list.length - 1
              ? new Container()
              : new Card(
                  margin: EdgeInsets.all(10.0),
                  child: new SizedBox(
                    height: 240.0,
                    width: 360.0,
                    child: Center(
                      child: Text('${list[index*2+1]} $ver'),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
