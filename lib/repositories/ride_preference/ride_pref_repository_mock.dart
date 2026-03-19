import 'package:blabla/model/ride/ride.dart';
import '../../../data/dummy_data.dart';
import '../../../model/ride_pref/ride_pref.dart';
import '../ride_preference/ride_pref_repository.dart';

class RidePreferenceRepositoryMock implements RidePreferenceRepository {
  final List<RidePreference> _history = [...fakeRidePrefs];
  RidePreference? _current;

  @override
  Future<List<RidePreference>> getHistory() async => _history;

  @override
  Future<RidePreference?> getCurrentPreference() async => _current;

  @override
  Future<void> savePreference(RidePreference pref) async {
    if (_isSame(pref)) return;
    _current = pref;
    _history.add(pref);
  }

  bool _isSame(RidePreference pref) => pref == _current;
}
