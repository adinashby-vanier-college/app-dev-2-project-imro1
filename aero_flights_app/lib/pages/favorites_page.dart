import 'package:flutter/material.dart';
import 'package:aero_flights/pages/home_page.dart';

class FavoritesPage extends StatelessWidget {
  final List<Map<String, dynamic>> favoriteFlights;

  const FavoritesPage({Key? key, required this.favoriteFlights})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          'Favorites',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: favoriteFlights.isEmpty
          ? Center(
        child: Text('No favorite flights.'),
      )
          : ListView.builder(
        itemCount: favoriteFlights.length,
        itemBuilder: (context, index) {
          final flight = favoriteFlights[index];
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${flight['airline']} - ${flight['id']}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${flight['departure']} to ${flight['destination']}',
                      style: TextStyle(fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Price: \$${flight['price']}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
