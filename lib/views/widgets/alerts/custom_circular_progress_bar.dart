import 'package:flutter/material.dart';

class CustomCircularProgressBar extends StatelessWidget {
  final int divider;

  const CustomCircularProgressBar({Key key, @required this.divider})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
          child: Container(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
        ),
        height: 50,
        width: 50,
      ));
  }
}
