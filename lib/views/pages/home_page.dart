import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:safe_ride/models/accelerometer.dart';
import 'package:safe_ride/models/gps_logs.dart';
import 'package:safe_ride/models/gyroscope_logs.dart';

import 'package:safe_ride/views/pages/reports/report_page.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:screenshot/screenshot.dart';
import 'package:sensors/sensors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:safe_ride/data/main.dart';
import 'drawer_page.dart';
import 'package:safe_ride/styles/style.dart' as ThemeColor;
import 'package:location/location.dart';

class HomePage extends StatefulWidget {
  final MainModel model;

  const HomePage({Key key, @required this.model}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  final _formKeys = GlobalKey<FormState>();

  int intialSpeed = 0;
  int _currentSpeed = 0;

  Color speedColor = ThemeColor.Colors.saferidePrimaryColor;
  Color speedColorBackground = Colors.white;
  PublishSubject<double> eventObservable = new PublishSubject();

  Completer<GoogleMapController> _controller = Completer();
  Marker marker;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  CameraPosition kGooglePlex;
  final MarkerId markerId = MarkerId('0098');
  BitmapDescriptor myIcon;

  FocusNode _speedFocusNode = FocusNode();
  TextEditingController _speedTextEditingController = TextEditingController();

  var isDeviceConnected = false;

  var location = new Location();

  ScreenshotController screenshotController = ScreenshotController();

  final FocusNode _plateNoFocusNode = FocusNode();

  TextEditingController _platNoTextEditingController = TextEditingController();

  AudioPlayer audioPlayer = AudioPlayer();

  //Accelerations...

  double ax = 0.0;
  double ay = 0.0;
  double az = 0.0;
  double _latitude = 0.0;
  double _longitude = 0.0;
  @override
  void initState() {
    widget.model.fetchStations();
    location.getLocation().then((onValue) {
      setState(() {
        _latitude = onValue.latitude;
        _longitude = onValue.longitude;
      });
    });
    super.initState();

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(48, 48)), 'assets/icons/car.png')
        .then((onValue) {
      myIcon = onValue;
    });

