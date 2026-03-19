import '../../../data/dummy_data.dart';
import '../../../model/ride/locations.dart';
import '../location/location_repository.dart';

class LocationRepositoryMock implements LocationRepository {
  @override
  Future<List<Location>> getLocations() async {
    return fakeLocations;
  }
}
