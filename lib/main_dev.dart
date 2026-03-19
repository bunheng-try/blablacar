import '/repositories/ride/ride_repository_mock.dart';
import 'package:blabla/main_common.dart';
import 'package:flutter/material.dart';
import 'repositories/location/location_repository_mock.dart';
import 'repositories/ride_preference/ride_pref_repository_mock.dart';
import 'repositories/ride/ride_repository_mock.dart';
import 'repositories/ride_preference/ride_pref_repository_mock.dart';

void main() {
  runApp(
    BlaBlaApp(
      locationRepo: LocationRepositoryMock(),
      rideRepo: RideRepositoryMock(),
      prefRepo: RidePreferenceRepositoryMock(),
    ),
  );
}
