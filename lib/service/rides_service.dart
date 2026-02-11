import '../dummy_data/dummy_data.dart';
import '../model/ride/locations.dart';
import '../model/ride/ride.dart';

class RidesService {
  static List<Ride> availableRides = fakeRides; // TODO for now fake data

  //
  //  filter the rides starting from given departure location
  //
  static List<Ride> _filterByDeparture(Location departure) {
    // return availableRides
    //     .where((ride) => ride.departureLocation == departure)
    //     .toList();
    List<Ride> result = [];
    for (Ride ride in availableRides) {
      if (ride.departureLocation == departure) {
        result.add(ride);
      }
    }
    return result;
  }

  //
  //  filter the rides starting for the given requested seat number
  //
  static List<Ride> _filterBySeatRequested(int requestedSeat) {
    // return availableRides
    //     .where((ride) => ride.availableSeats >= requestedSeat)
    //     .toList();
    List<Ride> result = [];
    for (Ride ride in availableRides) {
      if (ride.availableSeats >= requestedSeat) {
        result.add(ride);
      }
    }
    return result;
  }

  //
  //  filter the rides   with several optional criteria (flexible filter options)
  //
  static List<Ride> filterBy({Location? departure, int? seatRequested}) {
    List<Ride> filterRides = availableRides;

    if (departure != null) {
      filterRides = filterRides
          .where((ride) => ride.departureLocation == departure)
          .toList();
    }
    if (seatRequested != null) {
      filterRides = filterRides
          .where((ride) => ride.availableSeats == seatRequested)
          .toList();
    }
    return filterRides;
  }
}
