import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:heady_sat/common/app_util.dart';
import 'package:heady_sat/common/app_widgets.dart';
import 'package:heady_sat/models/items.dart';
import 'package:heady_sat/pages/components/item_tile.dart';

class RankingScreen extends StatefulWidget {
  final ItemOut data;
  RankingScreen(this.data, GlobalKey key) : super(key: key);

  @override
  _RankingScreenState createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  Set<Ranking> expandedRankings = Set();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        AppWidget.getSliverAppBar('Ranking'),
        for (Ranking r in widget.data.rankings) _buildRanking(r)
      ],
    );
  }

  Widget _buildRanking(Ranking r) {
    bool isExpanded = expandedRankings.contains(r);
    return SliverStickyHeader(
      header: Container(
        color: Colors.grey.shade100,
        padding: EdgeInsets.all(10),
        child: Text(r.ranking,
            style: TextStyle(color: Colors.black, fontSize: 20)),
      ),
      sliver: SliverList(
          delegate: SliverChildBuilderDelegate((_, i) {
        if ((!isExpanded && i == 5) ||
            (isExpanded && i == r.rankingProducts.length))
          return InkWell(
            onTap: () {
              if (expandedRankings.contains(r))
                expandedRankings.remove(r);
              else
                expandedRankings.add(r);
              setState(() {});
            },
            child: Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.center,
              child: Text(
                isExpanded ? 'See Less' : 'See More',
                style: TextStyle(color: Colors.blue, fontSize: 18),
              ),
            ),
          );
        return IntrinsicHeight(
          child: IntrinsicWidth(
            child: Stack(
              children: [
                ItemTile(r.rankingProducts[i].product, true),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    alignment: Alignment.bottomLeft,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(r.rankingProducts[i].countIcon,
                            size: 20, color: Colors.grey),
                        SizedBox(
                          width: 5,
                        ),
                        Text(AppUtil.getCountString(r.rankingProducts[i].count))
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }, childCount: (isExpanded ? r.rankingProducts.length : 5) + 1)),
    );
  }
}
