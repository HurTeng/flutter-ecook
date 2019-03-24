import 'package:flutter/material.dart';
import '../widget/menu_row.dart';

class MenuDataList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _MenuDataListState(listData);

  var listData; // 列表数据
  MenuDataList(listData) {
    this.listData = listData;
  }
}

class _MenuDataListState extends State<MenuDataList> {
  var listData; // 列表数据
  _MenuDataListState(listData) {
    this.listData = listData;
  }

  @override
  void initState() {
    // 初始化
    super.initState();
  }

  // 状态对象定义了build方法
  @override
  Widget build(BuildContext context) {
    // 无数据时，显示Loading
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
      child: new ListView.builder(
        itemCount: listData.length,
        itemBuilder: (context, index) => new MenuRow(itemData: listData[index]),
      ),
    );
  }
}
