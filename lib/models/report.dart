import 'package:flutter/foundation.dart';

class Report {
  final int id;
  final String image;
  final String platNo;
  final String message;
  final int stationId;

  Report({
    @required this.id,
    @required this.image,
    @required this.platNo,
    @required this.message,
    @required this.stationId,
  });

  Report.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        image = map['image'],
        platNo = map['plat_no'],
        message = map['message'],
        stationId = map['station_id'];
}
