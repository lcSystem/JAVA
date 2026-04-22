import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class SearchableCityField extends StatefulWidget {
  final String? initialValue;
  final Function(String) onSelected;
  final String labelText;

  const SearchableCityField({
    super.key,
    this.initialValue,
    required this.onSelected,
    this.labelText = 'Ciudad',
  });

  @override
  State<SearchableCityField> createState() => _SearchableCityFieldState();
}

class _SearchableCityFieldState extends State<SearchableCityField> {
  List<String> _cities = [];
  bool _isLoading = true;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _loadCities();
  }

  Future<void> _loadCities() async {
    try {
      final String response = await rootBundle.loadString('maps/colombia_cities.json');
      final data = json.decode(response) as List;
      setState(() {
        _cities = data.map((item) => "${item['nom_mpio']} - ${item['dpto']}").toList();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading cities: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: LinearProgressIndicator(),
      );
    }

    return Autocomplete<String>(
      initialValue: TextEditingValue(text: widget.initialValue ?? ''),
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        return _cities.where((String option) {
          return option.toUpperCase().contains(textEditingValue.text.toUpperCase());
        });
      },
      onSelected: (String selection) {
        widget.onSelected(selection);
      },
      fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
        // We sync the external initial value if it changes, but usually Autocomplete handles it.
        return TextFormField(
          controller: textEditingController,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: widget.labelText,
            prefixIcon: const Icon(Icons.location_city),
            border: const OutlineInputBorder(),
          ),
          onFieldSubmitted: (value) => onFieldSubmitted(),
        );
      },
    );
  }
}
