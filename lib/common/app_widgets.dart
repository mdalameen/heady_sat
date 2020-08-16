import 'package:flutter/material.dart';

class AppWidget {
  static Widget getLoadingPage(String title) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text('Loading'),
      ),
    );
  }

  static Widget getErrorPage(
      String title, String errorMessage, VoidCallback onRetry) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: [
          Text(errorMessage ?? 'Cannot fetch data'),
          FlatButton(onPressed: onRetry, child: Text('Retry'))
        ],
      ),
    );
  }
}