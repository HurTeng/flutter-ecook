import 'package:flutter/material.dart';
import './base_menu_data.dart';

class MenuRow extends BaseMenuData {
  final TextStyle titleTextStyle = new TextStyle(fontSize: 16.0); // 标题样式
  final TextStyle subtitleStyle = new TextStyle(fontSize: 14.0, color: const Color(0xFFB5BDC0)); // 副标题样式

  final Map<String, dynamic> itemData;
  final MaterialColor color;
  final GestureTapCallback onTap;

  MenuRow({@required this.itemData, this.color = Colors.grey, this.onTap}) : super(itemData: itemData, onTap: onTap);

  @override
  buildRowData(Map<String, dynamic> itemData) {
    return createRowData(itemData);
  }

  // item数据
  Container createRowData(itemData) {
    return new Container(
      height: 120.0,
      margin: EdgeInsets.only(top: 6.0, bottom: 6.0),
      decoration: new BoxDecoration(
        color: Colors.white,
        border: new Border.all(color: Colors.black12, width: 1.0), // 边线
        borderRadius: BorderRadius.all(Radius.circular(10.0)), // 圆角
        boxShadow: [
          // 阴影位置由offset决定,延伸的阴影，向右下偏移的距离
          // 阴影模糊层度由blurRadius大小决定（大就更透明更扩散），延伸距离,会有模糊效果
          // 阴影模糊大小由spreadRadius决定,延伸距离,不会有模糊效果
          BoxShadow(color: Color(0x88888888), offset: Offset(1.0, 5.0), blurRadius: 2.0, spreadRadius: 1.0),
        ],
      ),
      child: new Row(
        children: <Widget>[
          createThumbImg(itemData), // 左侧图片控件
          new Expanded(
            // 描述信息
            child: new Container(
              padding: const EdgeInsets.all(8.0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  createTitleWidget(itemData['name']), // 标题控件
                  createSubTitleWidget(itemData['description']), // 描述信息控件
                  createTimeRow(itemData), // 时间控件
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

  // 副标题控件
  Text createSubTitleWidget(String title) {
    return new Text(title,
        style: subtitleStyle,
        softWrap: true, // 换行
        maxLines: 2, // 最大行数
        overflow: TextOverflow.ellipsis // 超出显示省略号
        );
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
                image: new NetworkImage(getAvatarUrl(itemData['user']['imageid'])), fit: BoxFit.cover),
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
        ),

/*        new Expanded(
          flex: 1,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              new Text("${itemData['materials']}", style: subtitleStyle),
              new Image.asset('./images/ic_comment.png',
                  width: 16.0, height: 16.0),
            ],
          ),
        )*/
      ],
    );
  }

  // 图片数据
  Container createThumbImg(itemData) {
    return new Container(
      width: 150.0,
//      height: 100.0,
      decoration: new BoxDecoration(
        // 装饰器
        shape: BoxShape.rectangle, // 形状
        image: new DecorationImage(image: getImageProvider(getImageUrl(itemData['imageid'])), fit: BoxFit.cover), // 图片
        borderRadius: BorderRadius.horizontal(left: Radius.circular(10.0)), // 左边圆角(也可以使用BorderRadius.only实现)
      ),
    );
  }

// 获取菜式图片
/*  ImageProvider getImageProvider(thumbImgUrl) {
    return thumbImgUrl != null && thumbImgUrl.length > 0
        ? new NetworkImage(thumbImgUrl) // 网络图片
        : new ExactAssetImage('./images/ic_img_default.jpg'); // 本地默认图片
  }

  String getImageUrl(imageId) {
    return 'http://pic.ecook.cn/web/' + imageId + '.jpg!m4';
  }

  String getAvatarUrl(imageId) {
    return 'http://pic.ecook.cn/web/' + imageId + '.jpg!s1';
  }*/
}
