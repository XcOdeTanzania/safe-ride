import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:safe_ride/views/widgets/graphs/bar_graph.dart';
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
    final double _containerHeight = MediaQuery.of(context).size.height/2;
    Widget _gyroscope = LineGraph(
      graphTitle: "Gyroscope Variations",
      graphSubtitle: "Divice tilt per day",
      graphTag: "Gyroscope",
      moreInfo: "More break downs",
      graphColor: Colors.cyan,
    );
    Widget _accelerometer = LineGraph(
      graphTitle: "Based on Angular speed",
      graphSubtitle: "Per Jounery",
      graphTag: "Accelerometer",
      moreInfo: "More break downs",
      graphColor: Colors.green[400],
    );

    Widget _speedVsTime = GroupBarGraph(
      graphTitle: "Speed VS Time",
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
    Widget _drivingGraph = BarGraph(
      graphTitle: "DRIVER GRAPH",
      graphSubtitle: '',
      graphTag: '',
      moreInfo: '',
      graphColor: Colors.cyan,
    );

    Widget _speed = LineGraph(
      graphTitle: "Speed",
      graphSubtitle: '',
      graphTag: '',
      moreInfo: "no",
      graphColor: Colors.cyan,
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
                  child: _accelerometer,
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
                  child: _drivingGraph,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: _containerHeight,
                  child: _speed,
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
