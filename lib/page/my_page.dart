import 'package:flutter/material.dart';
import 'package:ecook/common/global_config.dart';
import 'package:ecook/page/search_page.dart';
import '../list/menu_data_list.dart';
import '../common/storage.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => new _MyPageState();
}

class _MyPageState extends State<MyPage> {
  List historyList = new List();
  List collectionList = new List();

  @override
  void initState() {
    super.initState();
    _getStorageList();
  }

  Widget barSearch() {
    return new Container(
        child: new Row(
          children: <Widget>[getSearchBar()],
        ),
        decoration: new BoxDecoration(
          borderRadius: const BorderRadius.all(const Radius.circular(4.0)),
          color: GlobalConfig.searchBackgroundColor,
        ));
  }

  Expanded getSearchBar() {
    return new Expanded(
        child: new FlatButton.icon(
      onPressed: () {
        Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
          return new SearchPage();
        }));
      },
      icon: new Icon(Icons.search, color: GlobalConfig.fontColor, size: 16.0),
      label: new Text(
        "搜索菜谱",
        style: new TextStyle(color: GlobalConfig.fontColor),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 3,
      child: new Scaffold(
        appBar: new AppBar(
          title: barSearch(),
          bottom: new TabBar(
            indicatorWeight: 4.0,
            indicatorColor: Colors.orange,
            labelColor: // 选中颜色
                GlobalConfig.dark == true ? new Color(0xFF63FDD9) : Colors.orange,
            unselectedLabelColor: // 未选中颜色
                GlobalConfig.dark == true ? Colors.white : Colors.black,
            tabs: [
              // 顶部tab切换栏
              new Tab(text: "历史"),
              new Tab(text: "收藏"),
            ],
            onTap: (index) {
              setState(() {
                _getStorageList();
              });
            },
          ),
        ),
        body: new TabBarView(children: [new MenuDataList(historyList), new MenuDataList(collectionList)]),
      ),
    );
  }

  void _getStorageList() {
    historyList = Storage.instance.getHistoryList();
    collectionList = Storage.instance.getCollectionList();
  }
}
