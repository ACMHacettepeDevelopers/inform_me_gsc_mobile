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

  String selectedValue = 'Turkey';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(50, 3, 50, 5),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.orange),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton<String>(
          isExpanded: true,
          value: selectedValue,
          items: countryToAlpha2.keys
              .toList()
              .map((value) =>
                  DropdownMenuItem<String>(value: value, child: Text(value)))
              .toList(),
          onChanged: (value) {
            widget.onSelected(value, countryToAlpha2[value]);
            selectedValue = value!;
            setState(() {});
          }),
    );
  }
}
