import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:safe_ride/constants/constants.dart';
import 'package:safe_ride/data/main.dart';

import 'package:safe_ride/styles/style.dart' as ThemeColor;
import 'package:scoped_model/scoped_model.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FocusNode myFocusNodeUsernameLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();

  TextEditingController loginUsernameController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();
  bool _obscureTextLogin = true;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    myFocusNodeUsernameLogin.dispose();
    myFocusNodePasswordLogin.dispose();
    loginUsernameController.dispose();
    loginPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Scaffold(
          key: _scaffoldKey,
          body: SingleChildScrollView(
              child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    ThemeColor.Colors.loginGradientStart,
                    ThemeColor.Colors.loginGradientEnd
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 1.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 75.0, left: 25.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('',
                          style: TextStyle(
                              fontFamily: 'trajanProRegular',
                              fontSize: 20.0,
                              color: ThemeColor.Colors.saferideSecondaryColor,
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: new Image(
                      width: 250.0,
                      height: 191.0,
                      fit: BoxFit.fill,
                      image: new AssetImage('assets/icons/logo.png')),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 1.0),
                  child: Text('SAFE RIDE',
                      style: TextStyle(
                          fontFamily: 'trajanProRegular',
                          fontSize: 25.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                  child: Theme(
                    data: new ThemeData(
                      primaryColor: Colors.white,
                      primaryColorDark: Colors.red[50],
                    ),
                    child: TextField(
                      focusNode: myFocusNodeUsernameLogin,
                      controller: loginUsernameController,
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
                          hintText: "Username",
                          labelText: "Username",
                          labelStyle: TextStyle(color: Colors.white),
                          hintStyle: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 17.0,
                              color: Colors.white),
                          prefixIcon: Icon(
                            FontAwesomeIcons.user,
                            size: 22.0,
                            color: Colors.white,
                          )),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                  child: Theme(
                    data: new ThemeData(
                      primaryColor: Colors.white,
                      primaryColorDark: Colors.red[50],
                    ),
                    child: TextField(
                      focusNode: myFocusNodePasswordLogin,
                      controller: loginPasswordController,
                      obscureText: _obscureTextLogin,
                      style: TextStyle(
                          fontFamily: "WorkSansSemiBold",
                          fontSize: 16.0,
                          color: Colors.black),
                      decoration: InputDecoration(
                         // focusColor: Colors.white,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          hintText: "Password",
                          labelText: "Password",
                          hintStyle: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 17.0,
                              color: Colors.white),
                          suffixIcon: InkWell(
                            onTap: () {
                              print('object');
                            },
                            child: Icon(
                              FontAwesomeIcons.eyeSlash,
                              size: 15.0,
                              color: Colors.white,
                            ),
                          ),
                          prefixIcon: Icon(
                            FontAwesomeIcons.lock,
                            size: 22.0,
                            color: Colors.white,
                          )),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30.0),
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: ThemeColor.Colors.loginGradientStart,
                        offset: Offset(1.0, 6.0),
                        blurRadius: 20.0,
                      ),
                      BoxShadow(
                        color: ThemeColor.Colors.loginGradientEnd,
                        offset: Offset(1.0, 6.0),
                        blurRadius: 20.0,
                      ),
                    ],
                    gradient: new LinearGradient(
                        colors: [
                          ThemeColor.Colors.loginGradientEnd,
                          ThemeColor.Colors.loginGradientStart
                        ],
                        begin: const FractionalOffset(0.2, 0.2),
                        end: const FractionalOffset(1.0, 1.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  child: MaterialButton(
                      highlightColor: Colors.transparent,
                      splashColor: ThemeColor.Colors.loginGradientEnd,
                      //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 42.0),
                        child: Text(
                          "LOGIN",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                              fontFamily: "WorkSansBold"),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed(homeScreen);
                      }),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: FlatButton(
                      onPressed: () {},
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.white,
                            fontSize: 16.0,
                            fontFamily: "WorkSansMedium"),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          gradient: new LinearGradient(
                              colors: [
                                Colors.white10,
                                Colors.white,
                              ],
                              begin: const FractionalOffset(0.0, 0.0),
                              end: const FractionalOffset(1.0, 1.0),
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp),
                        ),
                        width: 100.0,
                        height: 1.0,
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Text(
                          "Or",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontFamily: "WorkSansMedium"),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: new LinearGradient(
                              colors: [
                                Colors.white,
                                Colors.white10,
                              ],
                              begin: const FractionalOffset(0.0, 0.0),
                              end: const FractionalOffset(1.0, 1.0),
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp),
                        ),
                        width: 100.0,
                        height: 1.0,
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10),
                    child: Text(
                      "sign in with",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontFamily: "WorkSansMedium"),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 10.0, right: 40.0),
                      child: InkWell(
                        onTap: () {
                          model.signInWithGoogle().then((value) {
                            print('pooooooo');
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(15.0),
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: new Icon(
                            FontAwesomeIcons.google,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: InkWell(
                        onTap: () {
                          model.signOut();
                          showInSnackBar("Facebook button pressed");
                        },
                        child: Container(
                          padding: const EdgeInsets.all(15.0),
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: new Icon(
                            FontAwesomeIcons.facebookF,
                            color: Color(0xFF0084ff),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 40, right: 40, top: 20),
                  child: Divider(),
                ),
                SizedBox(
                  height: 100,
                )
              ],
            ),
          )),
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
