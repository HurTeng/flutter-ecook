import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../common/api.dart';
import 'package:ecook/common/net_util.dart';
import '../widget/menu_row.dart';

class MenuCategoryCollection extends StatefulWidget {
  var title;

  @override
  State<StatefulWidget> createState() => new MenuCategoryCollectionState(id);
  var id = "";

  MenuCategoryCollection(id, this.title) {
    this.id = id;
  }
}

class MenuCategoryCollectionState extends State<MenuCategoryCollection> {
  final ScrollController _controller = new ScrollController(); // 滚动控制

  var listData = new List(); // 列表数据
  var page = 0;
  var id = '';
  var noMore = false;

  MenuCategoryCollectionState(id) {
    this.id = id;
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      // 添加滚动监听器
      var maxScroll = _controller.position.maxScrollExtent; // 最大滚动位置
      var pixels = _controller.position.pixels; // 像素
      if (maxScroll == pixels && !noMore) {
        // scroll to bottom, get next page data
//        print("load more ... ");
        getNewsList(true); // 加载更多数据
      }
    });
    getNewsList(false); // 首次加载
  }

  // 下拉刷新
  Future<Null> _pullToRefresh() async {
    page = 0; // 重置页面
    getNewsList(false); // 加载数据
    return null;
  }

  // 状态对象定义了build方法
  @override
  Widget build(BuildContext context) {
    // 无数据时，显示Loading
    if (listData == null) {
      return getCenter();
    } else {
      return new Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: createRefreshIndicator()); // require a Material widget ancestor
//      return createRefreshIndicator();
    }
  }

  Center getCenter() {
    new Center(
      // CircularProgressIndicator是一个圆形的Loading进度条
      child: new CircularProgressIndicator(),
    );
  }

  // 创建
  RefreshIndicator createRefreshIndicator() {
    // 有数据，显示ListView
    Widget listView = new ListView.builder(
      itemCount: listData.length,
      itemBuilder: (context, i) => renderRow(i),
      controller: _controller,
    );
    return new RefreshIndicator(child: listView, onRefresh: _pullToRefresh);
  }

  // 从网络获取数据，isLoadMore表示是否是加载更多数据
  getNewsList(bool isLoadMore) {
    String url = Api.getCategoryDishesById(id, page);
    NetUtils.get(url).then((data) {
      if (data == null) {
        return;
      }
      // 将接口返回的json字符串解析为map类型
      Map<String, dynamic> map = json.decode(data);
      // code=0表示请求成功
      if (map['state'] != '200') {
        return;
      }

      print(map);
      // 设置数据
      setupData(map, isLoadMore);
    });
  }

  void setupData(Map<String, dynamic> map, bool isLoadMore) {
    var _listData = map['list'];
    // 当widget的状态改变时，状态(State)对象调用setState()，告诉框架重绘widget
    setState(() {
      if (isLoadMore) {
        // 加载更多数据，则需要将取到的news数据追加到原来的数据后面
        List list = new List();
        // 添加原来的数据
        list.addAll(listData);
        // 添加新取到的数据
        list.addAll(_listData);
        // 判断是否获取了所有的数据，如果是，则需要显示底部的"我也是有底线的"布局
        if (_listData.length <= 0) {
          noMore = true;
        }
        _listData = list; // 重新赋值
      }
      listData = _listData; // 给列表数据赋值
      page++;
    });
  }

  // 渲染列表数据
  Widget renderRow(i) {
    return new MenuRow(itemData: listData[i]);
  }
}
