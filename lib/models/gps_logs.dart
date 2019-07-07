import 'package:flutter/foundation.dart';

class GPSLogs {
  final double latitude;
  final double longitude;
  final double altitude;
  final double speed;
  GPSLogs({
    @required this.latitude,
    @required this.longitude,
    @required this.altitude,
    @required this.speed,
  });
}
