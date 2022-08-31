import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:swinglam/data_models/location.dart';

import '../../../view_models/post_view_model.dart';

class MapScreen extends StatefulWidget {
  final Location location;

  MapScreen({required this.location});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LatLng _latLng;
  late CameraPosition _cameraPosition;
  GoogleMapController? _mapController;
  Map<MarkerId, Marker> _marker = <MarkerId, Marker>{};

  @override
  void initState() {
    _latLng = LatLng(widget.location.latitude, widget.location.longitude);
    _cameraPosition = CameraPosition(target: _latLng, zoom: 10.0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("場所を選択"),
        actions: [
          IconButton(
              onPressed: () => onPlaceSelected(),
              icon: Icon(Icons.done)
          ),

        ],
      ),
      body: GoogleMap(
        initialCameraPosition: _cameraPosition,
        onMapCreated: onMapCreated,
        onTap: onMapTapped,
        markers: Set<Marker>.of(_marker.values),
      ),
    );
  }

  void onMapCreated(GoogleMapController controller) {
  }

  void onMapTapped(LatLng latLng) {
    _latLng = latLng;
    _createMarker(_latLng);
  }

  void _createMarker(LatLng latLng) {
    final markerId = MarkerId("selected");
    final marker = Marker(markerId: markerId, position: latLng);
    setState((){
      _marker[markerId] = marker;
    });
  }

  onPlaceSelected() {
    final postViewModel = context.read<PostViewModel>();
    postViewModel.updateLocation(widget.location.latitude, widget.location.longitude);

  }
}
