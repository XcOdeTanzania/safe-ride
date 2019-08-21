import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:safe_ride/data/main.dart';
import 'package:safe_ride/views/widgets/alerts/custom_circular_progress_bar.dart';
import 'package:scoped_model/scoped_model.dart';

class CreateReportPage extends StatelessWidget {
  final File imageFile;
  final FocusNode _commentFocusNode = FocusNode();
  final FocusNode _platNoFocusNode = FocusNode();

  final TextEditingController _commentTextEditingController =
      TextEditingController();
  final TextEditingController _platNoTextEditingController =
      TextEditingController();

  CreateReportPage({Key key, @required this.imageFile}) : super(key: key);
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
                    child: Image.file(imageFile),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: TextFormField(
                    maxLength: 9,
                    maxLines: 1,
                    focusNode: _platNoFocusNode,
                    controller: _platNoTextEditingController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        hintText: 'Plate Number',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5))),
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
                        hintText: 'Message',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: RaisedButton.icon(
                    color: Colors.pink,
                    label: Text(
                      'Post Comment',
                      style: TextStyle(color: Colors.white),
                    ),
                    icon: Icon(
                      FontAwesomeIcons.paperPlane,
                      color: Colors.white,
                      size: 15,
                    ),
                    onPressed: () {
                      if (_commentTextEditingController.text.isNotEmpty &&
                          _platNoTextEditingController.text.isNotEmpty) {
                        model
                            .postReport(
                                message: _commentTextEditingController.text,
                                platNo: _platNoTextEditingController.text,
                                stationId: 8,
                                file: imageFile)
                            .then((onValue) {
                          model.setScreenShot(status: false);
                          _commentTextEditingController.clear();
                          _platNoTextEditingController.clear();
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
