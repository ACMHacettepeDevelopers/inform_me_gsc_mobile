// country_picker.dart

import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';

class CountryPicker extends StatefulWidget {
  final void Function(String) onCountryChanged;

  const CountryPicker({Key? key, required this.onCountryChanged}) : super(key: key);

  @override
  State<CountryPicker> createState() => _CountryPickerState();
}

class _CountryPickerState extends State<CountryPicker> {
  String countryValue = "";

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
          flagState: CountryFlag.ENABLE,
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
              print("Selected Country: $countryValue"); // Print selected country
            });
            widget.onCountryChanged(countryValue); // Call the callback function
          },
        ),
      ),
    );
  }
}
