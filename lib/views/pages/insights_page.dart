import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:safe_ride/views/widgets/graphs/group_bar_chart.dart';
import 'package:safe_ride/views/widgets/graphs/line_graph.dart';
import 'package:safe_ride/views/widgets/graphs/pie_chart.dart';

class InsightsPage extends StatefulWidget {
  @override
  _InsightsPageState createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {
  @override
  Widget build(BuildContext context) {
    final double _containerHeight = MediaQuery.of(context).size.height / 2;
    Widget _gyroscope = LineGraph(
      graphTitle: "Speed Variations with Time",
      graphSubtitle: "Divice tilt per day",
      graphTag: "Accelerometer",
      moreInfo: "More break downs",
      graphColor: Colors.cyan,
      data: data1,
    );
    Widget _accelerometer = LineGraph(
      graphTitle: "Based on Angular speed",
      graphSubtitle: "Per Jounery",
      graphTag: "Gyroscope",
      moreInfo: "More break downs",
      graphColor: Colors.green[400],
      data: data2,
    );

    Widget _speedVsTime = GroupBarGraph(
      graphTitle: "Average Speed Drive",
      graphSubtitle: '',
      graphTag: '',
      moreInfo: '',
      graphColor: Colors.cyan,
    );

    Widget _speedPie = PiecChart(
      graphTitle: "Speed Analysis",
      graphSubtitle: '',
      graphTag: '',
      moreInfo: '',
      graphColor: Colors.red,
    );

    Widget _speed = LineGraph(
      graphTitle: "Speed",
      graphSubtitle: '',
      graphTag: '',
      moreInfo: "no",
      graphColor: Colors.cyan,
      data: data3,
    );

    Widget _buildTabletLayout() {
      return CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  height: _containerHeight,
                  child: _speedVsTime,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: _containerHeight,
                  child: _speedPie,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: _containerHeight,
                  child: _gyroscope,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: _containerHeight,
                  child: _speed,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: _containerHeight,
                  child: _accelerometer,
                ),
              ],
            ),
          ),
        ],
      );
    }

    Widget content = _buildTabletLayout();
    return Scaffold(
        appBar: AppBar(
          title: Text('Data Insights'),
        ),
        body: Center(child: content));
  }
}

//////
class ClicksPerYear {
  final String year;
  final int clicks;
  final charts.Color color;

  ClicksPerYear(this.year, this.clicks, Color color)
      : this.color = new charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}

var data1 = [
  new TimeSeriesSales(new DateTime(2019, 9, 07), 5),
  new TimeSeriesSales(new DateTime(2019, 9, 10), 25),
  new TimeSeriesSales(new DateTime(2019, 9, 11), 10),
  new TimeSeriesSales(new DateTime(2019, 10, 4), 20),
  new TimeSeriesSales(new DateTime(2019, 10, 6), 19),
  new TimeSeriesSales(new DateTime(2019, 10, 12), 50),
  new TimeSeriesSales(new DateTime(2019, 10, 19), 75),
];

var data2 = [
  new TimeSeriesSales(new DateTime(2019, 9, 07), 12),
  new TimeSeriesSales(new DateTime(2019, 9, 10), 25),
  new TimeSeriesSales(new DateTime(2019, 9, 11), 20),
  new TimeSeriesSales(new DateTime(2019, 10, 4), 12),
  new TimeSeriesSales(new DateTime(2019, 10, 6), 22),
  new TimeSeriesSales(new DateTime(2019, 10, 12), 30),
  new TimeSeriesSales(new DateTime(2019, 10, 19), 45),
];

var data3 = [
  new TimeSeriesSales(new DateTime(2019, 9, 07), 45),
  new TimeSeriesSales(new DateTime(2019, 9, 08), 30),
  new TimeSeriesSales(new DateTime(2019, 9, 09), 33),
  new TimeSeriesSales(new DateTime(2019, 9, 10), 20),
  new TimeSeriesSales(new DateTime(2019, 9, 11), 29),
  new TimeSeriesSales(new DateTime(2019, 9, 12), 50),
  new TimeSeriesSales(new DateTime(2019, 9, 13), 75),
  new TimeSeriesSales(new DateTime(2019, 9, 14), 55),
  new TimeSeriesSales(new DateTime(2019, 9, 15), 25),
  new TimeSeriesSales(new DateTime(2019, 9, 16), 80),
  new TimeSeriesSales(new DateTime(2019, 9, 17), 36),
  new TimeSeriesSales(new DateTime(2019, 9, 18), 19),
  new TimeSeriesSales(new DateTime(2019, 9, 19), 50),
  new TimeSeriesSales(new DateTime(2019, 9, 20), 75),
  new TimeSeriesSales(new DateTime(2019, 9, 21), 40),
  new TimeSeriesSales(new DateTime(2019, 9, 22), 25),
  new TimeSeriesSales(new DateTime(2019, 9, 23), 45),
  new TimeSeriesSales(new DateTime(2019, 9, 24), 20),
  new TimeSeriesSales(new DateTime(2019, 9, 25), 30),
  new TimeSeriesSales(new DateTime(2019, 9, 26), 50),
  new TimeSeriesSales(new DateTime(2019, 9, 27), 75),
  new TimeSeriesSales(new DateTime(2019, 9, 28), 60),
  new TimeSeriesSales(new DateTime(2019, 9, 29), 62),
  new TimeSeriesSales(new DateTime(2019, 9, 30), 75),
  new TimeSeriesSales(new DateTime(2019, 10, 1), 100),
  new TimeSeriesSales(new DateTime(2019, 10, 2), 98),
  new TimeSeriesSales(new DateTime(2019, 10, 3), 75),
  new TimeSeriesSales(new DateTime(2019, 10, 4), 92),
  new TimeSeriesSales(new DateTime(2019, 10, 5), 80),
  new TimeSeriesSales(new DateTime(2019, 10, 6), 88),
  new TimeSeriesSales(new DateTime(2019, 10, 7), 88),
  new TimeSeriesSales(new DateTime(2019, 10, 8), 81),
  new TimeSeriesSales(new DateTime(2019, 10, 9), 80),
  new TimeSeriesSales(new DateTime(2019, 10, 10), 79),
];
