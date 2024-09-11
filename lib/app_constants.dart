import 'package:latlong2/latlong.dart';

class AppConstants {
  static const String mapBoxAccesToken =
      'pk.eyJ1IjoidmVpbGxlY28iLCJhIjoiY20wdXRpMnBqMTg5cDJyc2owcTJubWUxdyJ9.EwNdB6lzFJD4FupWyZWuKw';
  static const String urlTemplate =
      'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token=$mapBoxAccesToken';
  static const String mapBoxStyleDarkId = 'mapbox/dark-v11';
  static const String mapBoxStyleOutdoorId = 'mapbox/outdoors-v12';
  static const String mapBoxStyleStreetId = 'mapbox/streets-v12';
  static const String mapBoxStyleNightId = 'mapbox/navigation-night-v1';

  static var mylocation = LatLng(51.5, -0.09);
}
