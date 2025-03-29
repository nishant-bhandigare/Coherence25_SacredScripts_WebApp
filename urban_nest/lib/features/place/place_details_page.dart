import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:urban_nest/features/place/place_data.dart';
import 'package:urban_nest/features/place/place_data_model.dart';

class PlaceDetailsPage extends StatelessWidget {
  final int index;

  const PlaceDetailsPage({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final place = places[index]; // Retrieve place data using index

    return Scaffold(
      appBar: AppBar(title: Text(place.name, style: TextStyle(fontSize: 18),), centerTitle: true,),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PlaceCarousel(place: places[index],),
            SizedBox(height: 20),
            Text(
              place.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              place.category,
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            Text(
              "Rating: ⭐ ${place.rating}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              place.description,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              "Location: ${place.location}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Spacer(),
            Container(
              height: 90,
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(20)
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Just Checked-in"),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                child: Image.asset("assets/images/user.png"),
                              ),
                              SizedBox(width: 10),
                              CircleAvatar(
                                radius: 18,
                                child: Image.asset("assets/images/user.png"),
                              ),
                              SizedBox(width: 10),
                              CircleAvatar(
                                radius: 18,
                                child: Text("+7"),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(80)
                      ),
                      child: Center(
                        child: Text("Book a ticket"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlaceCarousel extends StatelessWidget {
  final Place place;

  const PlaceCarousel({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 300,
            enlargeCenterPage: true,
            autoPlay: true,
            viewportFraction: 0.8,
          ),
          items: place.imageUrls.map((imageUrl) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(imageUrl, fit: BoxFit.cover),
                  _buildGradientOverlay(),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildGradientOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.black.withOpacity(0.5), Colors.transparent],
        ),
      ),
    );
  }
}
