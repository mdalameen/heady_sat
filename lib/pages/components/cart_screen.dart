import 'package:flutter/material.dart';
import 'package:heady_sat/common/app_style.dart';
import 'package:heady_sat/common/app_widgets.dart';
import 'package:heady_sat/common/category_processor.dart';
import 'package:heady_sat/models/carts.dart';
import 'package:heady_sat/models/items.dart';
import 'package:heady_sat/pages/components/item_sheet.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<CartItem> list = Provider.of<Cart>(context, listen: true).items;
    List<_CartDisplayItem> displayList = List();
    Map<Product, _CartDisplayItem> items = Map();
    Map<int, Product> productMap = CategoryProcessor().getProductMap();
    for (CartItem item in list) {
      Product p = productMap[item.productId];
      Variant v;
      for (Variant tv in p.variants)
        if (tv.variantId == item.variantId) {
          v = tv;
          break;
        }

      if (items.containsKey(p))
        items[p].selectedVariants.add(v);
      else {
        items[p] = _CartDisplayItem()
          ..product = p
          ..selectedVariants = <Variant>[v];
      }
    }
    displayList = items.values.toList();

    return CustomScrollView(
      slivers: [
        AppWidget.getSliverAppBar('Cart'),
        if (displayList.isEmpty)
          SliverFillRemaining(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_shopping_cart, size: 150, color: Colors.grey),
                SizedBox(height: 10),
                Text('No items in cart, please add items')
              ],
            ),
          ),
        if (displayList.isNotEmpty)
          SliverList(
            delegate: SliverChildBuilderDelegate((_, i) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(
                            displayList[i].product.name,
                            style: AppStyle.priceStyle,
                          )),
                          IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () => _onClearPressed(
                                  context, displayList[i].product))
                        ],
                      ),
                    ),
                    ...List.generate(
                        displayList[i].selectedVariants.length,
                        (index) => VariantView(displayList[i].product,
                            displayList[i].selectedVariants[index]))
                  ],
                ),
              );
            }, childCount: displayList.length),
          )
      ],
    );
  }

  void _onClearPressed(BuildContext context, Product product) async {
    bool result = (await showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: Text('Do you want to remove item?'),
                  content: Text(
                      'This will remove product & its variants from cart, do you want to remove'),
                  actions: [
                    FlatButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text('Delete')),
                    FlatButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel'))
                  ],
                ))) ??
        false;
    if (result)
      Provider.of<Cart>(context, listen: false).removeProduct(product.id);
  }
}

class _CartDisplayItem {
  Product product;
  List<Variant> selectedVariants;
}
