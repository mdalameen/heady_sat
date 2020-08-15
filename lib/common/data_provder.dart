import 'package:flutter/material.dart';

import 'dart:convert' as json;

import 'package:heady_sat/models/items.dart';

import 'network_handler.dart';

class DataProvider {
  static const _url = 'https://stark-spire-93433.herokuapp.com/json';

  static Future<DataOut<ItemOut>> getAllItems(BuildContext context) async {
    var out = await NetworkHandler.executeRequest(context, _url);
    print(out.body);
    ItemOut data;
    String errorMessage;
    if (out.isSuccess)
      data = ItemOut.fromJson(json.jsonDecode(out.body));
    else
      errorMessage = out.body;

    return DataOut(out.isSuccess, data, errorMessage);
  }
}

class DataOut<T> {
  final T data;
  final String errorMessage;
  final bool isSuccess;

  DataOut(this.isSuccess, this.data, this.errorMessage);
}
