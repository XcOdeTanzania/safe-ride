import 'package:flutter/material.dart';

class NoDataYet extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const NoDataYet(
      {Key key,
      @required this.title,
      @required this.icon,
      @required this.color})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height / 5,
          ),
          Icon(
            icon,
            color: color,
            size: 120,
          ),
          Text(title,
              style: TextStyle(
                  fontFamily: 'bebas-neue', fontSize: 25.0, color: color))
        ],
      ),
    );
  }
}
