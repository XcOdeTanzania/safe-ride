import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';
import 'package:safe_ride/api/api.dart';
import 'package:safe_ride/models/accelerometer.dart';
import 'package:safe_ride/models/gps_logs.dart';
import 'package:safe_ride/models/gyroscope_logs.dart';
import 'package:safe_ride/models/report.dart';
import 'package:safe_ride/models/station.dart';
import 'package:safe_ride/models/user.dart';
import 'package:safe_ride/utils/enums.dart';

import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

mixin ConnectedSafeRideModel on Model {
  //fire base current user..
  FirebaseUser _currentUser;

  //user type
  UserType _userType;

  //fire base autheFnticated user..
  FirebaseUser _user;
  List<GPSLogs> _availableGPSLogs = [];
  List<AccelerometerLogs> _availableAccelerometerLogs = [];
  List<GyroscopeLogs> _availableGyroscopeLogs = [];

  bool _showScreenShot = false;
  bool _loginLoader = false;

  List<Station> _availableStations;
  List<Report> _availableReports;

  File _pickedImage;

  bool _isFetchingStationData = false;
  bool _isFetchingReportData = false;
  bool _isSubmitingReportData = false;
}
mixin UtilityModel on ConnectedSafeRideModel {
  File file;
  void chooseAmImage() async {
    file = await ImagePicker.pickImage(source: ImageSource.gallery);
    _pickedImage = file;
    notifyListeners();
  }

  //get the choosen Image.

  File get pickedImage {
    return _pickedImage;
  }

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

  void setUserType({@required UserType type}) {
    _userType = type;
    notifyListeners();
  }

//screenshots...
  get showScreenShot => _showScreenShot;

  void setScreenShot({@required bool status}) {
    _showScreenShot = status;
    print('object');
    notifyListeners();
  }

  //loaders .... _loginLoader
  get loginLoader => _loginLoader;

  void setLoginLoader({@required bool status}) {
    _loginLoader = status;

    notifyListeners();
  }

  UserType get userType => _userType;

  bool get isFetchingStationData => _isFetchingStationData;
  bool get isFetchingReportData => _isFetchingReportData;
  bool get isSubmitingReportData => _isSubmitingReportData;
}

