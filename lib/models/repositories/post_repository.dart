import 'dart:async';
import 'dart:io';
import 'package:geocoding/geocoding.dart' as geoCoding;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swinglam/models/db/databese_manager.dart';
import 'package:swinglam/models/location/location_manager.dart';
import '../../constants.dart';
import '../../data_models/location.dart' as Local;

class PostRepository {
  final DatabaseManager dbManager;
  final LocationManager locationManager;
  File? imageFile;

  PostRepository({required this.dbManager, required this.locationManager});

  Future<File?> pickImage(UploadType uploadType) async {
    final ImagePicker _picker = ImagePicker();

    if(uploadType == UploadType.GALLERY){
      final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
      return (pickedImage != null) ? File(pickedImage.path) : null;
    } else {
      final pickedImage = await _picker.pickImage(source: ImageSource.camera);
      return (pickedImage != null) ? File(pickedImage.path) : null;
    }

  }

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
    final List<Placemark> placeMarks = await geoCoding.placemarkFromCoordinates(position.latitude, position.longitude);
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


}