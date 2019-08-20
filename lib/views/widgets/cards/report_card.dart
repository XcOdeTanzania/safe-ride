import 'package:flutter/material.dart';
import 'package:safe_ride/api/api.dart';
import 'package:safe_ride/models/report.dart';

typedef ReportCardTap = Function();

class ReportCard extends StatelessWidget {
  final Report report;

  final ReportCardTap onTap;
  const ReportCard({
    Key key,
    @required this.report,
    @required this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    ///decoration
    var decoration = DecoratedBox(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          image: DecorationImage(
              image: NetworkImage(api + 'report/img/' + report.id.toString()),
              fit: BoxFit.cover)),
    );

    ///hero animation
    // var hero = Hero(
    //   tag: news.tag,
    //   child: decoration,
    // );
    return InkWell(
      onTap: onTap,
      child: Container(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                child: Container(
                  height: 120,
                  child: decoration,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(report.platNo, style: TextStyle(color: Colors.black26)),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Text(
                      report.message,
                      maxLines: 3,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Divider(
                      color: Colors.black26,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
