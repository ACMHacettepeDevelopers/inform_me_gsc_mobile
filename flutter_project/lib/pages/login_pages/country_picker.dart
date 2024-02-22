// country_picker.dart

import 'package:country_pickers/country_pickers.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';

class CountryPicker extends StatefulWidget {
  final void Function(String, String) onCountryChanged;

  const CountryPicker({Key? key, required this.onCountryChanged})
      : super(key: key);

  @override
  State<CountryPicker> createState() => _CountryPickerState();
}

class _CountryPickerState extends State<CountryPicker> {
  String countryValue = "";
  String countryAlpha2 = "";
  Map<String, String> countryToAlpha2 = {
    "Argentina": "AR",
    "Australia": "AU",
    "Austria": "AT",
    "Belgium": "BE",
    "Brazil": "BR",
    "Canada": "CA",
    "Chile": "CL",
    "Denmark": "DK",
    "Finland": "FI",
    "France": "FR",
    "Germany": "DE",
    "Hong Kong": "HK",
    "India": "IN",
    "Indonesia": "ID",
    "Italy": "IT",
    "Japan": "JP",
    "Korea": "KR",
    "Malaysia": "MY",
    "Mexico": "MX",
    "Netherlands": "NL",
    "New Zealand": "NZ",
    "Norway": "NO",
    "China": "CN",
    "Poland": "PL",
    "Portugal": "PT",
    "Philippines": "PH",
    "Russia": "RU",
    "Saudi Arabia": "SA",
    "South Africa": "ZA",
    "Spain": "ES",
    "Sweden": "SE",
    "Switzerland": "CH",
    "Taiwan": "TW",
    "Turkey": "TR",
    "United Kingdom": "GB",
    "United States": "US",
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(50, 3, 50, 5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.orange),
          borderRadius: BorderRadius.circular(12),
        ),
        child: CSCPicker(
          flagState: CountryFlag.DISABLE,
          disabledDropdownDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            border: Border.all(
              color: Colors.grey.shade300,
              width: 2,
            ),
          ),
          dropdownDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1,
            ),
          ),
          dropdownHeadingStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          showCities: false,
          showStates: false,
          searchBarRadius: 50,
          defaultCountry: CscCountry.Turkey,
          countryDropdownLabel: countryValue,
          onCountryChanged: (value) {
            setState(() {
              countryValue = value;
              countryAlpha2 = countryToAlpha2[value] ?? '';
              print("Selected Country: $countryValue, Alpha-2: $countryAlpha2");
            });
            // Call the callback function with both country name and alpha-2 code
            widget.onCountryChanged(countryValue, countryAlpha2);
          },
        ),
      ),
    );
  }
}
