import 'package:flutter/material.dart';
import 'package:heady_sat/common/app_constants.dart';
import 'package:heady_sat/common/app_style.dart';
import 'package:heady_sat/models/items.dart';
import 'package:intl/intl.dart';

class ItemSheet extends StatelessWidget {
  static DateFormat _formatter = DateFormat('dd/MM/yyyy');
  final Product product;
  ItemSheet(this.product);

  @override
  Widget build(BuildContext context) {
    // return Text('data');
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
    // return Text('Variant');
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
              Container(
                decoration: BoxDecoration(
                    color: Colors.blue, borderRadius: BorderRadius.circular(5)),
                child: Text('Add'),
              )
            ],
          )
        ],
      ),
    );
  }
}
