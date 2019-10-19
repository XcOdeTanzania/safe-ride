import 'package:flutter/material.dart';

class GrapCard extends StatelessWidget {
  final Widget graphWidget;
  final Color graphColor;
  final String graphTitle;
  final String graphSubtitle;
  final String graphTag;
  final String moreInfo;
  final String sender;

  const GrapCard(
      {Key key,
      @required this.graphWidget,
      @required this.graphColor,
      @required this.graphTitle,
      @required this.graphSubtitle,
      @required this.graphTag,
      @required this.moreInfo,
      @required this.sender})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(graphTitle),
              subtitle: sender == "line" ? Text(graphSubtitle) : null,
              trailing: sender == "line"
                  ? Chip(
                      label: Text(
                        graphTag,
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: graphColor,
                    )
                  : null,
            ),
            graphWidget,
            sender == "line"
                ? ButtonTheme.bar(
                    // make buttons use the appropriate styles for cards
                    child: Container(
                      color: graphColor,
                      child: ButtonBar(
                        alignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            moreInfo,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              print('Love of God');
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(),
            sender == "bar"
                ? Row(
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: 10,
                        width: 10,
                        color: Colors.red,
                      ),
                      Text('\tOver Speeding')
                    ],
                  )
                : Container(),
            sender == "bar"
                ? Row(
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: 10,
                        width: 10,
                        color: Colors.blue,
                      ),
                      Text('\tNormal Speed')
                    ],
                  )
                : Container(),
            sender == "bar"
                ? Row(
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: 10,
                        width: 10,
                        color: Colors.black26,
                      ),
                      Text('\tLow Speeding')
                    ],
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
