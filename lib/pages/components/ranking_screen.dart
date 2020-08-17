import 'package:flutter/material.dart';
import 'package:heady_sat/common/app_widgets.dart';
import 'package:heady_sat/models/items.dart';

class RankingScreen extends StatelessWidget {
  final ItemOut data;
  RankingScreen(this.data);
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        AppWidget.getSliverAppBar('Ranking'),
        for (Ranking r in data.rankings) _buildRanking(r)
      ],
    );
  }

  Widget _buildRanking(Ranking r) {
    return SliverToBoxAdapter(
      child: Container(
        child: Column(
          children: [
            Text(r.ranking,
                style: TextStyle(color: Colors.black, fontSize: 20)),
            SizedBox(
              height: 200,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: r.rankingProducts.length,
                  itemBuilder: (_, index) {
                    RankingProduct rp = r.rankingProducts[index];
                    return Container(
                      width: 200,
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.black,
                            )
                          ],
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Image.network(
                          //   'https://picsum.photos/id/${rp.product.id}/200?blur=5',
                          //   width: 100,
                          //   height: 100,
                          // ),
                          Icon(
                            Icons.bubble_chart,
                            color: Colors.grey,
                            size: 100,
                          ),
                          Text(rp?.product?.name ?? '-'),
                          Row(
                            children: [
                              Text(rp.countLabel),
                              Icon(rp.countIcon),
                              Text(rp.count.toString()),
                            ],
                          )
                        ],
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
