import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps/constants/map_button_constant.dart';
import 'package:maps/constants/map_button_sizedbox_constant.dart';
import 'package:maps/widgets/map_button_widget.dart';

class GoogleMapWidget extends StatefulWidget {
  final LatLng target;
  final void Function(GoogleMapController) onMapCreated;
  final MapType mapType;
  final Set<Marker> markers;
  final void Function() buttonPressed;
  final void Function() markerAndLocationPress;

  const GoogleMapWidget(
      {Key? key,
      required this.target,
      required this.onMapCreated,
      required this.mapType,
      required this.markers,
      required this.buttonPressed,
      required this.markerAndLocationPress})
      : super(key: key);

  @override
  _GoogleMapWidgetState createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition:
              CameraPosition(target: widget.target, zoom: 11.0),
          onMapCreated: widget.onMapCreated,
          mapType: widget.mapType,
          myLocationButtonEnabled: true,
          markers: widget.markers,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.topRight,
            child: Column(
              children: [
                MapButtonWidget(
                  onpress: widget.buttonPressed,
                  color: Colors.green,
                  icon: Icon(
                    Icons.map,
                    size: kSize,
                  ),
                ),
                SizedBox(
                  height: kHeight,
                ),
                MapButtonWidget(
                  onpress: widget.markerAndLocationPress,
                  color: Colors.green,
                  icon: Icon(
                    Icons.location_on,
                    size: kSize,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
