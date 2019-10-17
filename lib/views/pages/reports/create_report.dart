import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:safe_ride/data/main.dart';
import 'package:safe_ride/views/pages/camera/camera_page.dart';
import 'package:safe_ride/views/widgets/alerts/custom_circular_progress_bar.dart';
import 'package:scoped_model/scoped_model.dart';

class CreateReportPage extends StatelessWidget {
  final String title;
  final FocusNode _commentFocusNode = FocusNode();

  final TextEditingController _commentTextEditingController =
      TextEditingController();

  CreateReportPage({Key key, @required this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
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
                        title,
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
                      if (_commentTextEditingController.text.isNotEmpty) {
                        model
                            .postReport(
                                message: _commentTextEditingController.text,
                                platNo: title,
                                stationId: 8,
                                file: null)
                            .then((onValue) {
                          model.setScreenShot(status: false);
                          _commentTextEditingController.clear();

                          Navigator.pop(context);
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
}