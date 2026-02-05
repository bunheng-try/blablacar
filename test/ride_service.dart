import 'package:blablacar/model/ride/locations.dart';
import 'package:blablacar/service/rides_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:blablacar/main.dart';

void main() {
  RidesService.filterBy(
    departure: Location(name: "Dajon", country: Country.france),
    seatRequested: 2
  );
}
