import 'package:flutter/material.dart';
import 'package:safe_ride/data/main.dart';
import 'package:safe_ride/views/widgets/alerts/no_data.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:safe_ride/styles/style.dart' as ThemeColor;

class GyroscopeLogsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Scaffold(
            appBar: AppBar(
              title: Text('Gyroscope Logs'),
              actions: <Widget>[
                model.getGyroscopeLogs().length > 0
                    ? IconButton(
                        icon: Icon(Icons.sync),
                        tooltip: 'Sync',
                        onPressed: () {
                          model.sycLocallySavedData();
                        },
                      )
                    : Container()
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(48.0),
                child: Theme(
                  data: Theme.of(context).copyWith(accentColor: Colors.white),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    height: 48.0,
                    alignment: Alignment.center,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: Text(
                              'X/ms2',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: Text(
                              'Y/ms2',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: Text(
                              'Z/ms2',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            body: model.getGyroscopeLogs().length > 0
                ? ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return Row(
                        children: <Widget>[
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: Text(
                                model.getGyroscopeLogs()[index].x.toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: Text(
                                model.getGyroscopeLogs()[index].y.toString(),
                                style: TextStyle(
                                    color: Colors.black26,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: Text(
                                model.getGyroscopeLogs()[index].z.toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  )
                : NoDataYet(
                    color: ThemeColor.Colors.saferidePrimaryColor,
                    icon: Icons.shutter_speed,
                    title: 'No data recorded yet',
                  ));
      },
    );
  }
}
