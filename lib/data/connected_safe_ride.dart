import 'dart:async';
import 'dart:io';
import 'package:data_connection_checker/data_connection_checker.dart';
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

import 'package:shared_preferences/shared_preferences.dart';

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
  String _nextOfKin;
  bool _isNextOfKinEditing = false;

  File file;
  void selectImage() async {
    file = await ImagePicker.pickImage(source: ImageSource.gallery);
    _pickedImage = file;
    notifyListeners();
  }

  //get the choosen Image.

  File get imageFile {
    return _pickedImage;
  }

  set capturedImage(File imagePath) {
    _pickedImage = imagePath;
    notifyListeners();
  }

  String get nextOfKin => _nextOfKin;

  bool get isNextOfKinEditing => _isNextOfKinEditing;

  set toggleIsEditing(bool value) {
    _isNextOfKinEditing = value;
    notifyListeners();
  }

  ///load the next of kin
  loadNextOfKin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _nextOfKin = prefs.getString('nextOfKin');
  }

  ///add your next of kin
  addNextOfKin({@required nextOfKin}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('nextOfKin', nextOfKin);
    _nextOfKin = nextOfKin;
    notifyListeners();
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

          List<String> providers =
              await _auth.fetchSignInMethodsForEmail(email: profile['email']);
          String existingProvider = '';
          for (String provider in providers) {
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
        data['stations'].forEach((stationData) {
          final station = Station.fromMap(stationData);

          _fetchedStations.add(station);
        });
        hasError = false;
      }
    } catch (error) {
      print(error);
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
        data['reports'].forEach((reportData) {
          final report = Report.fromMap(reportData);

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

  Future<bool> deleteReport({@required int reportId}) async {
    bool hasError = true;
    try {
      final http.Response response =
          await http.delete(api + "report/" + reportId.toString());

      final Map<String, dynamic> data = json.decode(response.body);

      if (data['status']) {
        hasError = false;
        _availableReports.removeWhere((report) => report.id == reportId);
        notifyListeners();
      }
    } catch (error) {
      hasError = true;
    }

    return hasError;
  }

  // post  Report.
  Future<bool> postReport(
      {@required String message,
      @required String platNo,
      @required int stationId,
      @required File file,
      @required int reportId,
      @required String uid,
      @required double latitude,
      @required double longitude}) async {
    _isSubmitingReportData = true;
    bool hasError = false;
    notifyListeners();

    Dio dio = new Dio();
    FormData formdata = new FormData();
    formdata.add("file", new UploadFileInfo(file, "image.jpeg"));
    formdata.add("message", message);
    formdata.add("plat_no", platNo);
    formdata.add("report_id", reportId);
    formdata.add("uid", uid);
    formdata.add("user_type", "Normal");
    formdata.add("latitude", latitude);
    formdata.add("longitude", longitude);

    dio
        .post(api + "report/" + stationId.toString(),
            data: formdata,
            options: Options(
                method: 'POST',
                responseType: ResponseType.json // or ResponseType.JSON
                ))
        .then((response) {
      final Map<String, dynamic> data = response.data;
      print(data);
      if (response.statusCode == 200) {
        print('------------------------------------------');
        hasError = false;
        _onCreateReport(
            id: data['report']['id'],
            message: data['report']['message'],
            platNo: data['report']['plat_no'],
            image: data['report']['image'],
            stationId: data['report']['station_id'],
            createdAt: data['report']['created_at'],
            reportId: data['report']['report_id'],
            uid: data['report']['uid']);
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
    @required int id,
    @required String message,
    @required String platNo,
    @required int stationId,
    @required String image,
    @required int reportId,
    @required String uid,
    @required String createdAt,
  }) {
    final createdReport = Report(
        id: id,
        image: image,
        message: message,
        platNo: platNo,
        stationId: stationId,
        createdAt: createdAt,
        reportId: reportId,
        uid: uid);
    _availableReports.add(createdReport);
    print('Am called tooo');
    notifyListeners();
  }

  //getters
  List<Report> getReports() {
    print('-----------');
    print(_availableReports);
    print(_currentUser.uid);
    print('++++++++++++');
    if (_availableReports == null) {
      return <Report>[];
    }
    return List<Report>.from(_availableReports
        .where((report) => report.uid == _currentUser.uid.toString()));
  }

  //acceleration...
  Future<bool> postAcceletion(
      {@required double x,
      @required double y,
      @required double z,
      @required int userId}) async {
    final Map<String, dynamic> accelerationData = {
      'x': x,
      'y': y,
      'z': z,
      'uid': _currentUser.uid,
      'user_type': _userType.toString().replaceAll('UserType.', '')
    };
    final http.Response response = await http.post(
      api + "acceleration",
      body: json.encode(accelerationData),
      headers: {'Content-Type': 'application/json'},
    );
    final Map<String, dynamic> data = json.decode(response.body);
    bool hasError = true;

    if (data.containsKey('status')) {
      hasError = false;
      print(hasError);
    } else {
      hasError = true;
    }
    notifyListeners();
    return hasError;
  }

  //gyroscope...
  Future<bool> postGyroscope(
      {@required double x,
      @required double y,
      @required double z,
      @required int userId}) async {
    final Map<String, dynamic> gyroscopeData = {
      'x': x,
      'y': y,
      'z': z,
      'uid': _currentUser.uid,
      'user_type': _userType.toString().replaceAll('UserType.', '')
    };
    final http.Response response = await http.post(
      api + "gyroscope",
      body: json.encode(gyroscopeData),
      headers: {'Content-Type': 'application/json'},
    );
    final Map<String, dynamic> data = json.decode(response.body);
    bool hasError = true;

    if (data.containsKey('status')) {
      hasError = false;
      print(hasError);
    } else {
      hasError = true;
    }
    notifyListeners();
    return hasError;
  }

  //gyroscope...
  Future<bool> postLocation(
      {@required double x,
      @required double y,
      @required double z,
      @required int userId}) async {
    final Map<String, dynamic> gyroscopeData = {
      'x': x,
      'y': y,
      'z': z,
      'uid': _currentUser.uid,
      'user_type': _userType.toString().replaceAll('UserType.', '')
    };
    final http.Response response = await http.post(
      api + "location",
      body: json.encode(gyroscopeData),
      headers: {'Content-Type': 'application/json'},
    );
    final Map<String, dynamic> data = json.decode(response.body);
    bool hasError = true;

    if (data.containsKey('status')) {
      hasError = false;
      print(hasError);
    } else {
      hasError = true;
    }
    notifyListeners();
    return hasError;
  }

  sycLocallySavedData() async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result == true) {
      print('YAY! Free cute dog pics!');
      _availableGPSLogs.forEach((location) => postLocation(
          x: location.latitude,
          y: location.latitude,
          z: location.speed,
          userId: 1));

      _availableAccelerometerLogs.forEach((acceleration) => postAcceletion(
          x: acceleration.x, y: acceleration.y, z: acceleration.z, userId: 1));

      _availableGyroscopeLogs.forEach((gyroscope) => postGyroscope(
          x: gyroscope.x, y: gyroscope.y, z: gyroscope.z, userId: 1));

      //empty the lists..
      _availableGPSLogs = [];
      _availableAccelerometerLogs = [];
      _availableGyroscopeLogs = [];
      notifyListeners();
    } else {
      print('No internet :( Reason:');
      print(DataConnectionChecker().lastTryResults);
    }
  }
}