mixin LoginModel on ConnectedSafeRideModel {
  PublishSubject<bool> _userSubject = PublishSubject();

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static User _authenticatedUser;

  Future<void> autoAuthenticate() async {
    await _auth.currentUser().then((currentUser) {
      if (currentUser != null) {
        _currentUser = currentUser;
        notifyListeners();
        _userSubject.add(true);
      } else {
        _userSubject.add(false);
      }
    });
    notifyListeners();
  }

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

  Future<Map<String, dynamic>> signInWithFaceBook() async {
    final FacebookLogin facebookLogin = FacebookLogin();
    bool success = false;
    String message = 'Error occured';
    FacebookLoginResult result =
        await facebookLogin.logInWithReadPermissions(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        _signInWithFacebook(result.accessToken.token)
            .then((Map<String, dynamic> result) {
          success = result['success'];
          message = result['message'];
        });
//        _sendTokenToServer(result.accessToken.token);
//        _showLoggedInUI();
        break;
      case FacebookLoginStatus.cancelledByUser:
        success = false;
        message = 'Facebook Signin cancelled';
        // _showCancelledMessage();
        break;
      case FacebookLoginStatus.error:
        success = false;
        message = 'Error in Signin with Facebook ${result.errorMessage}';
        //  _showErrorOnUI(result.errorMessage);
        break;
    }
    Map<String, dynamic> signInResult = {
      "message": message,
      "success": success
    };

    return signInResult;
  }

  Future<Map<String, dynamic>> _signInWithFacebook(String token) async {
    bool _success = false;
    String _message;

    final AuthCredential credential = FacebookAuthProvider.getCredential(
        accessToken: token //_tokenController.text,
        );

    try {
      final FirebaseUser fbUser = await _auth.signInWithCredential(credential);
      assert(fbUser.email != null);
      assert(fbUser.displayName != null);
      assert(!fbUser.isAnonymous);
      assert(await fbUser.getIdToken() != null);

      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);
    } on PlatformException catch (e) {
      _success = false;
      switch (e.code) {
        case 'ERROR_INVALID_CREDENTIAL':
          _message = 'User verification failed, Invalid Credential';
          break;
        case 'ERROR_USER_DISABLED':
          _message =
              'Access denied, user disabled. contact administrator for assistance';
          break;
        case 'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL':
          final graphResponse = await http.get(
              'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token');
          final profile = json.decode(graphResponse.body);
          print('Email: ${profile['email']}');
          List<String> providers =
              await _auth.fetchSignInMethodsForEmail(email: profile['email']);
          String existingProvider = '';
          for (String provider in providers) {
            print('provider : $provider');
            existingProvider = provider;
          }
          _message =
              'Not new here, already registered with $existingProvider with ${profile['email']}';
          break;
        case 'ERROR_OPERATION_NOT_ALLOWED':
        case 'ERROR_INVALID_ACTION_CODE':
          _message = 'Error During Signing. ${e.message}';
          break;
        case 'ERROR_NETWORK_REQUEST_FAILED':
          _message = 'Network error, check your internet connection';
          break;
      }
    }
    if (user != null) {
      _message = 'User signin successfuly';
      _success = true;
    } else {
      _success = false;
    }
    final Map<String, dynamic> _responseMap = {
      'success': _success,
      'message': _message
    };

    return _responseMap;
  }

  Future<Map<String, dynamic>> signInWithEmail(
      {@required String email, @required String password}) async {
    bool _success = false;
    String _message = '';
    bool _linking = false;

    try {
      final FirebaseUser mailUser = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print(mailUser);
    } on PlatformException catch (e) {
      switch (e.code) {
        case 'ERROR_EMAIL_ALREADY_IN_USE':
          print('Email: $email');
          List<String> providers =
              await _auth.fetchSignInMethodsForEmail(email: email);
          for (String provider in providers) {
            print(provider);
          }
          _message = 'The email address is already in use by another account.';
          _linking = true;
          break;
        case 'ERROR_WEAK_PASSWORD':
          _message = 'Password too week, minimum six characters required';
          _linking = false;
          break;
        case 'ERROR_INVALID_EMAIL':
          _message = 'Invalid Email';
          _linking = false;
          break;
        case 'ERROR_NETWORK_REQUEST_FAILED':
          _message =
              'Error in network, make sure you are connected to internet';
          _linking = false;
          break;
        default:
          _message = 'Error occured during signing in';
          _linking = false;
          break;
      }
    }
    if (user != null) {
      _success = true;
      _message = 'Signin successfuly';
    } else {
      _success = false;
    }
    Map<String, dynamic> respond = {
      'success': _success,
      'message': _message,
      'linking': _linking
    };
    return respond;
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

mixin StationModel on ConnectedSafeRideModel {
  // fetch all stations
  Future<bool> fetchStations() async {
    bool hasError = true;
    _isFetchingStationData = true;
    notifyListeners();

    final List<Station> _fetchedStations = [];
    try {
      final http.Response response = await http.get(api + "stations");

      final Map<String, dynamic> data = json.decode(response.body);

      if (data['status']) {
        data['stations'].forEach((pieceData) {
          final station = Station.fromMap(pieceData);

          _fetchedStations.add(station);
        });
        hasError = false;
      }
    } catch (error) {
      hasError = true;
    }
    _availableStations = _fetchedStations;
    _isFetchingStationData = false;
    notifyListeners();

    return hasError;
  }

  //getters
  List<Station> getStations() {
    if (_availableStations == null) {
      return <Station>[];
    }
    return List<Station>.from(_availableStations);
  }
}

mixin ReportModel on ConnectedSafeRideModel {
  // fetch all reports
  Future<bool> fetchReports() async {
    bool hasError = true;
    _isFetchingReportData = true;
    notifyListeners();

    final List<Report> _fetchedReports = [];
    try {
      final http.Response response = await http.get(api + "reports");

      final Map<String, dynamic> data = json.decode(response.body);

      if (data['status']) {
        data['reports'].forEach((pieceData) {
          final report = Report.fromMap(pieceData);

          _fetchedReports.add(report);
        });
        hasError = false;
      }
    } catch (error) {
      hasError = true;
    }
    _availableReports = _fetchedReports;
    _isFetchingReportData = false;
    notifyListeners();

    return hasError;
  }

  // post  Report.
  Future<bool> postReport(
      {@required String message,
      @required String platNo,
      @required int stationId}) async {
    _isSubmitingReportData = true;
    bool hasError = false;
    notifyListeners();

    Dio dio = new Dio();
    FormData formdata = new FormData();
    formdata.add("file", new UploadFileInfo(_pickedImage, "image.jpeg"));
    formdata.add("message", message);
    formdata.add("plat_no", platNo);

    dio
        .post(api + "report/" + stationId.toString(),
            data: formdata,
            options: Options(
                method: 'POST',
                responseType: ResponseType.json // or ResponseType.JSON
                ))
        .then((response) {
      final Map<String, dynamic> data = response.data;

      if (data['status']) {
        hasError = false;
        _onCreateReport(
            reportId: data['report']['id'],
            message: data['report']['message'],
            platNo: data['report']['platNo'],
            image: data['report']['image'],
            stationId: data['report']['station_id']);
      } else {
        hasError = true;
      }
    }).catchError((error) {
      hasError = true;
    });

    _isSubmitingReportData = false;
    resetImage();
    notifyListeners();
    return hasError;
  }

  void resetImage() {
    _pickedImage = null;
    notifyListeners();
  }

  void _onCreateReport({
    @required int reportId,
    @required String message,
    @required String platNo,
    @required int stationId,
    @required String image,
  }) {
    final createdReport = Report(
        id: reportId,
        image: image,
        message: message,
        platNo: platNo,
        stationId: stationId);
    _availableReports.add(createdReport);

    notifyListeners();
  }

  //getters
  List<Report> getReports() {
    if (_availableReports == null) {
      return <Report>[];
    }
    return List<Report>.from(_availableReports);
  }
}
