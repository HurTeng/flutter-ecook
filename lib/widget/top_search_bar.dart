import 'package:ecook/common/global_config.dart';
import 'package:ecook/page/search_page.dart';
import 'package:flutter/material.dart';

class TopSearchBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return _SearchBar(context);
  }

  Widget _SearchBar(BuildContext context) {
    return new Container(
        child: new Row(
          children: <Widget>[getSearchBar(context)],
        ),
        decoration: new BoxDecoration(
          borderRadius: const BorderRadius.all(const Radius.circular(4.0)),
          color: GlobalConfig.searchBackgroundColor,
        ));
  }

  Expanded getSearchBar(BuildContext context) {
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
}