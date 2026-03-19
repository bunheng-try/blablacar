import 'package:blabla/model/ride_pref/ride_pref.dart';

import '../../../data/dummy_data.dart';
import '../../../model/ride/ride.dart';
import '../ride/ride_repository.dart';

class RideRepositoryMock implements RideRepository {
  @override
  Future<List<Ride>> getRidesFor(RidePreference preferences) async {
    return fakeRides.where((ride) => _matches(ride, preferences)).toList();
  }

  bool _matches(Ride ride, RidePreference pref) {
    return ride.departureLocation == pref.departure &&
        ride.arrivalLocation == pref.arrival &&
        ride.availableSeats >= pref.requestedSeats;
  }
}
