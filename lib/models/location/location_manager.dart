
import 'package:geocoding/geocoding.dart' as geoCoding;
import 'package:geolocator/geolocator.dart';

import '../../data_models/location.dart' as Local;
import '../../data_models/location.dart';

class LocationManager {
  Future<Local.Location> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {

      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    final Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final placeMarks = await geoCoding.placemarkFromCoordinates(position.latitude, position.longitude);
    final placeMark = placeMarks.first;
    return Future.value(convert(placeMark, position.latitude, position.longitude));

  }

  Local.Location convert(geoCoding.Placemark placeMark, double latitude, double longitude) {
    return Local.Location(
        latitude:latitude,
        longitude:longitude,
        country: placeMark.country ?? "",
        state: placeMark.administrativeArea ?? "",
        city:placeMark.locality ?? ""
    );


  }

  Future<Location>updateLocation(double latitude, double longitude) async {
    final placeMarks = await geoCoding.placemarkFromCoordinates(latitude, longitude);
    final placeMark = placeMarks.first;
    return Future.value(convert(placeMark, latitude, longitude));

  }
}