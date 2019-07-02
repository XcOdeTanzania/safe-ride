import 'package:flutter/material.dart';
import 'package:safe_ride/styles/theme.dart';
import 'package:safe_ride/views/pages/home_page.dart';
import 'package:safe_ride/views/pages/insights_page.dart';
import 'package:safe_ride/views/pages/login_page.dart';
import 'package:safe_ride/views/pages/profile_page.dart';
import 'package:safe_ride/views/screens/AnimatedSplashScreen.dart';

import 'constants/constants.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  bool _isAuthenticated = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neatlux',
      debugShowCheckedModeBanner: false,
      theme: ArchSampleTheme.theme,
      home: AnimatedSplashScreen(),
      routes: {
        homeScreen: (BuildContext context) =>
            _isAuthenticated ? HomePage() : LoginPage(),
        profileScreen: (BuildContext context) => ProfilePage(),
        insightsScreen: (BuildContext context) => InsightsPage(),
      },
    );
  }
}
