import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safe_ride/data/main.dart';
import 'package:safe_ride/models/station.dart';
import 'package:scoped_model/scoped_model.dart';

class MapPage extends StatefulWidget {
  final MainModel model;
  final Station station;

  const MapPage({Key key, @required this.model, @required this.station})
      : super(key: key);
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  CameraPosition _kGooglePlex;
  Marker marker;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  @override
  void initState() {
 
    super.initState();
  }

  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    BitmapDescriptor myIcon;
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(48, 48)), 'assets/icons/car.png')
        .then((onValue) {
      myIcon = onValue;
    });
    var markerIdVal = widget.station.id.toString();
    final MarkerId markerId = MarkerId(markerIdVal);

    _kGooglePlex = CameraPosition(
      target: LatLng(widget.station.latitude, widget.station.longitude),
      zoom: 14.4746,
    );

    marker = Marker(
      icon: myIcon,
      markerId: markerId,
      position: LatLng(widget.station.latitude, widget.station.longitude),
      infoWindow: InfoWindow(title: widget.station.name, snippet: '*'),
      onTap: () {
        //_onMarkerTapped(markerId);
      },
    );

    markers[markerId] = marker;

    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: new AssetImage('assets/img/wood_bk.jpg'),
            fit: BoxFit.cover,
          )),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text(widget.station.name + ' POLICE STATION',
                  style: TextStyle(
                    fontFamily: 'bebas-neue',
                    fontSize: 15.0,
                  )),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.info_outline),
                  onPressed: () {
                    _detailsModalBottomSheet(context);
                  },
                )
              ],
              backgroundColor: Colors.transparent,
            ),
            body: Padding(
                padding: EdgeInsets.all(20),
                child: GoogleMap(
                  mapType: MapType.satellite,
                  initialCameraPosition: _kGooglePlex,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  markers: Set<Marker>.of(markers.values),
                )),
          ),
        );
      },
    );
  }

  void _detailsModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.map),
                    title: new Text(widget.station.region + ' (region)'),
                    onTap: () => {}),
                new ListTile(
                  leading: new Icon(Icons.place),
                  title: new Text(widget.station.district + ' (district)'),
                  onTap: () => {},
                ),
                new ListTile(
                  leading: new Icon(Icons.receipt),
                  title: new Text('0 reports'),
                  onTap: () => {},
                ),
              ],
            ),
          );
        });
  }
}
