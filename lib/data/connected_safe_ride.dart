import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';
import 'package:safe_ride/models/accelerometer.dart';
import 'package:safe_ride/models/gps_logs.dart';
import 'package:safe_ride/models/gyroscope_logs.dart';
import 'package:safe_ride/models/user.dart';
import 'package:scoped_model/scoped_model.dart';

mixin ConnectedSafeRideModel on Model {
  //fire base current user..
  FirebaseUser _currentUser;

  //fire base autheFnticated user..
  FirebaseUser _user;
  List<GPSLogs> _availableGPSLogs = [];
  List<AccelerometerLogs> _availableAccelerometerLogs = [];
  List<GyroscopeLogs> _availableGyroscopeLogs = [];

  bool _showScreenShot = false;
}
mixin UtilityModel on ConnectedSafeRideModel {
  List<GPSLogs> getGPSLogs() {
    if (_availableGPSLogs == null) {
      return <GPSLogs>[];
    }
    return List<GPSLogs>.from(_availableGPSLogs);
  }

  List<AccelerometerLogs> getAccelerometerLogs() {
    if (_availableAccelerometerLogs == null) {
      return <AccelerometerLogs>[];
    }
    return List<AccelerometerLogs>.from(_availableAccelerometerLogs);
  }

  List<GyroscopeLogs> getGyroscopeLogs() {
    if (_availableGyroscopeLogs == null) {
      return <GyroscopeLogs>[];
    }
    return List<GyroscopeLogs>.from(_availableGyroscopeLogs);
  }

  void addNewGPSLog({@required GPSLogs log}) {
    _availableGPSLogs.add(log);
    notifyListeners();
  }

  void addNewAccelerometerLog({@required AccelerometerLogs log}) {
    _availableAccelerometerLogs.add(log);
    notifyListeners();
  }

  void addNewGyroscopeLog({@required GyroscopeLogs log}) {
    _availableGyroscopeLogs.add(log);
    notifyListeners();
  }

//screenshots...
  get showScreenShot => _showScreenShot;

  void setScreenShot({@required bool status}) {
    _showScreenShot = status;
    print('object');
    notifyListeners();
  }
}
mixin LoginModel on ConnectedSafeRideModel {
  PublishSubject<bool> _userSubject = PublishSubject();

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static User _authenticatedUser;

  Future<bool> signInWithGoogle() async {
    bool status;

    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    _user = await _auth.signInWithCredential(credential);

    assert(_user.email != null);
    assert(_user.displayName != null);
    assert(!_user.isAnonymous);
    assert(await _user.getIdToken() != null);

    _currentUser = await _auth.currentUser();
    assert(_user.uid == _currentUser.uid);

    if (_user != null) {
      _authenticatedUser = User(
          email: _currentUser.email,
          id: _currentUser.uid,
          token: _currentUser.getIdToken().toString(),
          photoUrl: _currentUser.photoUrl,
          displayname: _currentUser.displayName);
      status = true;
      _userSubject.add(true);
    } else {
      status = false;
    }
    _userSubject.add(true);
    notifyListeners();
    return status;
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut().then((val) {
      _userSubject.add(false);

      notifyListeners();
    });
  }

  PublishSubject<bool> get userSubject {
    return _userSubject;
  }

  //Get Current User...
  FirebaseUser get currentUser => _currentUser;

  //Get User...
  FirebaseUser get user => _user;

  //Get Authenticated user..

  User get authenticatedUser => _authenticatedUser;
}
