import 'package:flutter/material.dart';
import '../page/menu_detail_page.dart';
import '../common/storage.dart';

abstract class BaseMenuData extends StatelessWidget {
  final TextStyle titleTextStyle = new TextStyle(fontSize: 16.0); // 标题样式
  final TextStyle subtitleStyle =
      new TextStyle(fontSize: 14.0, color: const Color(0xFFB5BDC0)); // 副标题样式

  final Map<String, dynamic> itemData;
  final GestureTapCallback onTap;

  BaseMenuData({@required this.itemData, this.onTap});

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      child: buildRowData(itemData), // item控件
      onTap: () {
        onItemClick(context, itemData);
      }, // 点击事件
    );
  }

  void onItemClick(context, itemData) {
    Storage.instance.addIntoHistoryList(itemData);
    var detailPage = new MaterialPageRoute(
        builder: (ctx) => new MenuDetailPage(menuData: itemData));
    Navigator.push(context, detailPage); // 跳转到详情页面
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

  // 获取菜式图片
  ImageProvider getImageProvider(thumbImgUrl) {
    return thumbImgUrl != null && thumbImgUrl.length > 0
        ? new NetworkImage(thumbImgUrl) // 网络图片
        : new ExactAssetImage('./images/ic_img_default.jpg'); // 本地默认图片
  }

  String getImageUrl(imageId) {
    return 'http://pic.ecook.cn/web/' + imageId + '.jpg!m4';
  }

  String getAvatarUrl(imageId) {
    return 'http://pic.ecook.cn/web/' + imageId + '.jpg!s1';
  }

  buildRowData(Map<String, dynamic> itemData);
}
