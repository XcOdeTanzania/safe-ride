import 'package:flutter/material.dart';
import 'package:safe_ride/styles/theme.dart';
import 'package:safe_ride/views/pages/home_page.dart';
import 'package:safe_ride/views/pages/insights_page.dart';
import 'package:safe_ride/views/pages/login_page.dart';
import 'package:safe_ride/views/pages/logs_page.dart';
import 'package:safe_ride/views/pages/profile_page.dart';
import 'package:safe_ride/views/screens/AnimatedSplashScreen.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'constants/constants.dart';
import 'data/main.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  bool _isAuthenticated = false;
  final MainModel _model = MainModel();

  @override
  void initState() {
//      _model.userSubject.listen((bool isAuthenticated) {
//      setState(() {
//        _isAuthenticated = isAuthenticated;
//      });
//    });


    super.initState();
  }

  bool _isLoging(){
    bool login ;
    print('YYYYYYYYYYYYYYYYYYYYY login in check YYYYYYYYYYYYYYYYYYY');
    final FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.currentUser().then((currentUser) {
      if (currentUser != null){
        login = true;
        print('Login as: ${currentUser.displayName}');
        currentUser.getIdToken(refresh: false).then((token){
          print('XXXXXXXXXXXXXXXXX');
          print(token);
        },onError: (error){
          print('Error in token fetch: $error');
        });
      }
      else   login = false;
    }, onError: (error){
      print('ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ');
      print('Error in user checking');
    });
    return true;
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
          homeScreen: (BuildContext context) =>
              _isLoging() ? HomePage(model: _model,) : LoginPage(),
          profileScreen: (BuildContext context) => ProfilePage(),
          insightsScreen: (BuildContext context) => InsightsPage(),
          logsScreen: (BuildContext context) => LogsPage(),
        },
      ),
      model: _model,
    );
  }
}
