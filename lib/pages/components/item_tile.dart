import 'package:flutter/material.dart';
import 'package:heady_sat/common/app_constants.dart';
import 'package:heady_sat/common/app_style.dart';
import 'package:heady_sat/models/items.dart';
import 'package:heady_sat/pages/components/item_sheet.dart';

class ItemTile extends StatelessWidget {
  final Product product;
  bool isRightAligned;
  ItemTile(this.product, [this.isRightAligned = false]);

  @override
  Widget build(BuildContext context) {
    double minPrice;
    double maxPrice;
    Set<int> sizes = Set();

    Set<Color> colors = Set();
    String sizeString = '';

    for (Variant v in product.variants) {
      colors.add(v.colorData);
      if (v.size != null) sizes.add(v.size);
      double price = v.price + (v.price / 100 * product.tax.value);
      if (minPrice == null || maxPrice == null) {
        maxPrice = minPrice = price;
      } else {
        if (price < minPrice) minPrice = price;
        if (price > maxPrice) maxPrice = price;
      }
    }
    if (sizes.isNotEmpty)
      for (int s = 0; s < sizes.length; s++)
        sizeString += (s == 0 ? '' : ',') + sizes.elementAt(s).toString();

    return InkWell(
      onTap: () => showModalBottomSheet(
          context: context,
          builder: (_) => ItemSheet(product),
          isScrollControlled: true),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(child: Text(product.name, style: AppStyle.priceStyle)),
                Icon(Icons.chevron_right)
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Row(
                  children: List.generate(
                      colors.length,
                      (index) => Container(
                            width: 20,
                            height: 20,
                            margin: EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                                color: colors.elementAt(index),
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(3)),
                          )),
                ),
                if (sizes.isNotEmpty)
                  Expanded(
                      child: Text(
                    'Size-$sizeString',
                    textAlign: TextAlign.right,
                  )),
              ],
            ),
            SizedBox(height: 5),
            Text(
              AppContants.rupeeSymbol +
                  minPrice.toStringAsFixed(2) +
                  (minPrice == maxPrice
                      ? ''
                      : ' - ${maxPrice.toStringAsFixed(2)}'),
              style: AppStyle.priceStyle,
              textAlign: isRightAligned ? TextAlign.right : TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
