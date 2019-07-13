import 'package:flutter/material.dart';

class CustomCircularProgressBar extends StatelessWidget {
  final int divider;

  const CustomCircularProgressBar({Key key, @required this.divider})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(top: MediaQuery.of(context).size.width / divider),
      child: Center(
          child: Container(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
        height: 50,
        width: 50,
      )),
    );
  }
}
