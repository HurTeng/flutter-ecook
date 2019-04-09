import 'package:ecook/page/category_list_page.dart';
import 'package:ecook/page/home_page.dart';
import 'package:ecook/page/hot_page.dart';
import 'package:ecook/page/menu_detail_page.dart';
import 'package:ecook/page/my_page.dart';
import 'package:ecook/page/search_page.dart';
import 'package:flutter/material.dart';
import './common/sp_util.dart';
import 'package:ecook/page/index.dart';

void main() {
  runApp(new App());
}

class App extends StatelessWidget {

  App() {
    SpUtil.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "ecook",
      theme: new ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: new Index(),
      routes: <String, WidgetBuilder> {
        '/home': (BuildContext context) => new HomePage(),
        '/hot': (BuildContext context) => new HotPage(),
        '/category': (BuildContext context) => new CategoryPage(),
        '/my': (BuildContext context) => new MyPage(),
        '/detail': (BuildContext context) => new MenuDetailPage(),
        '/search': (BuildContext context) => new SearchPage(),
      },
      navigatorObservers: [
        MyObserver(),
      ],
    );
  }
}

class MyObserver extends NavigatorObserver{
  @override
  void didPush(Route route, Route previousRoute) {
    super.didPush(route, previousRoute);
    print(route.settings.name);
    print(route.currentResult); // result content
  }
}