    _getLocation();
  }

  @override
  void dispose() {
    // positionStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // creating a new MARKER
    markers[markerId] = marker;

    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text('Safe Roads'),
          ),
          body: Stack(
            children: <Widget>[
              // Max Size

              Container(
                child: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: kGooglePlex,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  markers: Set<Marker>.of(markers.values),
                ),
              ),

              Align(
                  alignment: Alignment.bottomLeft,
                  child: Screenshot(
                    controller: screenshotController,
                    child: Container(
                      padding: EdgeInsets.all(40),
                      child: Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: InkWell(
                          onLongPress: () {
                            screenshotController.capture().then((File image) {
                              setState(() {
                                model.capturedImage = image;

                                _reportSpeed(model);
                              });
                            }).catchError((onError) {});
                          },
                          onTap: () => _showDialog(),
                          child: Container(
                            padding: const EdgeInsets.all(15.0),
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.pink),
                              color: Colors.white,
                            ),
                            child: Center(
                                child: Stack(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(_currentSpeed.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 40,
                                          color: speedColor)),
                                ),
                                Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Text("KMP",
                                        style: TextStyle(color: speedColor),
                                        overflow: TextOverflow.fade))
                              ],
                            )),
                          ),
                        ),
                      ),
                      height: MediaQuery.of(context).size.width / 2,
                      width: MediaQuery.of(context).size.width / 2,
                    ),
                  )),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  padding: EdgeInsets.all(40),
                  child: Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => ReportPage()));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15.0),
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.pink),
                          color: Colors.white,
                        ),
                        child: Image.asset('assets/icons/accident.png'),
                      ),
                    ),
                  ),
                  height: MediaQuery.of(context).size.width / 2,
                  width: MediaQuery.of(context).size.width / 2,
                ),
              )
            ],
          ),
          drawer: SizedBox(
            width: MediaQuery.of(context).size.width * 0.80,
            child: DrawerPage(),
          ),
        );
      },
    );
  }

  Future<void> _getLocation() async {
    marker = Marker(
      markerId: markerId,
      icon: myIcon,
      position: LatLng(37.33754513, -122.04146632),
      infoWindow: InfoWindow(title: 'Car', snippet: '*'),
      onTap: () {
        //_onMarkerTapped(markerId);
      },
    );

    kGooglePlex = CameraPosition(
      target: LatLng(37.33754513, -122.04146632),
      bearing: 192.8334901395799,
      zoom: 19.4746,
    );

    final GoogleMapController controller = await _controller.future;

    var location = new Location();

    location.onLocationChanged().listen((LocationData currentLocation) {
      GPSLogs _log = GPSLogs(
          altitude: currentLocation.altitude,
          latitude: currentLocation.latitude,
          longitude: currentLocation.longitude,
          speed: currentLocation.speed * 3.6);

      widget.model.addNewGPSLog(log: _log);

      // widget.model.postLocation(
      //     x: currentLocation.latitude,
      //     y: currentLocation.longitude,
      //     z: currentLocation.speed * 3.6,
      //     userId: 1);

      setState(() {
        marker = Marker(
          markerId: markerId,
          icon: myIcon,
          rotation: currentLocation.heading,
          position: LatLng(currentLocation.latitude, currentLocation.longitude),
          infoWindow: InfoWindow(title: 'Car', snippet: '*'),
          onTap: () {
            //_onMarkerTapped(markerId);
          },
        );

        kGooglePlex = CameraPosition(
            target: LatLng(currentLocation.latitude, currentLocation.longitude),
            bearing: 192.8334901395799,
            tilt: 59.440717697143555,
            zoom: 19.4746);

        controller.animateCamera(CameraUpdate.newCameraPosition(kGooglePlex));

        eventObservable.add(currentLocation.speed * 3.6);

        //speed color...
        if (intialSpeed > 0) {
          _currentSpeed = (currentLocation.speed * 3.6).round();
          if (currentLocation.speed * 3.6 > intialSpeed) {
            playBeep();
            speedColor = Colors.red;
            speedColorBackground = Colors.red;
          } else if (currentLocation.speed * 3.6 - 10 > intialSpeed) {
            stopBeep();
            speedColor = Colors.green;
            speedColorBackground = Colors.white;
          } else {
            speedColor = Colors.green;
            speedColorBackground = Colors.white;
            stopBeep();
          }
        } else {
          _currentSpeed = 0;
          stopBeep();
        }
      });
    });

    //accelerometer

    accelerometerEvents.listen((AccelerometerEvent event) {
      AccelerometerLogs _log =
          AccelerometerLogs(x: event.x, y: event.y, z: event.z);

      widget.model.addNewAccelerometerLog(log: _log);
    });

//gyroscope
    gyroscopeEvents.listen((GyroscopeEvent event) {
      GyroscopeLogs _log = GyroscopeLogs(x: event.x, y: event.y, z: event.z);

      widget.model.addNewGyroscopeLog(log: _log);

      // widget.model.postGyroscope(x: event.x, y: event.y, z: event.z, userId: 1);
    });
  }

  void _showInSnackBar(String value, Color color) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontFamily: "WorkSansSemiBold"),
      ),
      backgroundColor: color,
      duration: Duration(seconds: 3),
    ));
  }

  // user defined function
  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Set New Speed Limit"),
          content: Form(
            key: _formKey,
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter speed limit';
                } else
                  return null;
              },
              focusNode: _speedFocusNode,
              controller: _speedTextEditingController,
              keyboardType: TextInputType.number,
              style: TextStyle(
                  fontFamily: "WorkSansSemiBold",
                  fontSize: 16.0,
                  color: Colors.black),
              decoration: InputDecoration(
                  //focusColor: Colors.white,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.white)),
                  hintText: "Speed",
                  labelText: "Speed",
                  labelStyle: TextStyle(color: Colors.blue),
                  hintStyle: TextStyle(
                      fontFamily: "WorkSansSemiBold",
                      fontSize: 17.0,
                      color: Colors.blue),
                  prefixIcon: Icon(
                    Icons.shutter_speed,
                    size: 22.0,
                    color: Colors.blue,
                  )),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              color: Colors.green,
              child: new Text("set", style: TextStyle(color: Colors.white)),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  if (_speedTextEditingController.text.isNotEmpty) {
                    setState(() {
                      intialSpeed = int.parse(_speedTextEditingController.text);
                      speedColor = Colors.green;
                      speedColorBackground = Colors.green;
                    });

                    Navigator.of(context).pop();

                    _speedTextEditingController.clear();
                  }
                }
              },
            ),
            FlatButton(
              color: Colors.red,
              child: new Text(
                "Close",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _reportSpeed(MainModel model) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.pinkAccent[300],
          title: Center(
              child: Text('Report Over Speeding',
                  style: TextStyle(
                      fontFamily: 'itikaf',
                      color: Colors.pink,
                      fontWeight: FontWeight.bold))),
          content: SingleChildScrollView(
              child: Form(
            key: _formKeys,
            child: Column(
              children: <Widget>[
                Divider(),
                Container(
                  child: Image.file(model.imageFile),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: TextFormField(
                    validator: (val) {
                      if (val.isEmpty) {
                        return 'Enter Car Plate Number';
                      }
                      return null;
                    },
                    focusNode: _plateNoFocusNode,
                    maxLength: 7,
                    keyboardType: TextInputType.text,
                    controller: _platNoTextEditingController,
                    style: TextStyle(fontSize: 16.0, color: Colors.black),
                    decoration: InputDecoration(
                        //focusColor: Colors.pinkAccent,
                        fillColor: Colors.pinkAccent,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: Colors.pinkAccent)),
                        hintText: "PlateNo",
                        labelText: "PlateNo",
                        labelStyle: TextStyle(color: Colors.pinkAccent),
                        hintStyle: TextStyle(
                            fontFamily: "WorkSansSemiBold",
                            fontSize: 17.0,
                            color: Colors.pinkAccent),
                        prefixIcon: Icon(
                          Icons.shutter_speed,
                          size: 22.0,
                          color: Colors.pinkAccent,
                        )),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: FlatButton(
                          color: Colors.blue,
                          child: Text('CANCEL',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          onPressed: () {
                            model.resetImage();
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: FlatButton(
                          color: Colors.blue,
                          child: Text('REPORT',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          onPressed: () {
                            if (_formKeys.currentState.validate()) {
                              model
                                  .postReport(
                                      platNo: _platNoTextEditingController.text,
                                      file: model.imageFile,
                                      message: 'Over speeding',
                                      reportId: 2,
                                      stationId: 9,
                                      uid: model.currentUser.uid,
                                      latitude: _latitude,
                                      longitude: _longitude)
                                  .then((onValue) {
                                if (!onValue) {
                                  _platNoTextEditingController.clear();
                                  _showInSnackBar(
                                      'Report sent successfully', Colors.green);
                                  Navigator.of(context).pop();
                                } else {
                                  _showInSnackBar(
                                      'No internet connect', Colors.red);
                                }
                              });
                            }
                          },
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          )),
        );
      },
    );
  }

  playBeep() async {
    int result =
        await audioPlayer.play('assets/audios/beep.mp3', isLocal: true);
    if (result == 1) {
      // success

    }
  }

  stopBeep() async {
    int result = await audioPlayer.stop();
    if (result == 1) {
      // success

    }
  }
}
