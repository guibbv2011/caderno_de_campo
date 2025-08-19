import 'package:caderno_do_campo/model/location_model.dart';
import 'package:location/location.dart';
import 'package:result_dart/result_dart.dart';

class LocationService {
  AsyncResultDart<LocationModel, Exception> getlocation() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
    }

    locationData = await location.getLocation();

    final local = LocationModel(
      locationData.latitude!,
      locationData.longitude!,
    );

    return Success(local);
  }
}
