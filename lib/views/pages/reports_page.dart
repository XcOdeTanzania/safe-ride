import 'package:flutter/material.dart';
import 'package:safe_ride/views/widgets/alerts/no_data.dart';
import 'package:safe_ride/styles/style.dart' as ThemeColor;

class ReportsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports'),
      ),
      body: NoDataYet(
        color: ThemeColor.Colors.saferidePrimaryColor,
        icon: Icons.library_books,
        title: 'No Reports recorded',
      ),
    );
  }
}
