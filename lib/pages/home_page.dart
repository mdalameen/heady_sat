import 'package:flutter/material.dart';
import 'package:heady_sat/common/data_provder.dart';
import 'package:heady_sat/models/items.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageType _currentPage = PageType.values[0];
  ItemOut items;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    DataOut<ItemOut> out = await DataProvider.getAllItems(context);
    if (out.isSuccess) {
      items = out.data;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: items == null
          ? Center(
              child: Text('Loading'),
            )
          : SingleChildScrollView(
              child: Column(
                  children: List.generate(
                      items.categories.length,
                      (index) =>
                          ListTile(title: Text(items.categories[index].name)))),
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: _buildBottomItems(),
        currentIndex: _currentPage.index,
        onTap: _onPageSelected,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.yellow,
        selectedFontSize: 12,
        unselectedFontSize: 12,
      ),
    );
  }

  _onPageSelected(int index) {
    _currentPage = PageType.values[index];
    setState(() {});
  }

  List<BottomNavigationBarItem> _buildBottomItems() {
    var icons = <IconData>[
      Icons.trending_up,
      Icons.category,
      Icons.shopping_cart,
      Icons.more_horiz
    ];
    var labels = <String>['Ranking', 'Categories', 'Cart', 'More'];
    return List.generate(
        4,
        (index) => BottomNavigationBarItem(
            icon: Icon(icons[index],
                color:
                    index == _currentPage.index ? Colors.black : Colors.grey),
            title: Text(
              labels[index],
              style: TextStyle(color: Colors.black),
            )));
  }
}

enum PageType { ranking, category, cart, more }
