import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:safe_ride/constants/constants.dart';
import 'package:safe_ride/data/main.dart';

import 'package:safe_ride/styles/style.dart' as ThemeColor;
import 'package:safe_ride/views/pages/signup_page.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  TextEditingController _emailTextEditingController = TextEditingController();
  TextEditingController _passwordloginTextEditingController =
      TextEditingController();
  bool _obscureTextLogin = true;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();

    _emailTextEditingController.dispose();
    _passwordloginTextEditingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Container(
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
          child: Scaffold(
              backgroundColor: Colors.transparent,
              key: _scaffoldKey,
              body: SingleChildScrollView(
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
                                  color:
                                      ThemeColor.Colors.saferideSecondaryColor,
                                  fontWeight: FontWeight.bold))
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: new Image(
                          width: 100.0,
                          height: 100.0,
                          fit: BoxFit.fill,
                          image: new AssetImage('assets/icons/logo.png')),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 1.0),
                      child: Text('SAFE RIDE',
                          style: TextStyle(
                              fontFamily: 'trajanProRegular',
                              fontSize: 17.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 20.0, bottom: 10.0, left: 25.0, right: 25.0),
                      child: Theme(
                        data: new ThemeData(
                          primaryColor: Colors.white,
                          primaryColorDark: Colors.red[50],
                        ),
                        child: Container(
                          height: 50,
                          child: TextField(
                            focusNode: _emailFocusNode,
                            keyboardType: TextInputType.emailAddress,
                            controller: _emailTextEditingController,
                            style: TextStyle(fontSize: 16.0, color: Colors.black),
                            decoration: InputDecoration(
                                //focusColor: Colors.white,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(color: Colors.white)),
                                hintText: "Email",
                                labelText: "Email",
                                labelStyle: TextStyle(color: Colors.white),
                                hintStyle: TextStyle(
                                    fontFamily: "WorkSansSemiBold",
                                    fontSize: 17.0,
                                    color: Colors.white),
                                prefixIcon: Icon(
                                  FontAwesomeIcons.envelope,
                                  size: 22.0,
                                  color: Colors.white,
                                )),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: 20.0, left: 25.0, right: 25.0),
                      child: Theme(
                        data: new ThemeData(
                          primaryColor: Colors.white,
                          primaryColorDark: Colors.red[50],
                        ),
                        child: Container(
                          height: 50,
                          child: TextField(
                            focusNode: _passwordFocusNode,
                            controller: _passwordloginTextEditingController,
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
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5.0),
                      child: RaisedButton(
                          color: Colors.pinkAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 42.0),
                            child: Text(
                              "LOGIN",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17.0,
                                  fontFamily: "WorkSansBold"),
                            ),
                          ),
                          onPressed: () {
                            model
                                .signInWithEmail(
                                    email: _emailTextEditingController.text,
                                    password:
                                        _passwordloginTextEditingController
                                            .text)
                                .then((value) {
                              Navigator.of(context)
                                  .pushReplacementNamed(homeScreen);
                            });
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
                            height: 10,
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
                        padding: EdgeInsets.only(
                            left: 15.0, right: 15.0, bottom: 10),
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
                              model.signInWithGoogle().then((value) {});
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
                              model
                                  .signInWithFaceBook()
                                  .then((Map<String, dynamic> response) {
                                if (response['success'])
                                  showInSnackBar("Signin Successfuly");
                                else
                                  showInSnackBar(
                                      'Signin Failled, ${response['message']}');
                              });
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
                            height: 10,
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
                        padding: EdgeInsets.only(
                            left: 15.0, right: 15.0, bottom: 10),
                        child: FlatButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => SignupPage()));
                            },
                            child: Text(
                              "Don't have an account?, Register!",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontFamily: "WorkSansMedium"),
                            )),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 40, right: 40, top: 20),
                      child: Divider(),
                    ),
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
