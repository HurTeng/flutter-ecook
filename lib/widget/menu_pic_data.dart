import 'package:flutter/material.dart';
import './base_menu_data.dart';

class MenuPic extends BaseMenuData {
  final TextStyle titleTextStyle = new TextStyle(fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.bold); // 标题样式

  final Map<String, dynamic> itemData;
  final GestureTapCallback onTap;

  MenuPic({@required this.itemData, this.onTap});

  @override
  buildRowData(Map<String, dynamic> itemData) {
    return createRowData(itemData);
  }

/*  @override
  Widget build(BuildContext context) {
    return new InkWell(
      child: createRowData(itemData), // item控件
      onTap: () {
        onItemClick(itemData);
      }, // 点击事件
    );
  }*/

  // item数据
  Container createRowData(itemData) {
    return new Container(
      alignment: Alignment.center,
//      width: 300,
//      height: 200.0,
      margin: EdgeInsets.only(top: 6.0, bottom: 6.0),
      decoration: new BoxDecoration(
        // 装饰器
        color: Colors.white70,
        border: new Border.all(color: Colors.black12, width: 1.0), // 边线
        borderRadius: BorderRadius.all(Radius.circular(10.0)), // 圆角
      ),
      child: new Stack(
        children: <Widget>[
/*          new Image(
            image: getImageProvider(getImageUrl(itemData['imageid'])),
            width: 300.0,
            height: 200.0,
            fit: BoxFit.cover,
          ),*/
          createThumbImg(itemData), // 左侧图片控件
          new Positioned(// 相对位置
            left: 15.0,
            bottom: 15.0,
            child: createTitleWidget(itemData['name']) // 标题控件
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

  // 图片数据
  Container createThumbImg(itemData) {
    return new Container(
      width: double.infinity, // 无限大,填充满父控件
      height: 200.0,
      decoration: new BoxDecoration(
        // 装饰器
        shape: BoxShape.rectangle, // 形状
        image: new DecorationImage(
            image: getImageProvider(getImageUrl(itemData['imageid'])),
            fit: BoxFit.cover), // 图片
        borderRadius: BorderRadius.circular(10.0), // 左边圆角(也可以使用BorderRadius.only实现)
      ),
    );
  }
}
