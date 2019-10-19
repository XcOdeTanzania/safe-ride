import 'package:flutter/material.dart';
import 'package:safe_ride/views/pages/reports/create_report.dart';
import 'package:safe_ride/views/widgets/buttons/custom_button.dart';
import 'package:safe_ride/styles/style.dart' as ThemeColor;
import 'package:url_launcher/url_launcher.dart';

class ReportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report Accident'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Choose Accident Type',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: CustomButton(
                  image: 'assets/icons/accident-one.png',
                  title: 'Vehicle/Vehicle',
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => CreateReportPage(
                                title: 'Vehicle/Vehicle',
                              ))),
                )),
                Expanded(
                    child: CustomButton(
                  image: 'assets/icons/accident-two.png',
                  title: 'Vehicle/Person',
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => CreateReportPage(
                                title: 'Vehicle/Person',
                              ))),
                ))
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: CustomButton(
                  image: 'assets/icons/accident-three.png',
                  title: 'Vehicle/Animal',
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => CreateReportPage(
                                title: 'Vehicle/Obstacle',
                              ))),
                )),
                Expanded(
                    child: CustomButton(
                  image: 'assets/icons/accident-four.png',
                  title: 'Vehicle/Obstacle',
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => CreateReportPage(
                                title: 'Vehicle/Obstacle',
                              ))),
                ))
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Divider(
              endIndent: 10,
              indent: 10,
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      'Police Emergency Contacts',
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton.icon(
                      color: ThemeColor.Colors.saferidePrimaryColor,
                      icon: Icon(
                        Icons.call,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Call Now',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () => _launchURL(url: 'tel:+255 654 940 138'),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton.icon(
                      color: ThemeColor.Colors.saferidePrimaryColor,
                      icon: Icon(
                        Icons.message,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Message',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () => _launchURL(url: 'sms:+255 625 756 752'),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _launchURL({@required String url}) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
