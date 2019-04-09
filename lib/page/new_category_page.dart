import 'package:ecook/common/api.dart';
import 'package:ecook/common/net_util.dart';
import 'package:ecook/list/menu_category_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'dart:convert';

class CategoryPage extends StatefulWidget {
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  var listIndex = 0;
  List categoryList;
  List childList;

  @override
  void initState() {
    super.initState();
    getCategoryList();
  }

  void getCategoryList() {
    var url = Api.getCategory();
    NetUtils.get(url).then((data) {
      if (data == null) {
        return;
      }

      // 解析json字符串
      Map<String, dynamic> map = json.decode(data);
      if (map['state'] != '200') {
        return;
      }

      // 设置数据
      setState(() {
        categoryList = map['list'];
        childList = getCurrentSubCategoryList();
      });
    });
  }

  getCurrentSubCategoryList() {
    return categoryList[listIndex]['list'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('菜谱分类')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    // 无数据时，显示Loading
    if (categoryList == null) {
      return _getLoadingWidget();
    } else {
      return _createContent();
    }
  }

  Widget _getLoadingWidget() {
    return new Center(
      child: new CircularProgressIndicator(),
    );
  }

  Widget _createContent() {
    return Container(
      child: Row(
        children: <Widget>[
          buildLeftCategoryNav(),
          Expanded(
            child: Column(
              children: <Widget>[buildCategoryGoodsList()],
            ),
          )
        ],
      ),
    );
  }

  Container buildLeftCategoryNav() {
    return Container(
      width: 100,
      child: ListView.builder(
        itemCount: categoryList.length,
        itemBuilder: (context, index) {
          return _leftInkWel(index);
        },
      ),
    );
  }

  Widget _leftInkWel(int index) {
    bool isClick = index == listIndex;
    var categoryName = categoryList[index]['name'];
    var itemColor = isClick ? Colors.white10 : Colors.white;

    return InkWell(
      onTap: () {
        setState(() {
          listIndex = index;
          childList = getCurrentSubCategoryList();
        });
      },
      child: Container(
        color: itemColor,
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15.0),
            decoration: BoxDecoration(
                color: itemColor,
                border: Border(left: BorderSide(width: 3, color: isClick ? Colors.orangeAccent : Colors.white10))),
            child: Text(
              categoryName,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            )),
      ),
    );
  }

  SubCategoryMenuList buildCategoryGoodsList() {
    return SubCategoryMenuList(childList);
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
}

// 子分类列表
class SubCategoryMenuList extends StatelessWidget {
  List<dynamic> categoryList;
  BuildContext _context;

  SubCategoryMenuList(this.categoryList);

  var scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    _context = context;
    if (categoryList.length > 0) {
      return buildContent(categoryList);
    } else {
      return Text('暂时没有数据');
    }
  }

  Expanded buildContent(list) {
    return Expanded(
      child: Container(
        width: double.infinity,
        child: createGrid(),
      ),
    );
  }

  GridView createGrid() {
    return GridView.count(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        crossAxisCount: 2,
        scrollDirection: Axis.vertical,
        // 滚动方向
//        crossAxisSpacing: 5.0,
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

  // 渲染列表数据
  Widget renderRow(index) {
    var data = categoryList[index];
    return GestureDetector(child: createRowData(data), onTap: () => onItemClick(data));
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
      width: 50.0, // 无限大,填充满父控件
      height: 50.0,
      child: new Image.network(getImageUrl(itemData['icon'])),
      decoration: new BoxDecoration(
        shape: BoxShape.rectangle, // 形状
        image: new DecorationImage(image: new NetworkImage(getImageUrl(itemData['icon']))), // 图片
        borderRadius: BorderRadius.circular(10.0), // 左边圆角(也可以使用BorderRadius.only实现)
      ),
    );
  }

  void onItemClick(itemData) {
    var id = itemData['id'];
    var title = itemData['name'];
    Navigator.push(_context, new MaterialPageRoute(builder: (ctx) => new MenuCategoryCollection(id, title)));
  }

  String getImageUrl(imageId) {
    return "http://pic.ecook.cn/web/$imageId.jpg!s1";
  }
}
