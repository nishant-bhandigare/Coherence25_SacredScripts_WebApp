import 'package:flutter/material.dart';

class SearchBarElement extends StatelessWidget {
  final ThemeData themeData;
  final String hintText;
  final ValueChanged<String>? onChanged;

  const SearchBarElement({
    super.key,
    required this.themeData,
    this.hintText = 'Search name or symbol',
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        filled: true,
        fillColor: themeData.brightness == Brightness.dark
            ? Colors.white12
            : Colors.teal.withOpacity(0.1),
        prefixIcon: Icon(Icons.search, color: themeData.colorScheme.onSurface),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: onChanged,
    );
  }
}
