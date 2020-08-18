import 'package:flutter/material.dart';
import 'package:heady_sat/common/app_widgets.dart';

class MoreScreen extends StatelessWidget {
  MoreScreen(GlobalKey key) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        AppWidget.getSliverAppBar('More'),
        SliverFillRemaining(
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 150,
                  color: Colors.grey,
                ),
                SizedBox(
                  height: 10,
                ),
                Text('Created for Heady SAT'),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
