import 'dart:async';
import 'dart:convert';
import 'package:ecook/common/global_config.dart';
import 'package:flutter/material.dart';
import 'package:ecook/common/api.dart';
import 'package:ecook/common/net_util.dart';
import '../widget/menu_row.dart';
import '../list/menu_category_list.dart';

class HotPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new HotPageState();
}

class HotPageState extends State<HotPage> {
  final ScrollController _scrollController = new ScrollController(); // 滚动控制

  var listData; // 列表数据
  var slideData; // 轮播图数据
  var curPage = 1; // 当前页面
  var listTotalSize = 0; // 列表总数
  var lastId = "0"; // 最后一项的id
  var noMore = false;

  @override
  void initState() {
    // 初始化
    super.initState();
    _scrollController.addListener(() {
      // 添加滚动监听器
      var maxScroll = _scrollController.position.maxScrollExtent; // 最大滚动位置
      var pixels = _scrollController.position.pixels; // 像素
      if (maxScroll == pixels && !noMore) {
        // scroll to bottom, get next page data
//        print("load more ... ");
        curPage++; // 页面+1
        getNewsList(true); // 加载更多数据
      }
    });
    getNewsList(false); // 首次加载
  }

  // 下拉刷新
  Future<Null> _pullToRefresh() async {
    lastId = "0"; // 重置页面
    getNewsList(false); // 加载数据
    return null;
  }

  // 状态对象定义了build方法
  @override
  Widget build(BuildContext context) {
    // 无数据时，显示Loading
    if (listData == null) {
      return _getLoadingWidget();
    } else {
      return createRefreshIndicator();
    }
  }

  Widget _getLoadingWidget() {
    return new Center(
      // CircularProgressIndicator是一个圆形的Loading进度条
      child: new CircularProgressIndicator(),
    );
  }

  // 创建
  Widget createRefreshIndicator() {
    // 有数据，显示ListView
    Widget listView = new ListView.builder(
      itemCount: listData.length + 1,
      itemBuilder: (context, index) {
        if (index == listData.length) {
          return _buildLoadMoreIndicator();
        } else {
          return renderRow(index);
        }
      },
      controller: _scrollController,
    );
    return new Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: new RefreshIndicator(child: listView, onRefresh: _pullToRefresh),
    );
  }

  Widget _buildLoadMoreIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: 0.8,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  // 从网络获取数据，isLoadMore表示是否是加载更多数据
  getNewsList(bool isLoadMore) {
//    String url = Api.NEWS_LIST + "?pageIndex=$curPage&pageSize=10";
    String url = Api.getCategoryDishes(lastId, "hotest");
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
      lastId = listData[listData.length - 1]['id'];
    });
  }

  // 渲染列表数据
  Widget renderRow(i) {
    return new MenuRow(itemData: listData[i]);
/*    return new Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: new BoxDecoration(
          border: new BorderDirectional(
              bottom: new BorderSide(color: GlobalConfig.dark == true ? Colors.white12 : Colors.black12))),
      child: new MenuRow(itemData: listData[i]),
    );*/
  }
}
