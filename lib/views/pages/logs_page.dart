import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:safe_ride/constants/constants.dart';
import 'package:safe_ride/data/main.dart';
import 'package:scoped_model/scoped_model.dart';

class LogsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Scaffold(
            appBar: AppBar(
              title: Text('Logs'),
            ),
            body: ListView(
              children: <Widget>[
                ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, gpsScreen);
                  },
                  leading: Icon(Icons.gradient),
                  title: Text('GPS Logs'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, gyroscopeScreen);
                  },
                  leading: Icon(Icons.shutter_speed),
                  title: Text('Gyroscope Logs'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, accelerometerScreen);
                  },
                  leading: Icon(FontAwesomeIcons.car),
                  title: Text('Accelerometer Logs'),
                ),
              ],
            ));
      },
    );
  }
}
