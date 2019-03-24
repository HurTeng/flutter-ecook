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
      title: "ecook", // 标题
      theme: new ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: new Index(), // 首页控件
/*      routes: <String, WidgetBuilder> {
        '/hot': (BuildContext context) => new HotPage(),
        '/category': (BuildContext context) => new CategoryPage(),
        '/my': (BuildContext context) => new MyPage(),
        '/detail': (BuildContext context) => new MenuDetailPage(),
        '/menuCollection': (BuildContext context) => new MyPage(),
        '/collectionSort': (BuildContext context) => new MyPage(),
      },*/
    );
  }
}
