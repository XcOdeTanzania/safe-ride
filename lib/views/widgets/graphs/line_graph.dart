import 'package:flutter/material.dart';

import 'package:charts_flutter/flutter.dart' as charts;

import 'graph_card.dart';

class LineGraph extends StatelessWidget {
  final Color graphColor;
  final String graphTitle;
  final String graphSubtitle;
  final String graphTag;
  final String moreInfo;

  const LineGraph(
      {Key key,
      @required this.graphColor,
      @required this.graphTitle,
      @required this.graphSubtitle,
      @required this.graphTag,
      @required this.moreInfo})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    var data = [
      new TimeSeriesSales(new DateTime(2017, 9, 19), 5),
      new TimeSeriesSales(new DateTime(2017, 9, 26), 25),
      new TimeSeriesSales(new DateTime(2017, 10, 3), 100),
      new TimeSeriesSales(new DateTime(2017, 10, 10), 75),
    ];

    var series = [
      charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales',
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data,
      ),
    ];

    var chart = charts.TimeSeriesChart(
      series,
      animate: true,
      behaviors: [
        charts.RangeAnnotation([
          charts.LineAnnotationSegment(
              DateTime(2017, 10, 4), charts.RangeAnnotationAxisType.domain,
              startLabel: 'Oct 4'),
          charts.LineAnnotationSegment(
              DateTime(2017, 10, 15), charts.RangeAnnotationAxisType.domain,
              endLabel: 'Oct 15'),
        ])
      ],
    );

    Widget _linerGraph = Flexible(
      child: chart,
      flex: 1,
    );
    return GrapCard(
      graphColor: graphColor,
      graphSubtitle: graphSubtitle,
      graphTag: graphTag,
      graphTitle: graphTitle,
      graphWidget: _linerGraph,
      moreInfo: moreInfo,
      sender: moreInfo == "no" ? "No" : "line",
    );
  }
}

/// Sample time series data type.
class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}
