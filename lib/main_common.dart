import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'repositories/location/location_repository.dart';
import 'repositories/ride/ride_repository.dart';
import 'repositories/ride_preference/ride_pref_repository.dart';
import 'ui/screens/home/home_screen.dart';
import 'ui/theme/theme.dart';

class BlaBlaApp extends StatelessWidget {
  final LocationRepository locationRepo;
  final RideRepository rideRepo;
  final RidePreferenceRepository prefRepo;

  const BlaBlaApp({
    super.key,
    required this.locationRepo,
    required this.rideRepo,
    required this.prefRepo,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: locationRepo),
        Provider.value(value: rideRepo),
        Provider.value(value: prefRepo),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: blaTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
