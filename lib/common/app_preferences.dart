import 'package:heady_sat/models/carts.dart';
import 'package:heady_sat/models/items.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as json;

class AppPreferences {
  static const String _keyCachedItem = 'cachedItem';
  static const String _keyCartItem = 'cartItem';

  Future<SharedPreferences> getPreferences() => SharedPreferences.getInstance();

  static Future<ItemOut> getCachedItem() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String jsonString = pref.getString(_keyCachedItem);
    if (jsonString != null)
      return ItemOut.fromJson(json.jsonDecode(jsonString));
    return null;
  }

  static Future<void> setCachedItem(ItemOut item) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(_keyCachedItem, json.jsonEncode(item.toJson()));
  }

  static Future<List<CartItem>> getCartItems() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return getCartItemsSync(pref);
  }

  static List<CartItem> getCartItemsSync(SharedPreferences pref) {
    if (pref != null) {
      String jsonString = pref.getString(_keyCartItem);
      if (jsonString != null)
        return CartItem.getList(json.jsonDecode(jsonString));
    }
    return <CartItem>[];
  }

  static Future<void> setCartItems(List<CartItem> list) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(
        _keyCartItem, json.jsonEncode(CartItem.getJsonList(list)));
  }
}
