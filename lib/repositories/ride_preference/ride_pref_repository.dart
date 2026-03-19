import 'dart:async';

import '../../../model/ride_pref/ride_pref.dart';

abstract class RidePreferenceRepository {
  Future<List<RidePreference>> getHistory();
  Future<void> savePreference(RidePreference preference);
  Future<RidePreference?> getCurrentPreference();
}
