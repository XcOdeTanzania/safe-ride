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
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: ListTile(title: Text('NO DATA YET'),),
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
