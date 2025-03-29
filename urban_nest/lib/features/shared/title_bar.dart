import 'package:flutter/material.dart';

class TitleBar extends StatelessWidget{
  const TitleBar({super.key, required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        if (subtitle != "")
          Text(
            subtitle,
            style: TextStyle(fontSize: 10, color: Colors.grey),
          ),
        const SizedBox(height: 10),
      ],
    );
  }
}