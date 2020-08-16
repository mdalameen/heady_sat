import 'package:heady_sat/models/items.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as json;

class AppPreferences {
  static const String _keyCachedItem = 'cachedItem';

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
}
