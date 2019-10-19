import 'package:flutter/material.dart';

import 'package:charts_flutter/flutter.dart' as charts;

import 'graph_card.dart';

class LineGraph extends StatelessWidget {
  final Color graphColor;
  final String graphTitle;
  final String graphSubtitle;
  final String graphTag;
  final String moreInfo;
  final List<TimeSeriesSales> data;

  const LineGraph(
      {Key key,
      @required this.graphColor,
      @required this.graphTitle,
      @required this.graphSubtitle,
      @required this.graphTag,
      @required this.moreInfo,
      @required this.data})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
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
              DateTime(2019, 10, 4), charts.RangeAnnotationAxisType.domain,
              startLabel: '04 Oct'),
          charts.LineAnnotationSegment(
              DateTime(2019, 10, 15), charts.RangeAnnotationAxisType.domain,
              endLabel: '17 Oct'),
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
