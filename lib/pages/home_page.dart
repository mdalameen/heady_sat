import 'package:bottom_bar_page_transition/bottom_bar_page_transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heady_sat/blocs/data_event.dart';
import 'package:heady_sat/blocs/data_state.dart';
import 'package:heady_sat/blocs/item_bloc.dart';
import 'package:heady_sat/common/app_widgets.dart';
import 'package:heady_sat/models/carts.dart';
import 'package:heady_sat/models/items.dart';
import 'package:heady_sat/pages/components/cart_screen.dart';
import 'package:heady_sat/pages/components/category_screen.dart';
import 'package:heady_sat/pages/components/ranking_screen.dart';
import 'package:provider/provider.dart';

import 'components/more_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageType _currentPage = PageType.values[0];
  List<GlobalKey> _keys =
      List.generate(PageType.values.length, (index) => GlobalKey());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadData();
    });
  }

  _loadData() async {
    BlocProvider.of<ItemBloc>(context).add(LoadDataEvent());
    Provider.of<Cart>(context, listen: false).init();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ItemBloc, DataState<ItemOut>>(
        builder: (_, state) {
          if (state is DataLoadingState || state is DataNotFetched)
            return AppWidget.getLoadingPage('Items');
          if (state is DataErrorState)
            return AppWidget.getErrorPage(
                'Items', (state as DataErrorState).errorMessage, _loadData);
          ItemOut out = (state as DataCachedState).data;

          return Scaffold(
            backgroundColor: Colors.white,
            body: BottomBarPageTransition(
              transitionType: TransitionType.slide,
              builder: (_, i) => _buildCurrentScreen(out, i),
              currentIndex: _currentPage.index,
              totalLength: PageType.values.length,
            ),
            bottomNavigationBar: _buildBottomNavigationBar(),
          );
        },
        listener: (_, item) {});
  }

  _buildCurrentScreen(ItemOut data, int index) {
    PageType currentPage = PageType.values[index];
    if (currentPage == PageType.ranking)
      return RankingScreen(data, _keys[index]);
    else if (currentPage == PageType.category)
      return CategoryScreen(data, _keys[index]);
    else if (currentPage == PageType.cart)
      return CartScreen(_keys[index]);
    else
      return MoreScreen(_keys[index]);
  }

  _onPageSelected(int index) {
    _currentPage = PageType.values[index];
    setState(() {});
  }

  Widget _buildBottomNavigationBar() {
    var icons = <IconData>[
      Icons.trending_up,
      Icons.category,
      Icons.shopping_cart,
      Icons.more_horiz
    ];
    var labels = <String>['Ranking', 'Categories', 'Cart', 'More'];
    List<CartItem> list = Provider.of<Cart>(context, listen: true).items;

    return BottomNavigationBar(
      items: List.generate(
          4,
          (index) => BottomNavigationBarItem(
              icon: SizedBox(
                width: 80,
                height: 45,
                child: Stack(
                  children: [
                    SizedBox(
                      height: 45,
                      width: 80,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(icons[index],
                              color: index == _currentPage.index
                                  ? Colors.black
                                  : Colors.grey),
                          Text(
                            labels[index],
                            style: TextStyle(
                                color: index == _currentPage.index
                                    ? Colors.black
                                    : Colors.grey),
                          )
                        ],
                      ),
                    ),
                    if (list.isNotEmpty && index == 2)
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                            padding: EdgeInsets.all(4),
                            margin: EdgeInsets.only(right: 25),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.red),
                            child: Text(
                              list.length.toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            )),
                      )
                  ],
                ),
              ),
              title: SizedBox())),
      currentIndex: _currentPage.index,
      onTap: _onPageSelected,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.yellow,
      selectedFontSize: 12,
      unselectedFontSize: 12,
    );
  }
}

enum PageType { ranking, category, cart, more }
