import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ecook/common/api.dart';
import 'package:ecook/common/net_util.dart';
import '../widget/menu_row.dart';
import '../list/menu_category_list.dart';

class CategoryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final ScrollController _controller = new ScrollController(); // 滚动控制

  var categoryList = new List(); // 列表数据

  @override
  void initState() {
    super.initState();
    getCategoryList();
  }

  void getCategoryList() {
    var url = Api.getCategory();
    print(url);
    NetUtils.get(url).then((data) {
      if (data == null) {
        return;
      }
      print(data);
      // 将接口返回的json字符串解析为map类型
      Map<String, dynamic> map = json.decode(data);
      // code=0表示请求成功
      if (map['state'] != '200') {
        return;
      }

      // 设置数据
      setupData(map);
    });
  }

  // 状态对象定义了build方法
  @override
  Widget build(BuildContext context) {
    // 无数据时，显示Loading
    if (categoryList == null) {
      return getCenter();
    } else {
      return new MenuCategoryList('');
    }
  }

  Center getCenter() {
    new Center(
      // CircularProgressIndicator是一个圆形的Loading进度条
      child: new CircularProgressIndicator(),
    );
  }


  void setupData(Map<String, dynamic> map) {
    var _listData = map['list'];
    // 当widget的状态改变时，状态(State)对象调用setState()，告诉框架重绘widget
    setState(() {
      for (var item in _listData) {
        print(item);
        for (var data in item['list']) {
          print(data);
          categoryList.add(data);
        }
      }
    });
  }

  String getImageUrl(imageId) {
    return "http://pic.ecook.cn/web/$imageId.jpg!s1";
  }

  // 标题控件
  Text createTitleWidget(String title) {
    return new Text(
      title,
      style: new TextStyle(fontSize: 18.0),
      maxLines: 1, // 最大行数
      overflow: TextOverflow.ellipsis, // 超出隐藏
    );
  }

}
