import 'package:flutter/material.dart';
import './slide_view_indicator.dart';

class SlideView extends StatefulWidget {
  var data;
  SlideViewIndicator slideViewIndicator;

  SlideView(data, indicator) {
    this.data = data;
    this.slideViewIndicator = indicator;
  }

  @override
  State<StatefulWidget> createState() {
    return new SlideViewState();
  }
}

class SlideViewState extends State<SlideView> with SingleTickerProviderStateMixin {
  TabController tabController;
  List slideData;

  @override
  void initState() {
    super.initState();
    slideData = this.widget.data;
    tabController = new TabController(length: slideData == null ? 0 : slideData.length, vsync: this);
    tabController.addListener(() {
      if (this.widget.slideViewIndicator.state.mounted) {
        this.widget.slideViewIndicator.state.setSelectedIndex(tabController.index);
      }
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Widget generateCard() {
    return new Card(
      color: Colors.blue,
      child: new Image.asset("images/ic_avatar_default.png", width: 20.0, height: 20.0,),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [];
    if (slideData != null && slideData.length > 0) {
      for (var i = 0; i < slideData.length; i++) {
        var item = slideData[i];
        var imgUrl = getImageUrl(item['image']);
        items.add(new GestureDetector(
          onTap: () {

          },
          child: new Stack(
            children: <Widget>[
              createThumbImg(imgUrl),
//              new Image.network(imgUrl, width: MediaQuery.of(context).size.width, fit: BoxFit.contain),
/*              new Container(
                width: MediaQuery.of(context).size.width,
                color: const Color(0x50000000),
                child: new Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: new Text(title, style: new TextStyle(color: Colors.white, fontSize: 15.0)),
                )
              )*/
            ],
          ),
        ));
      }
    }
//    items.add(new Container(
//      color: const Color(0x00000000),
//      alignment: Alignment.bottomCenter,
//      child: new SlideViewIndicator(slideData.length),
//    ));
    return new TabBarView(
      controller: tabController,
      children: items,
    );
  }

  String getImageUrl(imageId) {
    return 'http://pic.ecook.cn/web/' + imageId + '.jpg!m4';
  }

  // 图片数据
  Container createThumbImg(imgUrl) {
    return new Container(
      width: double.infinity, // 无限大,填充满父控件
      height: 200.0,
      decoration: new BoxDecoration(
        // 装饰器
        shape: BoxShape.rectangle, // 形状
        image: new DecorationImage(
            image: new NetworkImage(imgUrl),
            fit: BoxFit.cover), // 图片
        borderRadius: BorderRadius.circular(10.0), // 左边圆角(也可以使用BorderRadius.only实现)
      ),
    );
  }
}