import 'package:flutter/material.dart';

class DropDownCountries extends StatefulWidget {
  final Function(String?, String?) onSelected;
  const DropDownCountries({
    super.key,
    required this.onSelected,
  });

  @override
  State<DropDownCountries> createState() => _DropDownCountriesState();
}

class _DropDownCountriesState extends State<DropDownCountries> {
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
    return DropdownMenu<String>(
        initialSelection: 'Turkey',
        dropdownMenuEntries: countryToAlpha2.keys
            .toList()
            .map((value) =>
                DropdownMenuEntry<String>(value: value, label: value))
            .toList(),
        onSelected: (value) {
          widget.onSelected(value, countryToAlpha2[value]);
        });
  }
}
