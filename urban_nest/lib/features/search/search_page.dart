import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_nest/features/maps/map_widget.dart';
import 'package:urban_nest/features/place/place_data.dart';
import 'package:urban_nest/features/place/place_details_page.dart';
import 'dart:ui';

import 'package:urban_nest/features/shared/search_bar.dart';
import 'package:urban_nest/features/shared/title_bar.dart';
import 'package:urban_nest/theme_notifier.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Provider.of<ThemeNotifier>(context).getTheme();

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchBarElement(themeData: themeData),
              const SizedBox(height: 20),
              TitleBar(title: "City Center", subtitle: ""),
              Container(
                alignment:
                    Alignment.topCenter, // Ensures the grid starts at the top
                child: GridView.count(
                  padding: EdgeInsets.zero, // Removes extra padding
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    CategoryCard(
                      title: "Vasai Transport",
                      subtitle: "See transportation route\nand station",
                      color: Colors.teal,
                      icon: Icons.directions_bus,
                    ),
                    CategoryCard(
                      title: "Vasai Info",
                      subtitle: "See updated information\nfrom government",
                      color: Colors.orange,
                      icon: Icons.error_outline,
                    ),
                    CategoryCard(
                      title: "Vasai Health",
                      subtitle: "See public health center\nand services",
                      color: Colors.purpleAccent.shade100,
                      icon: Icons.local_hospital,
                    ),
                    CategoryCard(
                      title: "Vasai Connect",
                      subtitle:
                          "Connect and get services\nfrom all departments",
                      color: Colors.red,
                      icon: Icons.account_balance,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TitleBar(title: "Nearby", subtitle: "Popular Choices"),
              MapWidget(),
              const SizedBox(height: 20),
              TitleBar(title: "Popular", subtitle: "Choice Places"),
              SizedBox(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: places.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                        right: index == places.length - 1 ? 0 : 16,
                      ),
                      child: PlaceCard(index: index),
                    );
                  },
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}

class PlaceCard extends StatelessWidget {
  final int index;

  const PlaceCard({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlaceDetailsPage(index: index),
          ),
        );
      },
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage(places[index].imageUrls[0]),
            fit: BoxFit.cover,
          ),
        ),
        alignment: Alignment.bottomLeft,
        padding: const EdgeInsets.all(10),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    places[index].name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    places[index].category,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;

  const CategoryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(icon, size: 20),
          ),
          Spacer(),
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(subtitle, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
