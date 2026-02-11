import 'package:flutter/material.dart';
import '../../../model/ride/locations.dart';
import '../../../service/locations_service.dart';
import '../../../theme/theme.dart';

class LocationPicker extends StatefulWidget {
  final String title;
  final Function(Location) onLocationSelected;

  const LocationPicker({
    super.key,
    required this.title,
    required this.onLocationSelected,
  });

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  final TextEditingController _searchController = TextEditingController();
  List<Location> _filteredLocations = [];

  @override
  void initState() {
    super.initState();
    _filteredLocations = LocationsService.availableLocations;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      final query = _searchController.text.toLowerCase();
      if (query.isEmpty) {
        _filteredLocations = LocationsService.availableLocations;
      } else {
        _filteredLocations = LocationsService.availableLocations
            .where(
              (location) =>
                  location.name.toLowerCase().contains(query) ||
                  location.country.name.toLowerCase().contains(query),
            )
            .toList();
      }
    });
  }

  Map<Country, List<Location>> _groupLocationsByCountry() {
    final Map<Country, List<Location>> grouped = {};
    for (var location in _filteredLocations) {
      if (!grouped.containsKey(location.country)) {
        grouped[location.country] = [];
      }
      grouped[location.country]!.add(location);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final groupedLocations = _groupLocationsByCountry();

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 8),
                Text(widget.title, style: BlaTextStyles.heading),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search locations...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: BlaColors.primary),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: groupedLocations.length,
              itemBuilder: (context, index) {
                final country = groupedLocations.keys.elementAt(index);
                final locations = groupedLocations[country]!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Text(
                        country.name,
                        style: BlaTextStyles.label.copyWith(
                          color: BlaColors.textLight,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ...locations.map(
                      (location) => ListTile(
                        leading: Icon(
                          Icons.location_on_outlined,
                          color: BlaColors.iconLight,
                        ),
                        title: Text(location.name, style: BlaTextStyles.body),
                        subtitle: Text(
                          location.country.name,
                          style: BlaTextStyles.label.copyWith(
                            color: BlaColors.textLight,
                          ),
                        ),
                        trailing: Icon(
                          Icons.chevron_right,
                          color: BlaColors.iconLight,
                        ),
                        onTap: () {
                          widget.onLocationSelected(location);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const Divider(height: 1),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
