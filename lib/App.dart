import 'package:flutter/material.dart';
import 'package:safe_ride/styles/theme.dart';
import 'package:safe_ride/views/pages/accelerometer_logs_page.dart';
import 'package:safe_ride/views/pages/gps_logs_page.dart';
import 'package:safe_ride/views/pages/gyroscope_logs_page.dart';
import 'package:safe_ride/views/pages/home_page.dart';
import 'package:safe_ride/views/pages/insights_page.dart';
import 'package:safe_ride/views/pages/login_page.dart';
import 'package:safe_ride/views/pages/logs_page.dart';

import 'package:safe_ride/views/pages/police_stations_page.dart';
import 'package:safe_ride/views/pages/profile_page.dart';
import 'package:safe_ride/views/pages/reports_page.dart';
import 'package:safe_ride/views/pages/share_route.dart';
import 'package:safe_ride/views/screens/AnimatedSplashScreen.dart';
import 'package:scoped_model/scoped_model.dart';

import 'constants/constants.dart';
import 'data/main.dart';
import 'views/pages/notification_page.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  bool _isAuthenticated = false;
  final MainModel _model = MainModel();

  @override
  void initState() {
    _model.autoAuthenticate();
    _model.loadNextOfKin();
    _model.userSubject.listen((bool isAuthenticated) {
      setState(() {
        _isAuthenticated = isAuthenticated;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      child: MaterialApp(
        title: 'SAFE RIDE',
        debugShowCheckedModeBanner: false,
        theme: ArchSampleTheme.theme,
        home: AnimatedSplashScreen(),
        routes: {
          homeScreen: (BuildContext context) => _isAuthenticated
              ? HomePage(
                  model: _model,
                )
              : LoginPage(),
          profileScreen: (BuildContext context) => ProfileScreen(),
          insightsScreen: (BuildContext context) => InsightsPage(),
          logsScreen: (BuildContext context) => LogsPage(),
          shareRouteScreen: (BuildContext context) => ShareRoute(),
          gpsScreen: (BuildContext context) => GPSLogsPage(),
          accelerometerScreen: (BuildContext context) =>
              AccelerometerLogsPage(),
          gyroscopeScreen: (BuildContext context) => GyroscopeLogsPage(),
          notificationScreen: (BuildContext context) => NotificationPage(),
          reportScreen: (BuildContext context) => ReportsPage(
                model: _model,
              ),
          stationScreen: (BuildContext context) => PoliceStationPage(
                model: _model,
              ),
        },
      ),
      model: _model,
    );
  }
}
