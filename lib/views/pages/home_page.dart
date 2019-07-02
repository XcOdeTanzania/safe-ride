import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:speedometer/speedometer.dart';
import 'drawer_page.dart';
import 'package:screenshot/screenshot.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  double _lowerValue = 80.0;
  double _upperValue = 180.0;
  int start = 0;
  int end = 250;

  int counter = 0;
  int intialSpeed = 0;
  Color speedColor = Colors.blue;
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

  File _imageFile;
  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();
  @override
  void initState() {
    super.initState();

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(48, 48)), 'assets/icons/car.png')
        .then((onValue) {
      myIcon = onValue;
    });
    const oneSec = const Duration(seconds: 1);
    // var rng = new Random();
    // new Timer.periodic(oneSec,
    //     (Timer t) => eventObservable.add(rng.nextInt(59) + rng.nextDouble()));
    _getLocation();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData speedometerTheme = new ThemeData(
        primaryColor: Colors.blue,
        accentColor: Colors.black,
        backgroundColor: Colors.grey);
    // creating a new MARKER
    markers[markerId] = marker;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Safe Ride'),
        actions: <Widget>[Icon(Icons.ac_unit)],
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
            Padding(
              padding: EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.all(10),
                  height: 200,
                  width: 150,
                  child:
                      _imageFile != null ? Image.file(_imageFile) : Container(),
                ),
              ),
            ),
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
                          child: RichText(
                        text: TextSpan(
                          text: '',
                          children: <TextSpan>[
                            TextSpan(
                                text: intialSpeed.toString() + '\n',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 40,
                                    color: speedColor)),
                            TextSpan(
                                text: 'KMPH',
                                style: TextStyle(color: speedColor)),
                          ],
                        ),
                      )),
                    ),
                  ),
                ),
                height: 200.0,
                width: 200.0,
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
                        print(_imageFile.toString());
                      }).catchError((onError) {
                        print(onError);
                      });
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
                        color: Color(0xFF0084ff),
                      ),
                    ),
                  ),
                ),
                height: 200.0,
                width: 200.0,
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
      zoom: 14.4746,
    );

    final GoogleMapController controller = await _controller.future;

    var geolocator = Geolocator();
    var locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
    StreamSubscription<Position> positionStream = geolocator
        .getPositionStream(locationOptions)
        .listen((Position position) {});
    positionStream.onData((handleData) {
      print('aaaaa');
      print(handleData.speedAccuracy);
      setState(() {
        marker = Marker(
          markerId: markerId,
          icon: myIcon,
          position: LatLng(handleData.latitude, handleData.longitude),
          infoWindow: InfoWindow(title: 'Car', snippet: '*'),
          onTap: () {
            //_onMarkerTapped(markerId);
          },
        );

        kGooglePlex = CameraPosition(
            target: LatLng(handleData.latitude, handleData.longitude),
            bearing: 192.8334901395799,
            tilt: 59.440717697143555,
            zoom: 19.151926040649414);

        controller.animateCamera(CameraUpdate.newCameraPosition(kGooglePlex));

        eventObservable.add(handleData.speed);
      });
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
      backgroundColor: Colors.blue,
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
                  focusColor: Colors.white,
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
}
