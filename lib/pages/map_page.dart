import 'package:cloud_firestore/cloud_firestore.dart';
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
  var _newCenter;
  late double newLatitude;
  late double newLongitude;
  late double latitude;
  late double longitude;

  MapType _currentMapType = MapType.normal;

  final firestoreInstance = FirebaseFirestore.instance;

  void onPressed() {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    firestoreInstance.collection("Users").doc(firebaseUser!.uid).update({
      "latitude": latitude,
      "longitude": longitude,
    }).then((_) {
      print("success!");
    });
  }

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

  void onPressedListenLocation() {
    firestoreInstance
        .collection("Users")
        .where("latitude")
        .where("longitude")
        .snapshots()
        .listen((result) {
      result.docs.forEach((result) {
        onPressedGetLocation();
      });
    });
  }

  void onPressedGetLocation() {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    firestoreInstance
        .collection("Users")
        .doc(firebaseUser!.uid)
        .get()
        .then((value) {
      newLatitude = value.data()!["latitude"];
      newLongitude = value.data()!["longitude"];
      setState(() {
        _center = LatLng(newLatitude, newLongitude);
      });
    });
  }

  var myId;

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

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

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
        onpress: onPressed,
        longPress: (LatLng latLng) {
          var markerIdVal = markers.length + 1;
          String mar = markerIdVal.toString();
          final MarkerId markerId = MarkerId(mar);
          final Marker marker = Marker(markerId: markerId, position: _center);

          setState(() {
            markers[markerId] = marker;
          });
        },
      ),
    );
  }
}
