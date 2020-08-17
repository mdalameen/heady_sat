import 'package:heady_sat/models/items.dart';

class DataProcessor {
  static final DataProcessor _instance = DataProcessor._internal();
  DataProcessor._internal();
  factory DataProcessor() => _instance;

  Map<int, Product> rankingProducts = Map();

  void setData(ItemOut data) {
    rankingProducts.clear();
    Map<int, Product> allProducts = Map();
    if (data != null) {
      for (Category c in data.categories) {
        for (Product p in c.products) {
          allProducts[p.id] = p;
        }
      }
      for (Ranking r in data.rankings) {
        for (RankingProduct rp in r.rankingProducts) {
          // rankingProducts[rp.]
        }
      }
    }
  }
}
