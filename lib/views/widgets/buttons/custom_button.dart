import 'package:flutter/material.dart';

typedef CustomButtonOnTap = Function();

class CustomButton extends StatelessWidget {
  final String image;
  final String title;
  final CustomButtonOnTap onTap;

  const CustomButton(
      {Key key,
      @required this.image,
      @required this.title,
      @required this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(15.0),
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.pink),
              color: Colors.white,
            ),
            child: Image.asset(image),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            title,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}
