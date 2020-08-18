import 'package:flutter/material.dart';
import 'package:heady_sat/common/app_preferences.dart';

class CartItem {
  int productId;
  int variantId;
  int quantity;

  CartItem.fromJson(Map<String, dynamic> map)
      : productId = map['p_id'],
        variantId = map['v_id'],
        quantity = map['qty'];

  CartItem(this.productId, this.variantId, this.quantity);

  Map<String, dynamic> toJson() =>
      {'p_id': productId, 'v_id': variantId, 'qty': quantity};

  static List<CartItem> getList(List dList) {
    List<CartItem> list = List();

    if (dList != null)
      for (Map<String, dynamic> map in dList) list.add(CartItem.fromJson(map));
    return list;
  }

  static List<Map<String, dynamic>> getJsonList(List<CartItem> list) {
    List<Map<String, dynamic>> dList = List();
    if (list != null) for (CartItem data in list) dList.add(data.toJson());
    return dList;
  }

  @override
  toString() {
    return '$productId $variantId $quantity';
  }
}

class Cart extends ChangeNotifier {
  List<CartItem> items = List();

  void updateItems(List<CartItem> items) {
    this.items = items;
    notifyListeners();
  }

  init() async {
    List<CartItem> list = await AppPreferences.getCartItems();
    items = list;
    notifyListeners();
  }

  add(int productId, int variantId) async {
    List<CartItem> list = await AppPreferences.getCartItems();
    bool isAdded = false;
    for (CartItem item in list) {
      if (item.productId == productId && item.variantId == variantId) {
        isAdded = true;
        item.quantity = item.quantity + 1;
      }
    }
    if (!isAdded) {
      CartItem item = CartItem(productId, variantId, 1);
      list.add(item);
    }
    await AppPreferences.setCartItems(list);
    items = list;
    notifyListeners();
  }

  removeProduct(int productId) async {
    List<CartItem> list = await AppPreferences.getCartItems();
    List<CartItem> toRemoveList = List();
    for (CartItem item in list) {
      if (item.productId == productId) {
        toRemoveList.add(item);
      }
    }
    for (CartItem item in toRemoveList) list.remove(item);
    AppPreferences.setCartItems(list);
    items = list;
    notifyListeners();
  }

  remove(int productId, int variantId) async {
    List<CartItem> list = await AppPreferences.getCartItems();
    CartItem toRemoveItem;
    for (CartItem item in list) {
      if (item.productId == productId && item.variantId == variantId) {
        if (item.quantity > 1)
          item.quantity--;
        else
          toRemoveItem = item;
      }
    }
    if (toRemoveItem != null) {
      list.remove(toRemoveItem);
    }
    AppPreferences.setCartItems(list);
    items = list;
    notifyListeners();
  }

  reset() {
    items.clear();
  }
}
