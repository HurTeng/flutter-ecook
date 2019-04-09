import 'dart:async';
import 'dart:convert';
import 'package:ecook/widget/top_search_bar.dart';
import 'package:flutter/material.dart';
import '../common/api.dart';
import 'package:ecook/common/net_util.dart';
import '../widget/slide_view.dart';
import '../widget/slide_view_indicator.dart';
import '../widget/menu_row.dart';
import '../widget/menu_pic_data.dart';
import '../widget/menu_big_data.dart';
import '../widget/menu_collection_data.dart';

// 要创建一个自定义有状态widget，需创建两个类：StatefulWidget和State
// 状态对象包含widget的状态和build() 方法。
// 当widget的状态改变时，状态对象调用setState()，告诉框架重绘widget
class HomePage extends StatefulWidget {
  // 定义一个widget类，继承自StatefulWidget
  // Widget的状态可以通过多种方式进行管理,如果自身操作不会影响父窗口widget或其他用户界面，该widget可以在内部处理它自己的状态。
  // NewsListPage类管理自己的状态，因此它重写createState()来创建状态对象。 框架会在构建widget时调用createState()。
  // 在这个例子中，createState()创建_NewsListPageState的实例，然后在下一步中实现该实例。
  @override
  State<StatefulWidget> createState() => new _HomePageState();

//管理状态的最常见的方法：
//1.widget管理自己的state
//2.父widget管理 widget状态
//3.混搭管理（父widget和widget自身都管理状态））
//如何决定使用哪种管理方法？以下原则可以帮助您决定：
//
//如果状态是用户数据，如复选框的选中状态、滑块的位置，则该状态最好由父widget管理
//如果所讨论的状态是有关界面外观效果的，例如动画，那么状态最好由widget本身来管理.
//如果有疑问，首选是在父widget中管理状态
}

// 包含该widget状态并定义该widget build()方法的类，它继承自State.
// 自定义State类存储可变信息 - 可以在widget的生命周期内改变逻辑和内部状态。
class _HomePageState extends State<HomePage> {
  // 下划线'_'开头的成员或类是私有的
  final ScrollController _controller = new ScrollController(); // 滚动控制
  final TextStyle titleTextStyle = new TextStyle(fontSize: 16.0); // 标题样式
  final TextStyle subtitleStyle = new TextStyle(fontSize: 14.0, color: const Color(0xFFB5BDC0)); // 副标题样式

  var listData; // 列表数据
  var slideData; // 轮播图数据
  var curPage = 1; // 当前页面
  SlideView slideView; // 轮播组件
  SlideViewIndicator indicator; // 轮播图指示器
  var noMore = false;

  @override
  void initState() {
    // 初始化
    super.initState();
    _controller.addListener(() {
      // 添加滚动监听器
      var maxScroll = _controller.position.maxScrollExtent; // 最大滚动位置
      var pixels = _controller.position.pixels; // 像素
      if (maxScroll >= pixels && !noMore) {
        // scroll to bottom, get next page data
//        print("load more ... ");
        curPage++; // 页面+1
        _getHomeData(true); // 加载更多数据
      }
    });
    _getHomeData(false); // 首次加载
  }

  // 下拉刷新
  Future<Null> _pullToRefresh() async {
    curPage = 1; // 重置页面
    _getHomeData(false); // 加载数据
    return null;
  }

  // 状态对象定义了build方法
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: TopSearchBar(),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    // 无数据时，显示Loading
    if (listData == null) {
      return getCenter();
    } else {
      return createRefreshIndicator();
    }
  }

  Center getCenter() {
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
      controller: _controller,
    );

    return new Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: new RefreshIndicator(child: listView, onRefresh: _pullToRefresh));
//    return new RefreshIndicator(child: listView, onRefresh: _pullToRefresh);
  }

  Widget _buildLoadMoreIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: 1.0,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  // 从网络获取数据，isLoadMore表示是否是加载更多数据
  _getHomeData(bool isLoadMore) {
//    String url = Api.NEWS_LIST + "?pageIndex=$curPage&pageSize=10";
    String url = Api.getHomeData();
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
    var msg = map['data'];
    // data为数据内容，其中包含slide和news两部分，分别表示头部轮播图数据，和下面的列表数据
    var _listData = msg['recommendRecipes'];
    var _slideData = msg['banners'];

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
        if (list.isEmpty) {
          noMore = true;
        }
        _listData = list; // 重新赋值
      }
      listData = _listData; // 给列表数据赋值
      slideData = _slideData; // 轮播图数据
      initSlider(); // 初始化轮播组件
    });
  }

  // 初始化轮播组件
  void initSlider() {
    indicator = new SlideViewIndicator(slideData.length); // 指示器
    slideView = new SlideView(slideData, indicator); // 轮播控件
  }

  // 渲染列表数据
  Widget renderRow(i) {
    // 第一项(轮播图)
    if (i == 0) {
      return createSlideContainer();
    }
    i -= 1; // 减去第一项
    return new MenuRow(itemData: listData[i]);
  }

  // 轮播
  Container createSlideContainer() {
    return new Container(
      height: 180.0,
      child: new Stack(
        children: <Widget>[
          new Padding(padding: EdgeInsets.only(top: 10.0), child: slideView),
          new Container(
            alignment: Alignment.bottomCenter,
            child: indicator,
          )
        ],
      ),
    );
  }
}
