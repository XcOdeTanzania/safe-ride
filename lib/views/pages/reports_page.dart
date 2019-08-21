import 'package:flutter/material.dart';
import 'package:safe_ride/data/main.dart';
import 'package:safe_ride/views/widgets/alerts/custom_circular_progress_bar.dart';
import 'package:safe_ride/views/widgets/alerts/no_data.dart';
import 'package:safe_ride/styles/style.dart' as ThemeColor;
import 'package:safe_ride/views/widgets/cards/report_card.dart';
import 'package:scoped_model/scoped_model.dart';

class ReportsPage extends StatefulWidget {
  final MainModel model;

  const ReportsPage({Key key, @required this.model}) : super(key: key);
  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  @override
  void initState() {
    widget.model.fetchReports().then((value) {
      print('Am called');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Reports'),
        ),
        body: model.isFetchingReportData
            ? CustomCircularProgressBar(divider: 2,)
            : model.getReports().isEmpty
                ? NoDataYet(
                    color: ThemeColor.Colors.saferidePrimaryColor,
                    icon: Icons.library_books,
                    title: 'No Reports recorded',
                  )
                : ListView.builder(
                  itemCount:model.getReports().length ,
                    itemBuilder: (BuildContext context, int index) {
                      return ReportCard(
                        onTap: () {},
                        report: model.getReports()[index],
                      );
                    },
                  ),
      );
    });
  }
}
