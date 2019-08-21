import 'dart:async';
import 'dart:io';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:safe_ride/constants/constants.dart';
import 'package:safe_ride/models/accelerometer.dart';
import 'package:safe_ride/models/gps_logs.dart';
import 'package:safe_ride/models/gyroscope_logs.dart';
import 'package:safe_ride/utils/enums.dart';
import 'package:safe_ride/views/pages/create_report.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sensors/sensors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:safe_ride/data/main.dart';

import 'package:speedometer/speedometer.dart';
import 'drawer_page.dart';
import 'package:screenshot/screenshot.dart';
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
  // StreamSubscription<Position> positionStream;
  double _lowerValue = 80.0;
  double _upperValue = 180.0;
  int start = 0;
  int end = 250;

  int counter = 0;
  int intialSpeed = 0;
  Color speedColor = ThemeColor.Colors.saferidePrimaryColor;
  Color speedColorBackground = Colors.black38;
  PublishSubject<double> eventObservable = new PublishSubject();

  Completer<GoogleMapController> _controller = Completer();
  Marker marker;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  CameraPosition kGooglePlex;
  final MarkerId markerId = MarkerId('0098');
  BitmapDescriptor myIcon;

  FocusNode _speedFocusNode = FocusNode();
  TextEditingController _speedTextEditingController = TextEditingController();

  File _imageFile;
  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();
  @override
  void initState() {
    widget.model.fetchStations();
    super.initState();

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(48, 48)), 'assets/icons/car.png')
        .then((onValue) {
      myIcon = onValue;
    });

    _getLocation();

    if (widget.model.userType == null) {
      startTime();
    }
  }

  @override
  void dispose() {
    // positionStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData speedometerTheme = new ThemeData(
        primaryColor: Colors.blue,
        accentColor: Colors.black,
        backgroundColor: Colors.grey);
    // creating a new MARKER
    markers[markerId] = marker;

    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text('Safe Ride'),
            actions: <Widget>[
              BadgeIconButton(
                  itemCount: 4,
                  icon: Icon(Icons.notification_important),
                  badgeColor: Colors.green,
                  badgeTextColor: Colors.white,
                  hideZeroCount: true,
                  onPressed: () {
                    showInSnackBar('Notification sms from next of kin');
                    Navigator.pushNamed(context, notificationScreen);
                  })
            ],
          ),
          body: Screenshot(
            controller: screenshotController,
            child: Stack(
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

                model.showScreenShot
                    ? Padding(
                        padding: EdgeInsets.all(20),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 4,
                                    color:
                                        ThemeColor.Colors.saferidePrimaryColor),
                              ),
                              height: 200,
                              width: 150,
                              child: Column(
                                children: <Widget>[
                                  Expanded(
                                    flex: 6,
                                    child: _imageFile != null
                                        ? Container(
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                              image: new AssetImage(
                                                  'assets/img/map.png'),
                                              fit: BoxFit.cover,
                                            )),
                                            child: Image.file(_imageFile),
                                          )
                                        : Container(),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      color: Colors.black12,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            child: FlatButton.icon(
                                              icon: Icon(
                                                Icons.warning,
                                                color: Colors.red,
                                              ),
                                              color: Colors.white,
                                              label: Text('REPORT',
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          CreateReportPage(
                                                            imageFile:
                                                                _imageFile,
                                                          )),
                                                );
                                               
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      )
                    : Container(),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    padding: EdgeInsets.all(40),
                    child: SpeedOMeter(
                        start: start,
                        end: end,
                        highlightStart: (_lowerValue / end),
                        highlightEnd: (_upperValue / end),
                        themeData: speedometerTheme,
                        eventObservable: this.eventObservable),
                    height: MediaQuery.of(context).size.width * 3 / 4,
                    width: MediaQuery.of(context).size.width * 3 / 4,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    padding: EdgeInsets.all(40),
                    child: Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: InkWell(
                        onTap: () => _showDialog(),
                        child: Container(
                          padding: const EdgeInsets.all(15.0),
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            color: speedColorBackground,
                          ),
                          child: Center(
                              child: Stack(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.center,
                                child: Text(intialSpeed.toString(),
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
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    padding: EdgeInsets.all(40),
                    child: Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: InkWell(
                        onTap: () {
                          screenshotController.capture().then((File image) {
                            setState(() {
                              _imageFile = image;
                            });

                            showInSnackBar("Screenshot captured successfully");
                            model.setScreenShot(status: true);
                          }).catchError((onError) {});
                        },
                        child: Container(
                          padding: const EdgeInsets.all(15.0),
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black38,
                          ),
                          child: Icon(
                            Icons.camera_enhance,
                            size: 40,
                            color: ThemeColor.Colors.saferidePrimaryColor,
                          ),
                        ),
                      ),
                    ),
                    height: MediaQuery.of(context).size.width / 2,
                    width: MediaQuery.of(context).size.width / 2,
                  ),
                )
              ],
            ),
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
          if (currentLocation.speed * 3.6 > intialSpeed) {
            // intialSpeed = int.parse(_speedTextEditingController.text);
            speedColor = Colors.white;
            speedColorBackground = Colors.red;
          } else if (currentLocation.speed * 3.6 - 10 > intialSpeed) {
            // intialSpeed = int.parse(_speedTextEditingController.text);
            speedColor = Colors.white;
            speedColorBackground = Colors.white;
          } else {
            speedColor = Colors.white;
            speedColorBackground = Colors.green;
          }
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
    });
  }

  void showInSnackBar(String value) {
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
      backgroundColor: ThemeColor.Colors.saferidePrimaryColor,
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
                      speedColor = Colors.white;
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

  startTime() async {
    var _duration = new Duration(seconds: 6);
    return new Timer(_duration, _showConfirmDialog);
  }

  void _showConfirmDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFFf43f5f),
          title: Center(
              child: Text('Set User Type',
                  style: TextStyle(
                      fontFamily: 'itikaf',
                      color: Colors.white,
                      fontWeight: FontWeight.bold))),
          content: SingleChildScrollView(
              child: Column(
            children: <Widget>[
              Text('Are you a Driver or Passanger ?',
                  style: TextStyle(
                      fontFamily: 'itikaf',
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
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
                        child: Text('DRIVER',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        onPressed: () {
                          Navigator.of(context).pop();
                          widget.model.setUserType(type: UserType.driver);
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: FlatButton(
                        color: Colors.blue,
                        child: Text('PASSANGER',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        onPressed: () {
                          Navigator.of(context).pop();
                          widget.model.setUserType(type: UserType.passanger);
                        },
                      ),
                    ),
                  )
                ],
              )
            ],
          )),
        );
      },
    );
  }
}
