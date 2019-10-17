import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safe_ride/data/main.dart';
import 'package:safe_ride/utils/enums.dart';
import 'package:scoped_model/scoped_model.dart';

const String _kAsset0 = 'assets/icons/male.jpg';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final double _appBarHeight = 256.0;
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

  final FocusNode _phoneFocusNode = FocusNode();
  TextEditingController _phoneTextEditingController = TextEditingController();

  AppBarBehavior _appBarBehavior = AppBarBehavior.pinned;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Scaffold(
          key: _scaffoldKey,
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                expandedHeight: _appBarHeight,
                pinned: _appBarBehavior == AppBarBehavior.pinned,
                floating: _appBarBehavior == AppBarBehavior.floating ||
                    _appBarBehavior == AppBarBehavior.snapping,
                snap: _appBarBehavior == AppBarBehavior.snapping,
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.create),
                    tooltip: 'Edit',
                    onPressed: () {
                      _scaffoldKey.currentState.showSnackBar(const SnackBar(
                          content: Text("Editing user details.")));
                    },
                  )
                ],
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    model.currentUser.displayName != null
                        ? model.currentUser.displayName
                        : 'User',
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Image.asset(
                        model.authenticatedUser == null
                            ? _kAsset0
                            : NetworkImage(model.authenticatedUser.photoUrl),
                        fit: BoxFit.cover,
                        height: _appBarHeight,
                      ),
                      // This gradient ensures that the toolbar icons are distinct
                      // against the background image.
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(0.0, -1.0),
                            end: Alignment(0.0, -0.4),
                            colors: <Color>[
                              Color(0x60000000),
                              Color(0x00000000)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(<Widget>[
                  AnnotatedRegion<SystemUiOverlayStyle>(
                    value: SystemUiOverlayStyle.dark,
                    child: Card(
                      elevation: 10,
                      margin: EdgeInsets.all(20),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20.0, top: 10),
                              child: Text(
                                'Next Of Kin',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                            ),
                            model.nextOfKin != null && !model.isNextOfKinEditing
                                ? Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: ListTile(
                                          title: Text(model.nextOfKin),
                                          trailing: IconButton(
                                            color: Colors.pinkAccent,
                                            icon: Icon(Icons.edit),
                                            tooltip: 'Edit',
                                            onPressed: () {
                                              model.toggleIsEditing = true;
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(
                                    margin: EdgeInsets.all(20),
                                    child: TextField(
                                      maxLength: 13,
                                      focusNode: _phoneFocusNode,
                                      keyboardType: TextInputType.phone,
                                      controller: _phoneTextEditingController,
                                      style: TextStyle(
                                          fontSize: 16.0, color: Colors.black),
                                      decoration: InputDecoration(
                                          //focusColor: Colors.white,
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              borderSide: BorderSide(
                                                  color: Colors.white)),
                                          hintText: "Phone",
                                          labelText: "Phone",
                                          labelStyle: TextStyle(
                                              color: Colors.pinkAccent),
                                          hintStyle: TextStyle(
                                              fontFamily: "WorkSansSemiBold",
                                              fontSize: 17.0,
                                              color: Colors.pinkAccent),
                                          prefixIcon: Icon(
                                            Icons.phone,
                                            size: 22.0,
                                            color: Colors.pinkAccent,
                                          )),
                                    ),
                                  ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: model.nextOfKin != null &&
                                            !model.isNextOfKinEditing
                                        ? Container()
                                        : RaisedButton(
                                            color: Colors.pinkAccent,
                                            textColor: Colors.white,
                                            onPressed: () {
                                              if (_phoneTextEditingController
                                                  .text.isNotEmpty) {
                                                model.addNextOfKin(
                                                    nextOfKin:
                                                        _phoneTextEditingController
                                                            .text);

                                                model.toggleIsEditing = false;
                                              }
                                            },
                                            child: Text('Save'),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 200,
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ]),
              )
            ],
          ),
        );
      },
    );
  }
}
