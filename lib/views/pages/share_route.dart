import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:location/location.dart';
import 'package:safe_ride/data/main.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:share/share.dart';

class ShareRoute extends StatefulWidget {
  @override
  _ShareRouteState createState() => _ShareRouteState();
}

class _ShareRouteState extends State<ShareRoute> {
  final FocusNode _fromFocusNode = FocusNode();

  final FocusNode _toFocusNode = FocusNode();

  TextEditingController _fromTextEditingController = TextEditingController();

  TextEditingController _toTextEditingController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

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
      builder: (context, child, MainModel model) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text('Share My Route'),
          ),
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: TextFormField(
                    validator: (val) {
                      if (val.isEmpty) {
                        return 'Please Enter where your coming from';
                      }
                      return null;
                    },
                    focusNode: _fromFocusNode,
                    keyboardType: TextInputType.text,
                    controller: _fromTextEditingController,
                    style: TextStyle(fontSize: 16.0, color: Colors.black),
                    decoration: InputDecoration(
                        //focusColor: Colors.pinkAccent,
                        fillColor: Colors.pinkAccent,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: Colors.pinkAccent)),
                        hintText: "From",
                        labelText: "From",
                        labelStyle: TextStyle(color: Colors.pinkAccent),
                        hintStyle: TextStyle(
                            fontFamily: "WorkSansSemiBold",
                            fontSize: 17.0,
                            color: Colors.pinkAccent),
                        prefixIcon: Icon(
                          FontAwesomeIcons.mapPin,
                          size: 22.0,
                          color: Colors.pinkAccent,
                        )),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: TextFormField(
                    validator: (val) {
                      if (val.isEmpty) {
                        return 'Please Enter where your going';
                      }
                      return null;
                    },
                    focusNode: _toFocusNode,
                    keyboardType: TextInputType.text,
                    controller: _toTextEditingController,
                    style: TextStyle(fontSize: 16.0, color: Colors.black),
                    decoration: InputDecoration(
                        //focusColor: Colors.pinkAccent,
                        fillColor: Colors.pinkAccent,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: Colors.pinkAccent)),
                        hintText: "To",
                        labelText: "To",
                        labelStyle: TextStyle(color: Colors.pinkAccent),
                        hintStyle: TextStyle(
                            fontFamily: "WorkSansSemiBold",
                            fontSize: 17.0,
                            color: Colors.pinkAccent),
                        prefixIcon: Icon(
                          FontAwesomeIcons.mapPin,
                          size: 22.0,
                          color: Colors.pinkAccent,
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text('Latitude:\t' + _latitude.toString()),
                      ),
                      Expanded(
                        child: Text('Longitude:\t' + _longitude.toString()),
                      )
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: RaisedButton(
                        color: Colors.pinkAccent,
                        textColor: Colors.white,
                        child: Text('Share To next of Kin'),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            if (model.nextOfKin != null) {
                              Share.share('From: ' +
                                  _fromTextEditingController.text +
                                  '\t To: ' +
                                  _toTextEditingController.text);
                            } else {
                              showInSnackBar(
                                  'Add a next of kin to share your routes with');
                            }
                          }
                        },
                      ),
                    )),
                  ],
                )
              ]),
            ),
          ),
        );
      },
    );
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
}
