import 'package:flutter/material.dart';

class AppWidget {
  static Widget getSliverAppBar(String title, {Widget bottomWidget}) {
    return SliverAppBar(
      snap: true,
      primary: true,
      pinned: true,
      floating: true,
      elevation: 0,
      title: Text(title),
      bottom: bottomWidget,
    );
  }

  static Widget getLoadingPage(String title) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 5),
            Text('Loading! Please wait..,')
          ],
        ),
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
