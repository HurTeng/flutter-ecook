class Api {

  static String getHomeData() {
    String api = "https://api.ecook.cn/public/getHomeData.shtml?version=15.4.5";
    return api;
  }

  static String getCategory() {
    String api = "https://api.ecook.cn/public/getRecipeHomeData.shtml";
    return api;
  }

  static String getCategoryDishes(var id, String type) {
    String api = "https://api.ecook.cn/public/getRecipeListByType.shtml?id=$id&type=$type";
    return addParams(api);
  }

  static String getCategoryDishesById(var id, int page) {
    String api = "https://api.ecook.cn/public/getContentsBySubClassid.shtml?id=$id&page=$page";
    return addParams(api);
  }

  static String getDishDetail(var id) {
    String api = "https://api.ecook.cn/public/getRecipeListByIds.shtml?ids=$id";
    return addParams(api);
  }

  static String getHotSearchKeywords() {
    String api = "https://api.ecook.cn/public/getHotSearchKeywords.shtml?type=recipe";
    return api;
  }

  static String addParams(String api) {
    return api + "&version=15.4.5&appid=cn.ecook&terminal=2";
  }
}