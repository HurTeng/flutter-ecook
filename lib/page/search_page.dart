import 'dart:convert';

import 'package:ecook/common/api.dart';
import 'package:ecook/list/menu_data_list.dart';
import 'package:ecook/common/net_util.dart';
import 'package:ecook/widget/menu_row.dart';
import 'package:flutter/material.dart';
import 'package:ecook/common/global_config.dart';
import '../common/storage.dart';

class SearchPage extends StatefulWidget {
  @override
  SearchPageState createState() => new SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  TextEditingController _textEditingController = new TextEditingController();
  bool isShowSearchList = true;
  bool isEmptyInput = true;

  @override
  void initState() {
    super.initState();
    _getHotList();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        theme: GlobalConfig.themeData,
        home: new Scaffold(appBar: new AppBar(title: buildSearchInput()), body: buildContainer()));
  }

  // 搜索框
  Widget buildSearchInput() {
    return new Container(
      decoration: new BoxDecoration(
          borderRadius: const BorderRadius.all(const Radius.circular(4.0)), color: GlobalConfig.searchBackgroundColor),
      child: new Row(
        children: <Widget>[
          buildBackWidget(),
          buildInputTet(),
          buildClearInputButton(),
        ],
      ),
    );
  }

  Container buildBackWidget() {
    return new Container(
      child: new FlatButton.icon(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: new Icon(Icons.arrow_back, color: GlobalConfig.fontColor),
        label: new Text(""),
      ),
      width: 60.0,
    );
  }

  Expanded buildInputTet() {
    return new Expanded(
      child: new TextField(
          autofocus: true,
          decoration:
              new InputDecoration.collapsed(hintText: "搜索菜谱", hintStyle: new TextStyle(color: GlobalConfig.fontColor)),
          controller: _textEditingController,
          // 内容改变的回调
          onChanged: (text) {
            print('change $text');
          },
          // 内容提交的回调
          onSubmitted: (text) {
            print('submit $text');
            setState(() {
              _searchMenu(text);
            });
          }),
    );
  }

  Widget buildClearInputButton() {
    return new Container(
      child: new GestureDetector(
        onTap: () {
          print(_textEditingController.text);
          setState(() {
            _clearSearch();
          });
        },
        child: new Icon(Icons.close, color: GlobalConfig.fontColor, size: 20.0),
      ),
      margin: EdgeInsets.only(right: 15.0),
    );
  }

  SingleChildScrollView buildContainer() {
    return new SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: new Column(
        children: <Widget>[
          buildHotSearchList(),
          buildHistorySearchList(),
          buildBrowseList(),
        ],
      ),
    );
  }

  Widget buildHotSearchList() {
    var titleItem = buildTitleItem('热门搜索', Icons.whatshot, new Container());
    List<String> hotList = Storage.instance.getHotSearchList();
    if (hotList == null || hotList.isEmpty) {
      return new Container(child: titleItem);
    }

    List<Widget> widgets = [];
    widgets.add(titleItem); // 标题
    for (var keyword in hotList) {
      widgets.add(buildKeywordItem(keyword));
    }
    return new Wrap(children: widgets);
  }

  Widget buildHistorySearchList() {
    List<String> historyList = Storage.instance.getHistorySearchList();
    if (historyList == null || historyList.isEmpty) {
      return new Container();
    }

    List<Widget> widgets = [];
    var titleItem = buildTitleItem('历史搜索', Icons.access_time, buildDeleteWidget(_deleteSearchHistory()));
    widgets.add(titleItem);
    for (var keyword in historyList) {
      widgets.add(buildKeywordItem(keyword));
    }
    return new Wrap(children: widgets);
  }

  buildBrowseList() {
    List browseHistoryList = Storage.instance.getHistoryList();
    if (browseHistoryList == null || browseHistoryList.isEmpty) {
      return new Container();
    }

    List<Widget> widgets = [];
    var titleItem = buildTitleItem('浏览历史', Icons.remove_red_eye, buildDeleteWidget(_deleteBrowseHistory()));
    widgets.add(titleItem);
    for (var data in browseHistoryList) {
      widgets.add(new MenuRow(itemData: data));
    }
    return new Wrap(children: widgets);
  }

  Container buildTitleItem(String title, var icon, Widget deleteWidget) {
    return new Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
      child: new Row(
        children: <Widget>[
          new Container(
            child: new Icon(icon, color: Colors.orangeAccent, size: 20.0),
            margin: const EdgeInsets.only(right: 10.0),
          ),
          new Expanded(
            child: new Container(
              child: new Text(
                title,
                style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          deleteWidget,
        ],
      ),
    );
  }

  // 删除按钮
  Widget buildDeleteWidget(Function onTapEvent) {
    return new GestureDetector(
      onTap: () {
        setState(onTapEvent);
      },
      child: new Icon(Icons.delete, color: GlobalConfig.fontColor, size: 20.0),
    );
  }

  // 关键字的item
  Container buildKeywordItem(String keyword) {
    return new Container(
      margin: const EdgeInsets.only(left: 5.0),
      child: new FlatButton(
          color: GlobalConfig.dark == true ? Colors.white10 : Colors.white70,
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
          onPressed: () {
            setState(() {
              _textEditingController.text = keyword;
              _searchMenu(keyword);
            });
          },
          child: new Text(
            keyword,
            style: new TextStyle(color: GlobalConfig.fontColor),
          )),
    );
  }

  void _searchMenu(String keyword) {
    // 关键字不为空的时候才处理
    if (keyword.trim().length > 0) {
      isShowSearchList = false; // 不显示搜索关键字列表
      Storage.instance.addIntoHistorySearchList(keyword); // 将该关键字加入历史列表
      _obtainMenuList(keyword); // 获取菜式列表
    }
  }

  // 根据关键字获取菜式列表
  _obtainMenuList(keyword) {
    if (keyword.trim().length > 0) {
//      Navigator.of(context).push(new MaterialPageRoute(builder: (ctx) => new MenuDetailPage(keyword: keyword))); // 跳转到详情页面
    }
  }

  _getHotList() {
    var api = Api.getHotSearchKeywords();
    NetUtils.get(api).then((data) {
      if (data == null) {
        return;
      }

      // 数据列表不为空,设置数据
      var _keywords = new List<String>.from(json.decode(data)['list']);
      if (_keywords != null && _keywords.isNotEmpty) {
        setState(() {
          Storage.instance.saveHotSearchList(_keywords); // 保存到本地
        });
      }
    });
  }

  // 清除搜索
  _clearSearch() {
    _textEditingController.clear(); // 清除字符串
    isShowSearchList = true; // 显示搜索关键字列表
  }

  // 删除历史搜索
  Function _deleteSearchHistory() {
    return () {
      // 匿名函数
      Storage.instance.deleteHistorySearchList(); // 清除本地历史搜索的缓存记录
    };
  }

  Function _deleteBrowseHistory() {
    delete() {
      Storage.instance.deleteHistoryList(); // 清除本地历史搜索的缓存记录
    }

    return delete;
  }
}
