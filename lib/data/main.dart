import 'package:scoped_model/scoped_model.dart';

import 'connected_safe_ride.dart';

class MainModel extends Model
    with
        ConnectedSafeRideModel,
        UtilityModel,
        LoginModel,
        StationModel,
        ReportModel {}
