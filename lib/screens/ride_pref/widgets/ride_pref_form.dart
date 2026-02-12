import 'package:flutter/material.dart';
import '../widgets/location_picker.dart';
import '../../../model/ride/locations.dart';
import '../../../model/ride_pref/ride_pref.dart';
import '../../../service/locations_service.dart';
import '../../../service/ride_prefs_service.dart';
import '../../../theme/theme.dart';
import '../../../utils/date_time_util.dart';

///
/// A Ride Preference Form is a view to select:
///   - A departure location
///   - An arrival location
///   - A date
///   - A number of seats
///
/// The form can be created with an existing RidePref (optional).
class RidePrefForm extends StatefulWidget {
  final RidePref? initRidePref;
  final Function(RidePref)? onSearch;

  const RidePrefForm({super.key, this.initRidePref, this.onSearch});

  @override
  State<RidePrefForm> createState() => _RidePrefFormState();
}
Future<Location?> _showLocationPicker(
  BuildContext context,
  String title,
) async {
  return showModalBottomSheet<Location>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => LocationPicker(
      title: title,
      onLocationSelected: (location) {
        Navigator.pop(context, location);
      },
    ),
  );
}
class _RidePrefFormState extends State<RidePrefForm> {
  Location? departure;
  late DateTime departureDate;
  Location? arrival;
  late int requestedSeats;

  // ----------------------------------
  // Initialize the Form attributes
  // ----------------------------------

  @override
  void initState() {
    super.initState();
    if (widget.initRidePref != null) {
      departure = widget.initRidePref!.departure;
      departureDate = widget.initRidePref!.departureDate;
      arrival = widget.initRidePref!.arrival;
      requestedSeats = widget.initRidePref!.requestedSeats;
    } else {
      departureDate = DateTime.now().add(const Duration(days: 1));
      requestedSeats = 1;
    }
  }

  // ----------------------------------
  // Handle events
  // ----------------------------------

  void _onDepartureSelected() async {
    final selected = await _showLocationPicker(context, 'Select Departure');
    if (selected != null) {
      setState(() {
        departure = selected;
      });
    }
  }

  void _onArrivalSelected() async {
    final selected = await _showLocationPicker(context, 'Select Arrival');
    if (selected != null) {
      setState(() {
        arrival = selected;
      });
    }
  }

  void _onDateSelected() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: departureDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (selected != null) {
      setState(() {
        departureDate = selected;
      });
    }
  }

  void _onSeatsChanged(int delta) {
    setState(() {
      requestedSeats = (requestedSeats + delta).clamp(1, 8);
    });
  }

  void _onSearchPressed() {
    if (_isFormValid()) {
      final ridePref = RidePref(
        departure: departure!,
        departureDate: departureDate,
        arrival: arrival!,
        requestedSeats: requestedSeats,
      );
      widget.onSearch?.call(ridePref);
      if (widget.onSearch != null) {
        widget.onSearch!(ridePref);
      }
    }
  }

  void _swapLocations() {
    if (departure != null && arrival != null) {
      setState(() {
        final temp = departure;
        departure = arrival;
        arrival = temp;
      });
    }
  }

  // ----------------------------------
  // Compute the widgets rendering
  // ----------------------------------

  bool _isFormValid() {
    return departure != null && arrival != null && departure != arrival;
  }
  // ----------------------------------
  // Build the widgets
  // ----------------------------------
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(BlaSpacings.l),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildLocationField(
            icon: Icons.radio_button_checked,
            label: departure?.name ?? 'Select departure',
            onTap: _onDepartureSelected,
          ),
          const SizedBox(height: BlaSpacings.s),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: Icon(Icons.swap_vert, color: BlaColors.primary, size: 24),
              onPressed: _swapLocations,
            ),
          ),
          const SizedBox(height: BlaSpacings.s),
          _buildLocationField(
            icon: Icons.location_on,
            label: arrival?.name ?? 'Select arrival',
            onTap: _onArrivalSelected,
          ),
          const SizedBox(height: BlaSpacings.m),
          _buildDateField(
            icon: Icons.calendar_today,
            label: DateTimeUtils.formatDateTime(departureDate),
            onTap: _onDateSelected,
          ),
          const SizedBox(height: BlaSpacings.m),
          _buildSeatsField(
            icon: Icons.person,
            count: requestedSeats,
            onDecrement: () => _onSeatsChanged(-1),
            onIncrement: () => _onSeatsChanged(1),
          ),
          const SizedBox(height: BlaSpacings.l),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: _isFormValid() ? _onSearchPressed : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: BlaColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 0,
                disabledBackgroundColor: Colors.grey[300],
              ),
              child: const Text(
                'Search',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationField({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: BlaSpacings.m,
          vertical: BlaSpacings.m,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey[600], size: 20),
            const SizedBox(width: BlaSpacings.m),
            Expanded(child: Text(label, style: BlaTextStyles.body)),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: BlaSpacings.m,
          vertical: BlaSpacings.m,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey[600], size: 20),
            const SizedBox(width: BlaSpacings.m),
            Text(label, style: BlaTextStyles.body),
          ],
        ),
      ),
    );
  }

  Widget _buildSeatsField({
    required IconData icon,
    required int count,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: BlaSpacings.m,
        vertical: BlaSpacings.m,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 20),
          const SizedBox(width: BlaSpacings.m),
          Text(count.toString(), style: BlaTextStyles.body),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: count > 1 ? onDecrement : null,
            color: BlaColors.primary,
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: count < 8 ? onIncrement : null,
            color: BlaColors.primary,
          ),
        ],
      ),
    );
  }
}
