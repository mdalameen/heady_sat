import 'package:flutter/material.dart';
import 'package:heady_sat/common/app_constants.dart';
import 'package:heady_sat/common/app_style.dart';
import 'package:heady_sat/common/app_widgets.dart';
import 'package:heady_sat/common/category_processor.dart';
import 'package:heady_sat/models/carts.dart';
import 'package:heady_sat/models/items.dart';
import 'package:heady_sat/pages/components/item_sheet.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  CartScreen(GlobalKey key) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<CartItem> list = Provider.of<Cart>(context, listen: true).items;
    List<_CartDisplayItem> displayList = List();
    Map<Product, _CartDisplayItem> items = Map();
    Map<int, Product> productMap = CategoryProcessor().getProductMap();
    double subTotal = 0;
    double tax = 0;

    for (CartItem item in list) {
      Product p = productMap[item.productId];
      Variant v;
      for (Variant tv in p.variants)
        if (tv.variantId == item.variantId) {
          v = tv;
          break;
        }

      subTotal += v.price * item.quantity;
      tax += (v.price / 100 * p.tax.value) * item.quantity;

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
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_shopping_cart, size: 150, color: Colors.grey),
                  SizedBox(height: 10),
                  Text('No items in cart, please add items')
                ],
              ),
            ),
          ),
        if (displayList.isNotEmpty)
          SliverList(
            delegate: SliverChildBuilderDelegate((_, i) {
              if (i == displayList.length)
                return _buildPriceWidget(subTotal, tax);
              return Container(
                color: Colors.white,
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
            }, childCount: displayList.length + 1),
          )
      ],
    );
  }

  _buildPriceWidget(double subTotal, double tax) {
    var getRow = (String label, String value, [bool isBold = false]) {
      TextStyle style = TextStyle(
          color: isBold ? Colors.black : Colors.grey.shade700, fontSize: 16);
      return Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            Text(
              label,
              style: style,
            ),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: style,
              ),
            )
          ],
        ),
      );
    };
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          getRow('Sub Total',
              AppContants.rupeeSymbol + subTotal.toStringAsFixed(2)),
          getRow('Tax', AppContants.rupeeSymbol + tax.toStringAsFixed(2)),
          getRow(
              'Total',
              AppContants.rupeeSymbol + (tax + subTotal).toStringAsFixed(2),
              true),
          Align(
            alignment: Alignment.center,
            child: InkWell(
                onTap: null,
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(3)),
                  child: Text('Proceed'),
                )),
          )
        ],
      ),
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
