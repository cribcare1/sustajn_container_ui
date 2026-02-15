import 'package:flutter/material.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sustajn_restaurant/constants/string_utils.dart';

class SearchPlaceScreen extends StatelessWidget {
  const SearchPlaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GooglePlaceAutoCompleteTextField(
          textEditingController: TextEditingController(),
          googleAPIKey: Strings.G_MAP_API_KEY,
          debounceTime: 400,
          countries: ["in"],
          isLatLngRequired: true,
          inputDecoration: const InputDecoration(
              hintText: "Search place", border: OutlineInputBorder()),
          getPlaceDetailWithLatLng: (Prediction p) {
            Navigator.pop(context, {
              "latLng": LatLng(
                double.parse(p.lat!),
                double.parse(p.lng!),
              )
            });
          },
        ),
      ),
    );
  }
}
