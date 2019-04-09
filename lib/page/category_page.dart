import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ecook/common/api.dart';
import 'package:ecook/common/net_util.dart';
import '../list/menu_category_collection.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

class CategoryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new CategoryPageState();
}

class CategoryPageState extends State<CategoryPage> {
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
    if (categoryList == null || categoryList.isEmpty) {
      return getCenter();
    } else {
//      return createRefreshIndicator();
      return createGrid();
    }
  }

  Center getCenter() {
    return new Center(
      // CircularProgressIndicator是一个圆形的Loading进度条
      child: new CircularProgressIndicator(),
    );
  }

  // 创建
  ListView createRefreshIndicator() {
    return new ListView.builder(
      itemCount: categoryList.length,
      itemBuilder: (context, i) => renderRow(i),
      controller: _controller,
    );
  }

  GridView createGrid() {
    return GridView.count(
        crossAxisCount: 2,
        scrollDirection: Axis.vertical,
        // 滚动方向
        crossAxisSpacing: 5.0,
        // 左右间隔
        mainAxisSpacing: 5.0,
        // 上下间隔
        childAspectRatio: 1 / 1,
        //宽高比
        children: initListWidget());
  }

  List<Widget> initListWidget() {
    return new List.generate(categoryList.length, (index) {
      return renderRow(index);
    });
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

  // 渲染列表数据
  Widget renderRow(index) {
//    return createRowData(categoryList[index]);
    var data = categoryList[index];
    return GestureDetector(
        child: createRowData(data), onTap: () => onItemClick(data));
  }

  Widget getStickyWidget() {
    return new SliverStickyHeader(
      header: new Container(
        height: 60.0,
        color: Colors.lightBlue,
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        alignment: Alignment.centerLeft,
        child: new Text(
          'Header #0',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      sliver: new SliverList(
        delegate: new SliverChildBuilderDelegate(
          (context, i) => new ListTile(
                leading: new CircleAvatar(
                  child: new Text('0'),
                ),
                title: new Text('List tile #$i'),
              ),
          childCount: 4,
        ),
      ),
    );
  }

  // item数据
  Container createRowData(itemData) {
    return new Container(
      width: 100,
      height: 120.0,
      alignment: Alignment.center,
      margin: EdgeInsets.all(6),
      decoration: new BoxDecoration(
        // decoration,color不能共存
        color: Colors.white70,
        border: new Border.all(color: Colors.black12, width: 1.0), // 边线
        borderRadius: BorderRadius.all(Radius.circular(10.0)), // 圆角
      ),
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          createThumbImg(itemData), // 左侧图片控件
          createTitleWidget(itemData['name']), // 标题控件
        ],
      ), // item控件
    );
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

  // 图片数据
  Container createThumbImg(itemData) {
    return new Container(
      width: 80.0, // 无限大,填充满父控件
      height: 80.0,
      child: new Image.network(getImageUrl(itemData['icon'])),
      decoration: new BoxDecoration(
        shape: BoxShape.rectangle, // 形状
        image: new DecorationImage(
            image: new NetworkImage(getImageUrl(itemData['icon']))), // 图片
        borderRadius:
            BorderRadius.circular(10.0), // 左边圆角(也可以使用BorderRadius.only实现)
      ),
    );
  }

  void onItemClick(itemData) {
//    var url = itemData['detailUrl'];
    var id = itemData['id'];
    var title = itemData['name'];
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (ctx) => new MenuCategoryCollection(id, title)));
  }
}
