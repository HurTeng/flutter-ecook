import 'package:flutter/material.dart';
import 'package:ecook/widget/navigation_icon_view.dart';
import 'package:ecook/common/global_config.dart';
import '../page/my_page.dart';
import 'package:ecook/page/home_page.dart';
import '../page/hot_page.dart';
import '../page/new_category_page.dart';

class Index extends StatefulWidget {

  @override
  State<Index> createState() => new _IndexState();
}

class _IndexState extends State<Index> with TickerProviderStateMixin{

  int _currentIndex = 0;
  List<NavigationIconView> _navigationViews;
  List<StatefulWidget> _pageList;
  StatefulWidget _currentPage;

  @override
  void initState() {
    super.initState();
    _navigationViews = <NavigationIconView>[
      new NavigationIconView(
        icon: new Icon(Icons.home),
        title: new Text("首页"),
        vsync: this,
      ),
      new NavigationIconView(
        icon: new Icon(Icons.whatshot),
        title: new Text("热门"),
        vsync: this,
      ),
      new NavigationIconView(
        icon: new Icon(Icons.category),
        title: new Text("分类"),
        vsync: this,
      ),
      new NavigationIconView(
        icon: new Icon(Icons.perm_identity),
        title: new Text("我的"),
        vsync: this,
      )
    ];
    for (NavigationIconView view in _navigationViews) {
      view.controller.addListener(_rebuild);
    }

    _pageList = <StatefulWidget>[
      new HomePage(),
      new HotPage(),
      new CategoryPage(),
      new MyPage(),
    ];
    _currentPage = _pageList[_currentIndex];
  }

  void _rebuild() {
    setState((){});
  }

  @override
  void dispose() {
    super.dispose();
    for (NavigationIconView view in _navigationViews) {
      view.controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBar bottomNavigationBar = new BottomNavigationBar(
        items: _navigationViews
            .map((NavigationIconView navigationIconView) => navigationIconView.item)
            .toList(),
      currentIndex: _currentIndex,
      fixedColor: Colors.orange,
      type: BottomNavigationBarType.fixed,
      onTap: (int index) {
        setState((){
          _navigationViews[_currentIndex].controller.reverse();
          _currentIndex = index; // 当前索引值
          _navigationViews[_currentIndex].controller.forward();
          _currentPage = _pageList[_currentIndex]; // 当前页面
        });
      }
    );

    return new MaterialApp(
      home: new Scaffold(
        body: new Center(
            child: _currentPage
        ),
        bottomNavigationBar: bottomNavigationBar,
      ),
      theme: GlobalConfig.themeData
    );
  }

}