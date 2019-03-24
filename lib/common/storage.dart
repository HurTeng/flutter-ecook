import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'sp_util.dart';

class Storage {
  static const String MENU_COLLECTION = 'menu_collection';
  static const String MENU_HISTORY = 'menu_history';
  static const String SEARCH_HISTORY = 'search_history';
  static const String SEARCH_HOT = 'search_hot';
  static const int BROWSE_HISTORY_LIMIT_SIZE = 20;
  static const int SEARCH_HISTORY_LIMIT_SIZE = 10;

  // 工厂模式
  factory Storage() {
    return _getInstance();
  }

  static Storage get instance => _getInstance();
  static Storage _instance;

  Storage._internal() {
    // 初始化
  }

/*  void loadAsync() async {
    await SpUtil.getInstance(); //等待Sp初始化完成
    SpUtil.putString("username", "sky224");
    String username = SpUtil.getString("username");
    print(username);
  }*/

  static Storage _getInstance() {
    if (_instance == null) {
      _instance = new Storage._internal();
    }
    return _instance;
  }

  _saveToLocal(key, data) {
    /*   if (data is List) {
    }*/
    print(data);
    SpUtil.putObjectList(key, data);
//    print('save:${json.encode(object)}');
//    save(key, json.encode(object));
  }

  List<Map> _loadFromLocal(key) {
    return SpUtil.getObjectList(key) ?? new List<Map>();
/*    String str = await get(key);
    List<dynamic> data;
    if (str != null) {
      var _list = json.decode(str);
      if (_list is List) {
        data = _list;
      }
    }
    print('loadFromLocal:$data');
    return data;*/
  }

  _saveStringListToLocal(key, data) {
    print(data);
    SpUtil.putStringList(key, data);
  }

  List<String> _loadStringListFromLocal(key) {
    return SpUtil.getStringList(key) ?? new List<String>();
  }

  save(key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  Future<String> get(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  delete() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  addIntoCollectionList(menuItem) {
    var isCollected = hasCollected(menuItem['id']);
    if (!isCollected) {
      var collection = getCollectionList();
      collection.insert(0, menuItem);
      saveCollectionList(collection);
    }
  }

  deleteFromCollectionList(menuItem) {
    var id = menuItem['id'];
    var collectionList = getCollectionList();
    var data = collectionList.firstWhere((item) => item['id'] == id);
    if (data != null) {
      collectionList.remove(data);
      saveCollectionList(collectionList);
    }
  }

  hasCollected(id) {
    var result = getCollectionList().singleWhere((item) => item['id'] == id, orElse: () => null);
    return result != null;
  }

  bool includeOnList(List list, id) {
    return list.singleWhere((item) => item['id'] == id, orElse: () => null) != null;
  }

  addIntoHistoryList(menuItem) {
    var menuList = getHistoryList();
    if (menuList == null || menuList.isEmpty) {
      var list = new List();
      list.add(menuItem);
      saveHistoryList(list);
      return;
    }

    if (!includeOnList(menuList, menuItem['id'])) {
      menuList.insert(0, menuItem);
      if (menuList.length > BROWSE_HISTORY_LIMIT_SIZE) {
        menuList.removeLast();
      }
      saveHistoryList(menuList);
    }
  }

  addIntoHistorySearchList(keyword) {
    var notEmpty = keyword.trim().length > 0;
    var historyList = getHistorySearchList();
    var isContains = historyList.contains(keyword);
    if (!isContains && notEmpty) {
      historyList.insert(0, keyword);
      if (historyList.length > SEARCH_HISTORY_LIMIT_SIZE) {
        historyList.removeLast();
      }
      saveHistorySearchList(historyList);
    }
  }

  deleteHistorySearchList() {
    saveHistorySearchList(new List<String>());
  }

  getHistorySearchList() {
    return _loadStringListFromLocal(SEARCH_HISTORY);
  }

  saveHistorySearchList(history) {
    _saveStringListToLocal(SEARCH_HISTORY, history);
  }

  deleteHotSearchList() {
    saveHistorySearchList(new List<String>());
  }

  getHotSearchList() {
    return _loadStringListFromLocal(SEARCH_HOT);
  }

  saveHotSearchList(List<String> hotList) {
    _saveStringListToLocal(SEARCH_HOT, hotList);
  }

  List<Map> getHistoryList() {
    return _loadFromLocal(MENU_HISTORY);
  }

  saveHistoryList(history) {
    _saveToLocal(MENU_HISTORY, history);
  }

  deleteHistoryList() {
    _saveToLocal(MENU_HISTORY, new List<String>());
  }

  getCollectionList() {
    return _loadFromLocal(MENU_COLLECTION);
  }

  saveCollectionList(collection) {
    _saveToLocal(MENU_COLLECTION, collection);
  }
}
