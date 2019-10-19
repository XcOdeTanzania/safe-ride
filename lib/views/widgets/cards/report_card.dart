import 'package:flutter/material.dart';
import 'package:safe_ride/api/api.dart';
import 'package:safe_ride/models/report.dart';

typedef ReportCardTap = Function();

class ReportCard extends StatelessWidget {
  final Report report;
  final String title;

  final ReportCardTap onTap;
  const ReportCard({
    Key key,
    @required this.report,
    @required this.onTap,
    @required this.title,
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

    return InkWell(
      onTap: onTap,
      child: Container(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                child: Container(
                  margin: EdgeInsets.all(10),
                  height: 120,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: new AssetImage('assets/img/map.png'),
                    fit: BoxFit.cover,
                  )),
                  child: decoration,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(title + ':' + report.platNo,
                        style: TextStyle(
                          color: Colors.black26,
                          fontWeight: FontWeight.bold,
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Time: ' + report.createdAt,
                        style: TextStyle(color: Colors.black26)),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Details:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Text(
                        report.message,
                        maxLines: 3,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black26),
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
              ),
            )
          ],
        ),
      ),
    );
  }
}
