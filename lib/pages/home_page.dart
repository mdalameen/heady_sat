import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageType _currentPage = PageType.values[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Text('data'),
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
