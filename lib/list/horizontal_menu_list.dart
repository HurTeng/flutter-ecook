import 'package:ecook/common/global_config.dart';
import 'package:flutter/material.dart';
import '../widget/menu_row.dart';
import 'dart:convert';
import 'package:ecook/common/api.dart';
import 'package:ecook/common/net_util.dart';

class HorizontalMenuList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _HorizontalMenuList();

  var listData; // 列表数据
  MenuDataList(listData) {
    this.listData = listData;
  }
}

class _HorizontalMenuList extends State<HorizontalMenuList> {
  var listData; // 列表数据

  @override
  void initState() {
    super.initState();
    _getMenuList();
  }

  @override
  Widget build(BuildContext context) {
    if (listData == null) {
      return new Container();
    } else {
      return createRefreshIndicator();
    }
  }

  // 创建
  Widget createRefreshIndicator() {
    return new Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
/*      child: new ListView.builder(
        itemCount: listData.length,
        itemBuilder: (context, index) => new MenuRow(itemData: listData[index]),
      ),*/
      child: new SingleChildScrollView(
        child: new Container(
          child: new Column(
            children: <Widget>[videoCard(), ideaCard()],
          ),
        ),
      ),
    );
  }

  _getMenuList() {
    String url = Api.getCategoryDishes("0", "hotest");
    NetUtils.get(url).then((data) {
      if (data == null) {
        return;
      }
      // 将接口返回的json字符串解析为map类型
      Map<String, dynamic> map = json.decode(data);
      // code=0表示请求成功
      if (map['state'] != '200') {
        return;
      }

      // 设置数据
      setState(() {
        listData = map['list'];
      });
    });
  }

  Widget videoCard() {
    return new Container(
        color: GlobalConfig.cardBackgroundColor,
        margin: const EdgeInsets.only(top: 6.0, bottom: 6.0),
        padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
        child: new Column(
          children: <Widget>[
            new Container(
                margin: const EdgeInsets.only(left: 16.0, bottom: 20.0),
                child: new Row(
                  children: <Widget>[
                    new Container(
                      child: new CircleAvatar(
                        radius: 20.0,
                        child: new Icon(Icons.videocam, color: Colors.white),
                        backgroundColor: new Color(0xFFB36905),
                      ),
                    ),
                    new Expanded(
                      child: new Container(
                        margin: const EdgeInsets.only(left: 8.0),
                        child: new Text(
                          "热门兴趣",
                          style: new TextStyle(fontSize: 18.0),
                        ),
                      ),
                    ),
                    new Container(
                      child: new FlatButton(
                          onPressed: () {},
                          child: new Text(
                            "更多>",
                            style: new TextStyle(color: Colors.grey),
                          )),
                    )
                  ],
                )),
            new Container(
              margin: const EdgeInsets.only(left: 16.0),
              child: new SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: new Row(
                  children: buildASList(),
                ),
              ),
            )
          ],
        ));
  }

  List<Widget> buildASList() {
    List<Widget> tiles = [];
    for (var item in listData) {
      tiles.add(new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[getItemContainer(getImageUrl(item['imageid']))]));
      tiles.add(new Divider(height: 20.0));
    }
    return tiles;
  }

  Widget ideaCard() {
    return new Container(
        color: GlobalConfig.cardBackgroundColor,
        margin: const EdgeInsets.only(top: 6.0, bottom: 6.0),
        padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
        child: new Column(
          children: <Widget>[
            new Container(
                margin: const EdgeInsets.only(left: 16.0, bottom: 20.0),
                child: new Row(
                  children: <Widget>[
                    new Container(
                      child: new CircleAvatar(
                        radius: 20.0,
                        child: new Icon(Icons.all_inclusive, color: Colors.white),
                        backgroundColor: Colors.blue,
                      ),
                    ),
                    new Expanded(
                      child: new Container(
                        margin: const EdgeInsets.only(left: 8.0),
                        child: new Text(
                          "菜谱推荐",
                          style: new TextStyle(fontSize: 18.0),
                        ),
                      ),
                    ),
                    new Container(
                      child: new FlatButton(
                          onPressed: () {},
                          child: new Text(
                            "更多>",
                            style: new TextStyle(color: Colors.grey),
                          )),
                    )
                  ],
                )),
            new Container(
              margin: const EdgeInsets.only(left: 16.0),
              child: new SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: new Row(
                  children: buildMaterialList(),
                ),
              ),
            )
          ],
        ));
  }

  List<Widget> buildMaterialList() {
    List<Widget> tiles = [];
    for (var item in listData) {
      tiles.add(new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[getIdeaItemContainer(item['name'], item['description'], getAvatarUrl(item['imageid']))]));
      tiles.add(new Divider(height: 20.0));
    }
    return tiles;
  }

  Container getItemContainer(url) {
    return new Container(
        width: MediaQuery.of(context).size.width / 2.5,
        margin: const EdgeInsets.only(right: 6.0),
        child: new AspectRatio(
            aspectRatio: 4.0 / 2.0,
            child: new Container(
              foregroundDecoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: new NetworkImage(url),
                    centerSlice: new Rect.fromLTRB(270.0, 180.0, 1360.0, 730.0),
                  ),
                  borderRadius: const BorderRadius.all(const Radius.circular(6.0))),
            )));
  }

  Container getIdeaItemContainer(title, desc, image) {
    return new Container(
        margin: const EdgeInsets.only(right: 6.0),
        decoration: new BoxDecoration(
            color: GlobalConfig.searchBackgroundColor, borderRadius: new BorderRadius.all(new Radius.circular(6.0))),
        child: new Row(
          children: <Widget>[
            new Container(
              padding: const EdgeInsets.only(left: 10.0),
              child: new Column(
                children: <Widget>[
                  new Align(
                    alignment: Alignment.centerLeft,
                    child: new Container(
                      child: new Text(
                        title,
                        style: new TextStyle(
                            color: GlobalConfig.dark == true ? Colors.white70 : Colors.black, fontSize: 16.0),
                      ),
                    ),
                  ),
                  new Align(
                      alignment: Alignment.centerLeft,
                      child: new Container(
                        width: 100,
                        margin: const EdgeInsets.only(top: 6.0),
                        child: new Text(
                          desc,
                          softWrap: true, // 换行
                          maxLines: 2, // 最大行数
                          overflow: TextOverflow.ellipsis, // 超出显示省略号
                          style: new TextStyle(color: GlobalConfig.fontColor),
                        ),
                      ))
                ],
              ),
            ),
            new Container(
                margin: const EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width / 5,
                child: new AspectRatio(
                    aspectRatio: 1.0 / 1.0,
                    child: new Container(
                      foregroundDecoration: new BoxDecoration(
                          image: new DecorationImage(
                            image: new NetworkImage(image),
                            centerSlice: new Rect.fromLTRB(270.0, 180.0, 1360.0, 730.0),
                          ),
                          borderRadius: const BorderRadius.all(const Radius.circular(6.0))),
                    )))
          ],
        ));
  }

  String getImageUrl(imageId) {
    return 'http://pic.ecook.cn/web/' + imageId + '.jpg!m4';
  }

  String getAvatarUrl(imageId) {
    return 'http://pic.ecook.cn/web/' + imageId + '.jpg!s1';
  }
}
