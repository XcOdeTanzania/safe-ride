import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:safe_ride/data/main.dart';
import 'package:safe_ride/models/report.dart';
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
      return DefaultTabController(
        child: Scaffold(
            appBar: AppBar(
              title: Text('Reports'),
              bottom: TabBar(
                tabs: <Widget>[
                  Tab(
                    text: 'Accident',
                  ),
                  Tab(
                    text: 'Speed',
                  )
                ],
              ),
            ),
            body: model.getReports().isEmpty
                ? NoDataYet(
                    color: ThemeColor.Colors.saferidePrimaryColor,
                    icon: Icons.library_books,
                    title: 'No Reports recorded',
                  )
                : TabBarView(
                    children: <Widget>[
                      ListView.builder(
                        itemCount: model.getReports().length,
                        itemBuilder: (BuildContext context, int index) {
                          return model.getReports()[index].reportId == 1
                              ? ReportCard(
                                  onTap: () => _showBottomSheet(
                                      context: context,
                                      model: model,
                                      report: model.getReports()[index]),
                                  report: model.getReports()[index],
                                  title: 'Accident Type:',
                                )
                              : Container();
                        },
                      ),
                      ListView.builder(
                        itemCount: model.getReports().length,
                        itemBuilder: (BuildContext context, int index) {
                          return model.getReports()[index].reportId == 2
                              ? ReportCard(
                                  onTap: () => _showBottomSheet(
                                      context: context,
                                      model: model,
                                      report: model.getReports()[index]),
                                  report: model.getReports()[index],
                                  title: 'Plate No',
                                )
                              : Container();
                        },
                      ),
                    ],
                  )),
        length: 2,
      );
    });
  }

  void _showBottomSheet(
      {@required BuildContext context,
      @required Report report,
      @required MainModel model}) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30))),
          child: Wrap(
            children: <Widget>[
              Container(
                height: 20,
              ),
              Center(
                  child: Text(
                'Options',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              )),
              Divider(
                indent: 10,
                color: Colors.white,
                endIndent: 10,
              ),
              ListTile(
                leading: Icon(
                  FontAwesomeIcons.bookOpen,
                  color: Colors.white,
                ),
                title: Text('View', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              Divider(
                indent: 10,
                color: Colors.grey,
                endIndent: 10,
              ),
              ListTile(
                leading: Icon(
                  FontAwesomeIcons.trash,
                  color: Colors.white,
                ),
                title: Text('Delete', style: TextStyle(color: Colors.white)),
                onTap: () {
                  _showDialog(context, model, report);
                },
              )
            ],
          ),
        );
      },
      context: context,
    );
  }

  void _showDialog(BuildContext context, MainModel model, Report report) {
    if (Platform.isAndroid)
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('delete Report'),
              content:
                  Text('Are you sure you want to proceed with this action?'),
              actions: <Widget>[
                FlatButton(
                  child: Text('CANCEL'),
                  color: Theme.of(context).buttonColor,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text('DELETE'),
                  color: Colors.red,
                  onPressed: () {
                    // model.deleteProduct(id: product.id).then((onValue) {
                    //   Navigator.pop(context);
                    //   Navigator.pop(context);
                    // });
                  },
                )
              ],
            );
          });

    if (Platform.isIOS)
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text('Delete Product'),
              content:
                  Text('Are you sure you want to proceed with this action?'),
              actions: <Widget>[
                FlatButton(
                  child: Text('CANCEL'),
                  textColor: Theme.of(context).buttonColor,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text('DELETE'),
                  textColor: Colors.red,
                  onPressed: () {
                    model.deleteReport(reportId: report.id).then((onValue) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    });
                  },
                )
              ],
            );
          });
  }
}
