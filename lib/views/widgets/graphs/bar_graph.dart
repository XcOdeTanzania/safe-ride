import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'graph_card.dart';

class BarGraph extends StatelessWidget {
  final Color graphColor;
  final String graphTitle;
  final String graphSubtitle;
  final String graphTag;
  final String moreInfo;

  const BarGraph(
      {Key key,
      this.graphColor,
      this.graphTitle,
      this.graphSubtitle,
      this.graphTag,
      this.moreInfo})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    var data = [
      new ClicksPerYear('2016', 12, Colors.red),
      new ClicksPerYear('2017', 42, Colors.yellow),
      new ClicksPerYear('2018', 20, Colors.green),
    ];

    var series = [
      new charts.Series(
        domainFn: (ClicksPerYear clickData, _) => clickData.year,
        measureFn: (ClicksPerYear clickData, _) => clickData.clicks,
        colorFn: (ClicksPerYear clickData, _) => clickData.color,
        id: 'Clicks',
        data: data,
      ),
    ];

    var chart = new charts.BarChart(
      series,
      animate: true,
    );
    var chartWidget = Flexible(
      child: chart,
      flex: 1,
    );
    return GrapCard(
      graphTitle: graphTitle,
      graphSubtitle: graphSubtitle,
      graphTag: graphTag,
      graphColor: graphColor,
      graphWidget: chartWidget,
      moreInfo: moreInfo,
      sender: "bar",
    );
  }
}

class ClicksPerYear {
  final String year;
  final int clicks;
  final charts.Color color;

  ClicksPerYear(this.year, this.clicks, Color color)
      : this.color = new charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
