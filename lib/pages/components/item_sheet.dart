import 'package:flutter/material.dart';

import 'package:heady_sat/common/app_constants.dart';
import 'package:heady_sat/common/app_style.dart';
import 'package:heady_sat/models/carts.dart';
import 'package:heady_sat/models/items.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ItemSheet extends StatelessWidget {
  static DateFormat _formatter = DateFormat('dd/MM/yyyy');
  final Product product;
  ItemSheet(this.product);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            SizedBox(
              width: 10,
            ),
            Expanded(
                child: Text(
              product.name,
              style: AppStyle.priceStyle,
            )),
            IconButton(
                icon: Icon(Icons.clear),
                onPressed: () => Navigator.pop(context))
          ],
        ),
        Row(
          children: [
            SizedBox(width: 10),
            Expanded(
                child: Text(
              product.tax.name +
                  '(Incl.) ' +
                  product.tax.value.toStringAsFixed(2) +
                  '% ',
            )),
            Text('Added on ${_formatter.format(product.addedDate)}'),
            SizedBox(width: 10),
          ],
        ),
        Text('Variants', style: AppStyle.priceStyle),
        ...List.generate(product.variants.length,
            (index) => VariantView(product, product.variants[index]))
      ],
    );
  }
}

class VariantView extends StatelessWidget {
  final Variant variant;
  final Product product;
  VariantView(this.product, this.variant);
  @override
  Widget build(BuildContext context) {
    List<CartItem> list = Provider.of<Cart>(context, listen: true).items;
    int count = 0;
    for (CartItem item in list)
      if (item.productId == product.id && item.variantId == variant.variantId) {
        count = item.quantity;
        break;
      }

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                    color: variant.colorData,
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(color: Colors.grey, width: 0.5)),
              ),
              SizedBox(width: 10),
              if (variant.size != null) Text('Size: ${variant.size}'),
              Expanded(
                  child: Text(
                AppContants.rupeeSymbol +
                    (variant.price + variant.price / 100 * product.tax.value)
                        .toStringAsFixed(2),
                style: AppStyle.priceStyle,
                textAlign: TextAlign.end,
              )),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (count == 0)
                InkWell(
                    onTap: () => Provider.of<Cart>(context, listen: false)
                        .add(product.id, variant.variantId),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 3.5),
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(5)),
                      child: Text('Add', style: TextStyle(color: Colors.white)),
                    )),
              if (count != 0)
                Row(
                  children: [
                    InkWell(
                      onTap: () => Provider.of<Cart>(context, listen: false)
                          .remove(product.id, variant.variantId),
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(5)),
                          child: Icon(
                            Icons.remove,
                            color: Colors.white,
                          )),
                    ),
                    SizedBox(
                      width: 30,
                      child: Text(
                        count.toString(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    InkWell(
                      onTap: () => Provider.of<Cart>(context, listen: false)
                          .add(product.id, variant.variantId),
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(5)),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                          )),
                    )
                  ],
                )
              // BlocListener<CartBloc, DataState<List<CartItem>>>(
              //     child: InkWell(
              //       onTap: () => BlocProvider.of<CartBloc>(context)
              //           .add(CartAddEvent(product.id, variant.variantId)),
              //       child: Text('data'),
              //     ),
              //     listener: (_, state) {

              //       return Text(state.toString());
              //     }),
            ],
          )
        ],
      ),
    );
  }
}
