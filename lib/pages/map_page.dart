import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps/widgets/google_map_widget.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  var _center;
  var _currentUser;
  MapType _currentMapType = MapType.normal;

  void getCurrentUser(){
    var currentUser = FirebaseAuth.instance.currentUser;
    if(currentUser != null){
      _currentUser = currentUser;
    }
  }

  late double latitude;
  late double longitude;

  // function for getting the current location
  // but before that you need to add this permission!
  void getCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    var lati = position.latitude;
    var long = position.longitude;

    // passing this to latitude and longitude strings
    latitude = lati;
    longitude = long;

    setState(() {
      _center = LatLng(latitude, longitude);
    });
  }

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  Set<Marker> _createMarker() {
    return {
      Marker(
        markerId: MarkerId("marker_1"),
        position: _center,
        infoWindow: InfoWindow(title: 'Marker 1'),
      ),
    };
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Maps Sample App'),
        backgroundColor: Colors.green[700],
      ),
      body: GoogleMapWidget(
        target: _center,
        onMapCreated: _onMapCreated,
        mapType: _currentMapType,
        markers: _createMarker(),
        buttonPressed: _onMapTypeButtonPressed,
        markerAndLocationPress: () {
          getCurrentLocation();
          _createMarker();
        },
      ),
    );
  }
}
