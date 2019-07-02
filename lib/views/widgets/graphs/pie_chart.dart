import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

import 'graph_card.dart';


class PiecChart extends StatelessWidget {
  final Color graphColor;
  final String graphTitle;
  final String graphSubtitle;
  final String graphTag;
  final String moreInfo;

  const PiecChart(
      {Key key,
      this.graphColor,
      this.graphTitle,
      this.graphSubtitle,
      this.graphTag,
      this.moreInfo})
      : super(key: key);

  //final List<charts.Series> seriesList;
  // final bool animate;

  // PiecChart(this.seriesList, {this.animate});

  /// Creates a [PieChart] with sample data and no transition.
  // factory PiecChart.withSampleData() {
  //   return new PiecChart(
  //     _createSampleData(),
  //     // Disable animations for image tests.
  //     animate: false,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    var chart = charts.PieChart(_createSampleData(),
        animate: true,
        // Configure the width of the pie slices to 60px. The remaining space in
        // the chart will be left as a hole in the center.
        //
        // [ArcLabelDecorator] will automatically position the label inside the
        // arc if the label will fit. If the label will not fit, it will draw
        // outside of the arc with a leader line. Labels can always display
        // inside or outside using [LabelPosition].
        //
        // Text style for inside / outside can be controlled independently by
        // setting [insideLabelStyleSpec] and [outsideLabelStyleSpec].
        //
        // Example configuring different styles for inside/outside:
        //       new charts.ArcLabelDecorator(
        //          insideLabelStyleSpec: new charts.TextStyleSpec(...),
        //          outsideLabelStyleSpec: new charts.TextStyleSpec(...)),
        defaultRenderer: new charts.ArcRendererConfig(
            arcWidth: 60,
            arcRendererDecorators: [new charts.ArcLabelDecorator()]));
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
      sender: "PIE",
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<LinearSales, int>> _createSampleData() {
    final data = [
      new LinearSales(0, 60),
      new LinearSales(1, 80),
      new LinearSales(2, 120),
      new LinearSales(3, 200),
    ];

    return [
      new charts.Series<LinearSales, int>(
        id: 'Sales',
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: (LinearSales row, _) => '${row.year}: ${row.sales}',
      )
    ];
  }
}

/// Sample linear data type.
class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}
