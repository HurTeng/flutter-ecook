import 'package:ecook/common/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ecook/common/api.dart';
import 'package:ecook/common/net_util.dart';
import 'dart:convert';
import 'package:ecook/common/global_config.dart';

class MenuDetailPage extends StatefulWidget {
  var menuData;

  MenuDetailPage({Key key, this.menuData}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _MenuDetailPageState();
}

class _MenuDetailPageState extends State<MenuDetailPage> {
  final TextStyle titleTextStyle = new TextStyle(fontSize: 26.0, fontFamily: 'serif'); // 标题样式
  final TextStyle subtitleStyle =
      new TextStyle(fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.bold); // 副标题样式
  final TextStyle descriptionStyle = new TextStyle(fontSize: 16.0, color: Colors.grey); // 副标题样式

  var data;
  var title = '';
  var img = '';
  var healthStr = '';
  var steps = new List();
  var materialList = new List();
  var isCollected = false;

  @override
  void initState() {
    super.initState();
    isCollected = _hasCollected();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return data == null ? buildLoadingWidget() : buildContentWidget();
  }

  MaterialApp buildContentWidget() {
    return new MaterialApp(
        home: new Scaffold(
          appBar: buildAppBar(),
          body: buildWidget(),
          floatingActionButton: new FloatingActionButton(
            onPressed: _collectMenu,
            tooltip: 'collectMenu',
            backgroundColor: Colors.orangeAccent,
            foregroundColor: isCollected ? Colors.redAccent : Colors.white,
            child: new Icon(Icons.star),
          ),
        ),
        theme: GlobalConfig.themeData);
  }

  Widget buildLoadingWidget() {
    return new Center(
      child: new CircularProgressIndicator(), // CircularProgressIndicator是一个圆形的Loading进度条
    );
  }

  AppBar buildAppBar() {
    return new AppBar(
      title: new Text(title),
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(this.context); // pop的时候要用Widget的context,如果使用Scaffold的context会出现黑屏
              });
        },
      ),
    );
  }

  Widget buildWidget() {
    return new Container(
        color: Colors.white,
        child: new ListView(padding: EdgeInsets.symmetric(horizontal: 20.0), // 内间距
            children: <Widget>[
              getMenuPicture(img),
              new Text(title, style: titleTextStyle),
              new Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: new Text(healthStr, style: descriptionStyle),
              ),
              new Text('需要食材', style: subtitleStyle),
              buildMaterialList(),
              new Text('烹饪步骤', style: subtitleStyle),
              buildStepList()
            ]));
  }

  void initData() {
    var url = Api.getDishDetail(widget.menuData['id']);
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
      setState(() => setupData(map));
    });
  }

  void setupData(Map<String, dynamic> map) {
    this.data = map['list'][0];
    this.title = data['name']; // 菜式名
    this.img = getImageUrl(data['imageid']); // 图片url
    this.healthStr = data['description']; // 材料功效
    this.steps = data['stepList']; // 菜式步骤
    this.materialList = data['materialList']; // 所需材料
  }

  Container getMenuPicture(url) {
    return new Container(
      width: double.infinity,
      height: 200.0,
      decoration: new BoxDecoration(
        image: new DecorationImage(image: new NetworkImage(url), fit: BoxFit.cover), // 图片
      ),
    );
  }

  String getImageUrl(imageId) {
    return 'http://pic.ecook.cn/web/' + imageId + '.jpg!m4';
  }

/*  Widget buildMaterialList() {
    return new ListView.builder(
      itemCount: materialList.length,
      itemBuilder: (context, i) => renderMaterialData(i),
    );
  }

  Widget renderMaterialData(int i) {
    print(materialList[i]);
    return new Row(children: <Widget>[
      new Text(materialList[i]['name']),
      new Text(materialList[i]['dosage']),
    ]);
  }*/

  Widget buildMaterialList() {
    List<Widget> tiles = [];
    for (var item in materialList) {
      tiles.add(new Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
        getMaterialInfoText(item['name'], FontWeight.bold),
        getMaterialInfoText(item['dosage'], FontWeight.normal),
      ]));
      tiles.add(new Divider(height: 20.0));
    }
    return new Padding(
      padding: EdgeInsets.all(20.0),
      child: new Column(children: tiles),
    );
  }

  Widget buildStepList() {
    List<Widget> tiles = []; //先建一个数组用于存放循环生成的widget
    for (var item in steps) {
      tiles.add(new Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        getStepInfoText('步骤 ${item['ordernum'] + 1}/${steps.length}'),
        getStepPicture(getImageUrl(item['imageid'])),
        getStepInfoText(item['details']),
      ]));
    }
    //单独一个widget组件，用于返回需要生成的内容widget
    // 重点在这里，因为用编辑器写Column生成的children后面会跟一个<Widget>[]，
    // 此时如果我们直接把生成的tiles放在<Widget>[]中是会报一个类型不匹配的错误，把<Widget>[]删了就可以了
    return new Column(children: tiles);
  }

  Container getStepPicture(url) {
    return new Container(
      width: double.infinity,
      height: 200.0,
      decoration: new BoxDecoration(
          shape: BoxShape.rectangle, // 形状
          image: new DecorationImage(image: new NetworkImage(url), fit: BoxFit.cover), // 图片
          borderRadius: BorderRadius.circular(10.0) // 圆角
          ),
    );
  }

  Widget getMaterialInfoText(String title, FontWeight fontWeight) {
    return new Text(title, style: new TextStyle(fontSize: 18.0, color: Colors.black, fontWeight: fontWeight));
  }

  Widget getStepInfoText(String title) {
    return new Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: new Text(
          title,
          style: new TextStyle(fontSize: 20.0, color: Colors.black, fontFamily: 'serif'),
        ));
  }

  void _collectMenu() {
    setState(() {
      // 判断是否已经收藏了改菜式
      Storage storage = Storage.instance;
      if (_hasCollected()) {
        // 根据id进行判断
        isCollected = false; // 状态置为未收藏
        storage.deleteFromCollectionList(widget.menuData); // 移除收藏记录
        print('delete');
      } else {
        // 未收藏的情况
        isCollected = true; // 状态置为已收藏
        storage.addIntoCollectionList(widget.menuData); // 记录收藏数据
        print('add');
      }
    });
  }

  bool _hasCollected() {
    return Storage.instance.hasCollected(widget.menuData['id']);
  }
}
