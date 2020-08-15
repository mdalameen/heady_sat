import 'package:flutter/material.dart';

class Variant {
  int variantId;
  String color;
  int size;
  double price;

  Variant.fromJson(Map<String, dynamic> map)
      : variantId = map['id'],
        color = map['color'],
        size = map['size'],
        price = _getDouble(map['price']);

  Map<String, dynamic> toJson() =>
      {'id': variantId, 'color': color, 'size': size, 'price': price};

  static List<Variant> getList(List dList) {
    List<Variant> list = List();
    if (dList != null)
      for (Map<String, dynamic> map in dList) list.add(Variant.fromJson(map));
    return list;
  }

  static List<Map<String, dynamic>> getJsonList(List<Variant> list) {
    List<Map<String, dynamic>> dList = List();
    if (list != null) for (Variant v in list) dList.add(v.toJson());
    return dList;
  }
}

class Tax {
  String name;
  double value;

  Tax.fromJson(Map<String, dynamic> map)
      : name = map['name'],
        value = _getDouble(map['value']);

  Map<String, dynamic> toJson() => {'name': name, 'value': value};
}

class Product {
  int id;
  String name;
  DateTime addedDate;
  List<Variant> variants;
  Tax tax;

  Product.fromJson(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        addedDate = DateTime.parse(map['date_added']),
        variants = Variant.getList(map['variants']),
        tax = Tax.fromJson(map['tax']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'date_added': addedDate.toIso8601String(),
        'variants': Variant.getJsonList(variants),
        'tax': tax.toJson()
      };

  static List<Product> getList(List dList) {
    List<Product> list = List();
    if (dList != null)
      for (Map<String, dynamic> map in dList) list.add(Product.fromJson(map));
    return list;
  }

  static List<Map<String, dynamic>> getJsonList(List<Product> list) {
    List<Map<String, dynamic>> dList = List();
    if (list != null) for (Product v in list) dList.add(v.toJson());
    return dList;
  }
}

class Category {
  int id;
  String name;
  List<Product> products;
  List<int> childCategories;

  Category.fromJson(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        products = Product.getList(map['products']),
        childCategories = _getIntList(map['child_categories']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'products': Product.getJsonList(products),
        'child_categories': childCategories
      };

  static List<Category> getList(List dList) {
    List<Category> list = List();
    if (dList != null)
      for (Map<String, dynamic> map in dList) list.add(Category.fromJson(map));
    return list;
  }

  static List<Map<String, dynamic>> getJsonList(List<Category> list) {
    List<Map<String, dynamic>> dList = List();
    if (list != null) for (Category v in list) dList.add(v.toJson());
    return dList;
  }
}

class RankingProduct {
  static const String _keyView = 'view_count';
  static const String _labelView = 'View Count';
  static const IconData _iconView = Icons.remove_red_eye;

  static const String _keyOrder = 'order_count';
  static const String _labelOrder = 'Order Count';
  static const IconData _iconOrder = Icons.shopping_cart;

  static const String _keyShare = 'shares';
  static const String _labelShare = 'Shares';
  static const IconData _iconShare = Icons.share;

  int id;
  int count;
  String countLabel;
  IconData countIcon;
  String _countKey;

  RankingProduct.fromJson(Map<String, dynamic> map) {
    id = map['id'];

    if (map.keys.contains(_keyView)) {
      count = map[_keyView];
      countLabel = _labelView;
      countIcon = _iconView;
      _countKey = _keyView;
    } else if (map.keys.contains(_keyOrder)) {
      count = map[_keyOrder];
      countLabel = _labelOrder;
      countIcon = _iconOrder;
      _countKey = _keyOrder;
    } else if (map.keys.contains(_keyShare)) {
      count = map[_keyShare];
      countLabel = _labelShare;
      countIcon = _iconShare;
      _countKey = _keyShare;
    }
  }

  Map<String, dynamic> toJson() => {'id': id, _countKey: count};

  static List<RankingProduct> getList(List dList) {
    List<RankingProduct> list = List();
    if (dList != null)
      for (Map<String, dynamic> map in dList)
        list.add(RankingProduct.fromJson(map));
    return list;
  }

  static List<Map<String, dynamic>> getJsonList(List<RankingProduct> list) {
    List<Map<String, dynamic>> dList = List();
    if (list != null)
      for (RankingProduct product in list) dList.add(product.toJson());
    return dList;
  }
}

class Ranking {
  String ranking;
  List<RankingProduct> rankingProducts;

  Ranking.fromJson(Map<String, dynamic> map)
      : ranking = map['ranking'],
        rankingProducts = RankingProduct.getList(map['products']);

  Map<String, dynamic> toJson() => {
        'ranking': ranking,
        'products': RankingProduct.getJsonList(rankingProducts)
      };

  static List<Ranking> getList(List dList) {
    List<Ranking> list = List();
    if (dList != null)
      for (Map<String, dynamic> map in dList) list.add(Ranking.fromJson(map));
    return list;
  }

  static List<Map<String, dynamic>> getJsonList(List<Ranking> list) {
    List<Map<String, dynamic>> dList = List();
    if (list != null) for (Ranking v in list) dList.add(v.toJson());
    return dList;
  }
}

class ItemOut {
  List<Category> categories;
  List<Ranking> rankings;

  ItemOut.fromJson(Map<String, dynamic> map)
      : categories = Category.getList(map['categories']),
        rankings = Ranking.getList(map['rankings']);

  Map<String, dynamic> toJson() => {
        'categories': Category.getJsonList(categories),
        'rankings': Ranking.getJsonList(rankings)
      };
}

_getDouble(dynamic value) {
  if (value is int) return value.toDouble();
  if (value is double) return value;
  if (value is String) return double.tryParse(value);
  return null;
}

List<int> _getIntList(List dList) {
  List<int> list = List();
  if (dList != null) for (var v in dList) if (v is int) list.add(v);
  return list;
}