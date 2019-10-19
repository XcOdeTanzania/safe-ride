import 'package:flutter/foundation.dart';

class Report {
  final int id;
  final String image;
  final String platNo;
  final String message;
  final int stationId;
  final int reportId;
  final String uid;
  final String createdAt;

  Report(
      {@required this.id,
      @required this.image,
      @required this.platNo,
      @required this.message,
      @required this.stationId,
      @required this.reportId,
      @required this.uid,
      @required this.createdAt});

  Report.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        image = map['image'],
        platNo = map['plat_no'].toString(),
        message = map['message'].toString(),
        createdAt = map['created_at'],
        stationId = map['station_id'],
        reportId = map['report_id'],
        uid = map['uid'].toString();
}
