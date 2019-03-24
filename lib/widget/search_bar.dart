import 'package:ecook/common/global_config.dart';
import 'package:ecook/page/search_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _SearchBar();
}

class _SearchBar extends State<SearchBar> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return barSearch();
  }

  Widget barSearch() {
    return new Container(
        decoration: new BoxDecoration(
            borderRadius: const BorderRadius.all(const Radius.circular(4.0)),
            color: GlobalConfig.searchBackgroundColor),
        child: new FlatButton(
            onPressed: () {
              Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
                return new SearchPage();
              }));
            },
            child: new Row(
              children: <Widget>[
                new Container(
                  child: new Icon(
                    Icons.search,
                    size: 18.0,
                  ),
                  margin: const EdgeInsets.only(right: 26.0),
                ),
                new Expanded(
                    child: new Container(
                  child: new Text("搜索菜谱"),
                )),
                new Container(
                  child: new FlatButton(
                    onPressed: () {},
                    child: new Icon(Icons.close, size: 18.0),
                  ),
                  width: 40.0,
                ),
              ],
            )));
  }
}
