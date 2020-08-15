import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NetworkHandler {
  static Future<NetworkOut> executeRequest(BuildContext context, String url,
      {String input, bool enableRetry: true, RequestType requestType}) async {
    if (requestType == null)
      requestType = input == null ? RequestType.get : RequestType.post;
    Map<String, String> header = {'Content-Type': 'application/json'};
    http.Response response;
    try {
      if (requestType == RequestType.post)
        response = await http.post(url, headers: header, body: input);
      else if (requestType == RequestType.delete)
        response = await http.delete(url, headers: header);
      else if (requestType == RequestType.put)
        response = await http.put(url, headers: header, body: input);
      else
        response = await http.get(url, headers: header);
    } catch (err) {
      print('Network connection');
    }
    var out = NetworkOut(response);

    if (out.hasErrorMessage) {
      await showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text('Error'),
                content: Text(out.body),
                actions: [
                  FlatButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Ok'))
                ],
              ));
    }
    return out;
  }
}

enum RequestType { get, post, delete, put }

class NetworkOut {
  int statusCode;
  Map<String, String> responseHeaders;
  String body;

  NetworkOut([http.Response response])
      : statusCode = response?.statusCode,
        responseHeaders = response?.headers,
        body = response?.body;

  get isSuccess => statusCode != null && <int>[200, 201].contains(statusCode);

  get isNetowkError => statusCode == null;

  get hasErrorMessage => !isSuccess && body != null;
}
