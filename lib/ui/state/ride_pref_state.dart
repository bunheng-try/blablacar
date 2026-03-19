import '../../repositories/ride_preference/ride_pref_repository.dart';
import 'package:blabla/model/ride_pref/ride_pref.dart';
import 'package:flutter/material.dart';

class RidePreferenceState extends ChangeNotifier {
  final RidePreferenceRepository repository;

  RidePreference? current;
  final List<RidePreference> history = [];

  RidePreferenceState(this.repository);
  Future<void> loadHistory() async {
    history.clear();
    history.addAll(await repository.getHistory());
    notifyListeners();
  }
  void selectPreference(RidePreference preference) {
    if (current != preference) {
      current = preference;

      if (!history.contains(preference)) {
        history.insert(0, preference);
      }

      notifyListeners();
    }
  }
}
