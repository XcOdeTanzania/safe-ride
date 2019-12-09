import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:location/location.dart';
import 'package:safe_ride/data/main.dart';
import 'package:safe_ride/views/pages/camera/camera_page.dart';
import 'package:safe_ride/views/widgets/alerts/custom_circular_progress_bar.dart';
import 'package:scoped_model/scoped_model.dart';

class CreateReportPage extends StatefulWidget {
  final String title;

  CreateReportPage({Key key, @required this.title}) : super(key: key);

  @override
  _CreateReportPageState createState() => _CreateReportPageState();
}

class _CreateReportPageState extends State<CreateReportPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final FocusNode _commentFocusNode = FocusNode();

  final TextEditingController _commentTextEditingController =
      TextEditingController();
  var location = new Location();
  double _latitude = 0.0;
  double _longitude = 0.0;
  @override
  void initState() {
    location.getLocation().then((onValue) {
      setState(() {
        _latitude = onValue.latitude;
        _longitude = onValue.longitude;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Create Report'),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.red,
              ),
              onPressed: () {
                model.setScreenShot(status: false);
                Navigator.pop(context);
              },
            )
          ],
        ),
        body: SingleChildScrollView(
            child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: Container(
                    height: 250,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: new AssetImage('assets/img/map.png'),
                      fit: BoxFit.cover,
                    )),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          InkWell(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => CameraPage())),
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Theme.of(context).buttonColor)),
                              child: Stack(
                                children: <Widget>[
                                  model.imageFile != null
                                      ? Image(
                                          width: 100,
                                          height: 100,
                                          image: FileImage(model.imageFile),
                                          fit: BoxFit.cover,
                                        )
                                      : Container(),
                                  Container(
                                    width: 100,
                                    height: 100,
                                    color: Colors.black26,
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.camera_alt,
                                      size: 50,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              'Take A Photo',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w100),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'ACCIDENT TYPE:\t',
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        widget.title,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: TextFormField(
                    maxLength: 150,
                    maxLines: 4,
                    focusNode: _commentFocusNode,
                    controller: _commentTextEditingController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        hintText: 'Details',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: RaisedButton.icon(
                    color: Colors.pink,
                    label: Text(
                      'Post Report',
                      style: TextStyle(color: Colors.white),
                    ),
                    icon: Icon(
                      FontAwesomeIcons.paperPlane,
                      color: Colors.white,
                      size: 15,
                    ),
                    onPressed: () {
                      if (_commentTextEditingController.text.isNotEmpty &&
                          model.imageFile != null) {
                        model
                            .postReport(
                                message: _commentTextEditingController.text,
                                platNo: widget.title,
                                stationId: 8,
                                file: model.imageFile,
                                reportId: 1,
                                uid: model.currentUser.uid,
                                latitude: _latitude,
                                longitude: _longitude)
                            .then((onValue) {
                          if (!onValue) {
                            model.setScreenShot(status: false);
                            _commentTextEditingController.clear();
                            _showInSnackBar(
                                'Report sent successfully', Colors.green);
                            Navigator.pop(context);
                          } else {
                            _showInSnackBar('No internet connect', Colors.red);
                          }
                        });
                      } else {
                        print('Error');
                      }
                    },
                  ),
                ),
              ],
            ),
            model.isSubmitingReportData
                ? Align(
                    alignment: Alignment.center,
                    child: CustomCircularProgressBar(
                      divider: 1,
                    ),
                  )
                : Container()
          ],
        )),
      );
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
}
