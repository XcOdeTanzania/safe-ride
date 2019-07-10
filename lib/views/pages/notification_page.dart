import 'package:flutter/material.dart';
import 'package:safe_ride/data/main.dart';
import 'package:scoped_model/scoped_model.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Scaffold(
            appBar: AppBar(
              title: Text('Notification'),
            ),
            body: ListView.builder(
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  child: ListTile(
                  leading: Icon(
                    Icons.notifications,
                    color: Color(0xFFf43f5f),
                  ),
                  title: Text(
                    'notification ' + (index + 1).toString(),
                    textAlign: TextAlign.left,
                  ),
                  onTap: () {},
                ),
                );
              },
            ));
      },
    );
  }
}
