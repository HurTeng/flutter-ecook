import 'package:flutter/material.dart';
import './base_menu_data.dart';

class MenuCollectionData extends BaseMenuData {
  final TextStyle titleTextStyle = new TextStyle(fontSize: 16.0); // 标题样式

  final Map<String, dynamic> itemData;
  final GestureTapCallback onTap;

  MenuCollectionData({@required this.itemData, this.onTap});

  @override
  buildRowData(Map<String, dynamic> itemData) {
    return createRowData(itemData);
  }

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      child: createRowData(itemData), // item控件
    );
  }


  // item数据
  Container createRowData(itemData) {
    return new Container(
      height: 280.0,
      margin: EdgeInsets.only(top: 6.0, bottom: 6.0),
      decoration: new BoxDecoration(
        // 装饰器
        color: Colors.white70,
        border: new Border.all(color: Colors.black12, width: 1.0), // 边线
        borderRadius: BorderRadius.all(Radius.circular(10.0)), // 圆角
      ),
      child: new Column(
        children: <Widget>[
          new Stack(children: <Widget>[
            createThumbImg(itemData), // 左侧图片控件
            new Positioned(
                right: 15.0,
                top: 15.0,
                child: createCountWidget(itemData['name']) // 标题控件
                ),
          ]),
          new Expanded(
            // 描述信息
            child: new Container(
              padding: const EdgeInsets.all(8.0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  createTitleWidget(itemData['name']), // 标题控件
                  createTimeRow(itemData), // 作者信息控件
                ],
              ),
            ),
          ),
        ],
      ), // item控件
    );
  }

  // 标题控件
  Text createTitleWidget(String title) {
    return new Text(
      title,
      style: titleTextStyle,
      maxLines: 1, // 最大行数
      overflow: TextOverflow.ellipsis, // 超出隐藏
    );
  }

  Container createCountWidget(String count) {
    return new Container(
        child: new Text(
          count,
          style: new TextStyle(
              fontSize: 12.0, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5), // 也可使用(EdgeInsets.only实现)
        decoration: new BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(20)), // 圆角
        ));
  }

  // 事件数据
  Row createTimeRow(itemData) {
    return new Row(
      children: <Widget>[
        new Container(
          width: 30.0,
          height: 30.0,
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFECECEC),
            image: new DecorationImage(
                image:
                    new NetworkImage(getAvatarUrl(itemData['user']['imageid'])),
                fit: BoxFit.cover),
            border: new Border.all(color: const Color(0xFFECECEC), width: 2.0),
          ),
        ),
        new Expanded(
          child: new Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
            child: new Text(
              itemData['user']['nickname'],
              style: subtitleStyle,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        )
      ],
    );
  }

  // 图片数据
  Container createThumbImg(itemData) {
    return new Container(
      width: double.infinity,
      height: 200.0,
      decoration: new BoxDecoration(
        // 装饰器
        shape: BoxShape.rectangle, // 形状
        image: new DecorationImage(
            image: getImageProvider(getImageUrl(itemData['imageid'])),
            fit: BoxFit.cover), // 图片
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(10.0)), // 左边圆角(也可以使用BorderRadius.only实现)
      ),
    );
  }
}
