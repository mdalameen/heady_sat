import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heady_sat/blocs/data_event.dart';
import 'package:heady_sat/blocs/data_state.dart';
import 'package:heady_sat/blocs/item_bloc.dart';
import 'package:heady_sat/common/app_widgets.dart';
import 'package:heady_sat/models/items.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageType _currentPage = PageType.values[0];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadData();
    });
  }

  _loadData() async {
    BlocProvider.of<ItemBloc>(context).add(LoadDataEvent());
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
            body: CustomScrollView(
              slivers: _buildCurrentScreen(out),
            ),
            bottomNavigationBar: _buildBottomNavigationBar(),
          );
        },
        listener: (_, item) {});
  }

  _buildCurrentScreen(ItemOut data) {
    switch (_currentPage) {
      case PageType.ranking:
        return [AppWidget.getSliverAppBar('Ranking'), _getRankingView(data)];
      default:
        return [
          SliverAppBar(
            title: Text('default'),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: Text('pending'),
            ),
          )
        ];
    }
  }

  Widget _getRankingView(ItemOut data) {
    return SliverToBoxAdapter(
      child: Column(
          children: List.generate(data?.categories?.length ?? 0,
              (index) => ListTile(title: Text(data.categories[index].name)))),
    );
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
    return BottomNavigationBar(
      items: List.generate(
          4,
          (index) => BottomNavigationBarItem(
              icon: Icon(icons[index],
                  color:
                      index == _currentPage.index ? Colors.black : Colors.grey),
              title: Text(
                labels[index],
                style: TextStyle(color: Colors.black),
              ))),
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
