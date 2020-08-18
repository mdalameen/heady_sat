import 'package:flutter/material.dart';
import 'package:heady_sat/common/app_widgets.dart';
import 'package:heady_sat/common/category_processor.dart';
import 'package:heady_sat/models/items.dart';
import 'package:heady_sat/pages/components/item_tile.dart';

class CategoryScreen extends StatefulWidget {
  final ItemOut data;
  CategoryScreen(this.data, GlobalKey key) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Product> products = List();

  @override
  void initState() {
    super.initState();
    _initProducts();
  }

  _initProducts() async {
    products.addAll(CategoryProcessor().getProducts());
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        AppWidget.getSliverAppBar('Categories',
            bottomWidget: PreferredSize(
                child: _getCategoryLabels(),
                preferredSize: Size.fromHeight(31))),
        SliverList(
          delegate: SliverChildBuilderDelegate((_, i) {
            return ItemTile(products[i]);
          }, childCount: products.length),
        )
      ],
    );
  }

  _getCategoryLabels() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
          children: List.generate(widget.data.categories.length + 1, (index) {
        bool isSelected = false;
        if (index == 0) {
          isSelected = CategoryProcessor().getSelectedCategory().isEmpty;
        } else {
          isSelected = CategoryProcessor()
              .getSelectedCategory()
              .contains(widget.data.categories[index - 1].id);
        }

        return InkWell(
          onTap: () async {
            if (index == 0)
              CategoryProcessor().resetCategory();
            else
              CategoryProcessor()
                  .toggleCategory(widget.data.categories[index - 1].id);
            products = CategoryProcessor().getProducts();
            setState(() {});
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? Colors.black : Colors.white,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(50),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            margin: EdgeInsets.symmetric(horizontal: 3),
            child: Text(
              index == 0 ? 'All' : widget.data.categories[index - 1].name,
              style: TextStyle(
                  fontSize: 16,
                  color: isSelected ? Colors.white : Colors.black),
            ),
          ),
        );
      })),
    );
  }
}
