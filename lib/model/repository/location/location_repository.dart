import 'package:caderno_do_campo/model/location_model.dart';
import 'package:caderno_do_campo/model/service/location/location_service.dart';
import 'package:result_dart/result_dart.dart';

class LocationRepository {
  final LocationService locationService;

  LocationRepository({required this.locationService});
  AsyncResult<LocationModel> fetchLocation() async {
    final response = await locationService.getlocation();

    return response.fold(
      (value) {
        return Success(value);
      },
      (error) {
        return Failure(Exception(error.toString()));
      },
    );
  }
}
