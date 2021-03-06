import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:safe_ride/constants/constants.dart';
import 'package:safe_ride/data/main.dart';
import 'package:scoped_model/scoped_model.dart';

const String _kAsset0 = 'assets/icons/male.jpg';

class DrawerPage extends StatefulWidget {
  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  static final Animatable<Offset> _drawerDetailsTween = Tween<Offset>(
    begin: const Offset(0.0, -1.0),
    end: Offset.zero,
  ).chain(CurveTween(
    curve: Curves.fastOutSlowIn,
  ));

  AnimationController _controller;
  Animation<double> _drawerContentsOpacity;
  Animation<Offset> _drawerDetailsPosition;
  bool _showDrawerContents = true;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _drawerContentsOpacity = CurvedAnimation(
      parent: ReverseAnimation(_controller),
      curve: Curves.fastOutSlowIn,
    );
    _drawerDetailsPosition = _controller.drive(_drawerDetailsTween);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showNotImplementedMessage() {
    Navigator.pop(context); // Dismiss the drawer.
    _scaffoldKey.currentState.showSnackBar(
        const SnackBar(content: Text("The drawer's items don't do anything")));
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Container(
          child: Drawer(
            child: Column(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName: Text(
                    model.currentUser.displayName != null
                        ? model.currentUser.displayName
                        : 'User',
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'mermaid',
                    ),
                  ),
                  accountEmail: Text(
                    model.currentUser.email != null
                        ? model.currentUser.email
                        : '',
                    style: const TextStyle(
                      fontSize: 15.0,
                      fontFamily: 'mermaid',
                    ),
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: model.authenticatedUser == null
                        ? AssetImage(_kAsset0)
                        : NetworkImage(model.authenticatedUser.photoUrl),
                  ),
                  otherAccountsPictures: <Widget>[],
                  margin: EdgeInsets.zero,
                  onDetailsPressed: () {
                    _showDrawerContents = !_showDrawerContents;
                    if (_showDrawerContents)
                      _controller.reverse();
                    else
                      _controller.forward();
                  },
                ),
                MediaQuery.removePadding(
                  context: context,
                  // DrawerHeader consumes top MediaQuery padding.
                  removeTop: true,
                  child: Expanded(
                    child: ListView(
                      padding: const EdgeInsets.only(top: 8.0),
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            // The initial contents of the drawer.
                            FadeTransition(
                              opacity: _drawerContentsOpacity,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  ListTile(
                                    leading: const Icon(
                                      FontAwesomeIcons.home,
                                    ),
                                    title: Text(
                                      'Home',
                                      style: const TextStyle(
                                        fontSize: 15.0,
                                        fontFamily: 'mermaid',
                                      ),
                                    ),
                                    onTap: () {
                                      // Update the state of the app
                                      // ...
                                      // Then close the drawer
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(
                                      Icons.person,
                                    ),
                                    title: Text(
                                      'Profile',
                                      style: const TextStyle(
                                        fontSize: 15.0,
                                        fontFamily: 'mermaid',
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.pushNamed(
                                          context, profileScreen);
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(
                                      Icons.library_books,
                                    ),
                                    title: Text(
                                      'Sent Reports',
                                      style: const TextStyle(
                                        fontSize: 15.0,
                                        fontFamily: 'mermaid',
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.pushNamed(
                                          context, reportScreen);
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(
                                      FontAwesomeIcons.home,
                                    ),
                                    title: Text(
                                      'Nearby Police Stations',
                                      style: const TextStyle(
                                        fontSize: 15.0,
                                        fontFamily: 'mermaid',
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.pushNamed(
                                          context, stationScreen);
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(
                                      Icons.graphic_eq,
                                    ),
                                    title: Text(
                                      'Data Insights',
                                      style: const TextStyle(
                                        fontSize: 15.0,
                                        fontFamily: 'mermaid',
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.pushNamed(
                                          context, insightsScreen);
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(
                                      Icons.data_usage,
                                    ),
                                    title: Text(
                                      'Data Logs',
                                      style: const TextStyle(
                                        fontSize: 15.0,
                                        fontFamily: 'mermaid',
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.pushNamed(context, logsScreen);
                                    },
                                  ),
                                 
                                  ListTile(
                                    leading: const Icon(
                                      Icons.share,
                                    ),
                                    title: Text(
                                      'Share Route',
                                      style: const TextStyle(
                                        fontSize: 15.0,
                                        fontFamily: 'mermaid',
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.pushNamed(context, shareRouteScreen);
                                    },
                                  ),
                                  Divider(),
                                  ListTile(
                                      title: Text(
                                    'Others',
                                    style: const TextStyle(
                                      fontSize: 20.0,
                                      fontFamily: 'bebas-neue',
                                      letterSpacing: 1.0,
                                    ),
                                  )),
                                  Divider(),
                                  ListTile(
                                    leading: const Icon(
                                      Icons.exit_to_app,
                                    ),
                                    title: Text(
                                      'Logout',
                                      style: const TextStyle(
                                        fontSize: 15.0,
                                        fontFamily: 'mermaid',
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                      model.signOut().then((val) {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                            // The drawer's "details" view.
                            SlideTransition(
                              position: _drawerDetailsPosition,
                              child: FadeTransition(
                                opacity:
                                    ReverseAnimation(_drawerContentsOpacity),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    ListTile(
                                      leading: const Icon(
                                        Icons.add,
                                      ),
                                      title: const Text('Add account'),
                                      onTap: _showNotImplementedMessage,
                                    ),
                                    ListTile(
                                      leading: const Icon(
                                        Icons.settings,
                                      ),
                                      title: const Text('Manage accounts'),
                                      onTap: _showNotImplementedMessage,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
