import 'package:caderno_do_campo/model/location_model.dart';
import 'package:location/location.dart';
import 'package:result_dart/result_dart.dart';

class LocationService {
  AsyncResultDart<LocationModel, Exception> getlocation() async {
    Location location = Location();
    bool serviceEnabled;
    int tryies = 0;
    PermissionStatus permissionGranted;
    LocationData locationData;
    LocationModel local;

    serviceEnabled = await location.serviceEnabled();
    for (tryies; (!serviceEnabled && tryies < 3); tryies++) {
      serviceEnabled = await location.requestService();
    }

    tryies = 0;
    if (serviceEnabled) {
      permissionGranted = await location.hasPermission();
      for (
        tryies;
        (permissionGranted == PermissionStatus.denied && tryies < 3);
        tryies++
      ) {
        permissionGranted = await location.requestPermission();
      }
    }

    locationData = await location.getLocation();
    local = LocationModel(locationData.latitude!, locationData.longitude!);

    return Success(local);
  }
}
