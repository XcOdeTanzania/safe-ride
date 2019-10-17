import 'package:flutter/foundation.dart';

class Station {
  final int id;
  final String name;
  final String idStation;
  final double latitude;
  final double longitude;
  final String district;
  final String idDistrict;
  final String region;
  final List<dynamic> reports;

  Station({
    @required this.id,
    @required this.name,
    @required this.idStation,
    @required this.latitude,
    @required this.longitude,
    @required this.district,
    @required this.idDistrict,
    @required this.region,
    @required this.reports,
  });

  Station.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        idStation = map['id_station'],
        latitude = map['latitude'] == 0
            ? 0.00000000000000
            : double.parse(map['latitude'].toString()),
        longitude = map['longitude'] == 0
            ? 0.0000000000000
            : double.parse(map['longitude'].toString()),
        district = map['district'],
        idDistrict = map['id_district'],
        region = map['region'],
        reports = map['reports'];
}
