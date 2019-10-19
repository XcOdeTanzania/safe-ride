import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'graph_card.dart';



class GroupBarGraph extends StatelessWidget {
  //final List<charts.Series> seriesList;
  //final bool animate;
  final Color graphColor;
  final String graphTitle;
  final String graphSubtitle;
  final String graphTag;
  final String moreInfo;

  const GroupBarGraph(
      {Key key,
      this.graphColor,
      this.graphTitle,
      this.graphSubtitle,
      this.graphTag,
      this.moreInfo})
      : super(key: key);

  //GroupedFillColorBarChart(this.seriesList, {this.animate});

  // factory GroupedFillColorBarChart.withSampleData() {
  //   return new GroupedFillColorBarChart(
  //     _createSampleData(),
  //     // Disable animations for image tests.
  //     animate: false,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    var chart = new charts.BarChart(
      _createSampleData(),
      animate: true,
      // Configure a stroke width to enable borders on the bars.
      defaultRenderer: new charts.BarRendererConfig(
          groupingType: charts.BarGroupingType.grouped, strokeWidthPx: 2.0),
    );
    var chartWidget =  Flexible(
      child: chart,
      flex: 1,
    );
    return GrapCard(
      graphTitle: graphTitle,
      graphSubtitle: graphSubtitle,
      graphTag: graphTag,
      graphColor: Colors.red,
      graphWidget: chartWidget,
      moreInfo: moreInfo,
      sender: "bar",
    );
  }

  /// Create series list with multiple series
  static List<charts.Series<OrdinalSales, String>> _createSampleData() {
    final desktopSalesData = [
      new OrdinalSales('week1', 54),
      new OrdinalSales('week2', 60),
      new OrdinalSales('week3', 75),
      new OrdinalSales('week4', 80),
    ];

    final tableSalesData = [
      new OrdinalSales('week1', 100),
      new OrdinalSales('week2', 80),
      new OrdinalSales('week3', 90),
      new OrdinalSales('week4', 85),
    ];

    final mobileSalesData = [
      new OrdinalSales('week1', 10),
      new OrdinalSales('week2', 40),
      new OrdinalSales('week3', 50),
      new OrdinalSales('week4', 35),
    ];

    return [
      // Blue bars with a lighter center color.
      new charts.Series<OrdinalSales, String>(
        id: 'Desktop',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: desktopSalesData,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        fillColorFn: (_, __) =>
            charts.MaterialPalette.blue.shadeDefault.lighter,
      ),
      // Solid red bars. Fill color will default to the series color if no
      // fillColorFn is configured.
      new charts.Series<OrdinalSales, String>(
        id: 'Tablet',
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: tableSalesData,
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (OrdinalSales sales, _) => sales.year,
      ),
      // Hollow green bars.
      new charts.Series<OrdinalSales, String>(
        id: 'Mobile',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: mobileSalesData,
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        fillColorFn: (_, __) => charts.MaterialPalette.transparent,
      ),
    ];
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}
