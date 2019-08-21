import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:safe_ride/data/main.dart';
import 'package:safe_ride/views/pages/map_page.dart';
import 'package:safe_ride/views/widgets/alerts/custom_circular_progress_bar.dart';
import 'package:safe_ride/views/widgets/alerts/no_data.dart';
import 'package:safe_ride/styles/style.dart' as ThemeColor;
import 'package:scoped_model/scoped_model.dart';

class PoliceStationPage extends StatefulWidget {
  final MainModel model;

  const PoliceStationPage({Key key, @required this.model}) : super(key: key);
  @override
  _PoliceStationPageState createState() => _PoliceStationPageState();
}

class _PoliceStationPageState extends State<PoliceStationPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    widget.model.fetchStations().then((value) {
      print('Am called');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Police Stations'),
        ),
        body: model.isFetchingStationData
            ? CustomCircularProgressBar(
                divider: 2,
              )
            : model.getStations().isEmpty
                ? NoDataYet(
                    color: ThemeColor.Colors.saferidePrimaryColor,
                    icon: Icons.library_books,
                    title: 'No Police Stations',
                  )
                : ListView.separated(
                    itemCount: model.getStations().length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        onTap: () {
                          if (model.getStations()[index].latitude ==
                              0.00000000000000) {
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: ListTile(
                                leading: Icon(
                                  Icons.error,
                                  color: Colors.red,
                                ),
                                title: Text(model.getStations()[index].name +
                                    ' station has no cordinates'),
                                trailing: Icon(
                                  Icons.error,
                                  color: Colors.red,
                                ),
                              ),
                            ));
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MapPage(
                                        model: model,
                                        station: model.getStations()[index],
                                      )),
                            );
                          }
                        },
                        leading: Icon(FontAwesomeIcons.home),
                        title: Text(model.getStations()[index].name),
                        subtitle: Text(model.getStations()[index].district),
                        trailing: FlatButton.icon(
                          icon: Icon(
                            Icons.remove_red_eye,
                            color: Colors.pink,
                          ),
                          label: Text('View'),
                          onPressed: () {
                            if (model.getStations()[index].latitude ==
                                0.00000000000000) {
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: ListTile(
                                  leading: Icon(
                                    Icons.error,
                                    color: Colors.red,
                                  ),
                                  title: Text(model.getStations()[index].name +
                                      ' station has no cordinates'),
                                  trailing: Icon(
                                    Icons.error,
                                    color: Colors.red,
                                  ),
                                ),
                              ));
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MapPage(
                                          model: model,
                                          station: model.getStations()[index],
                                        )),
                              );
                            }
                          },
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Divider(
                        color: Colors.pinkAccent,
                      ),
                    ),
                  ),
      );
    });
  }
}
