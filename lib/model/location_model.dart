class LocationModel {
  double latitude = 0.0;
  double longitude = 0.0;

  LocationModel(this.latitude, this.longitude);

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(map['latitude'] as double, map['longitude'] as double);
  }
}
