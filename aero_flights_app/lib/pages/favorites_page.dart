import 'package:flutter/material.dart';
import 'package:aero_flights/pages/home_page.dart';

class FavoritesPage extends StatelessWidget {
  FavoritesPage({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> _flights = [
    {
      'id': '1',
      'airline': 'Delta',
      'departure': 'New York',
      'destination': 'Los Angeles',
      'price': '250',
      'time': '8:00 AM',
    },
    {
      'id': '2',
      'airline': 'United',
      'departure': 'Los Angeles',
      'destination': 'Chicago',
      'price': '350',
      'time': '10:00 AM',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: ListView.builder(
        itemCount: _flights.length,
        itemBuilder: (context, index) {
          final flight = _flights[index];
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              child: ListTile(
                title: Text('${flight['airline']} - ${flight['id']}'),
                subtitle: Text(
                  '${flight['departure']} to ${flight['destination']} at ${flight['time']}',
                ),
                trailing: Text('\$${flight['price']}'),
              ),
            ),
          );
        },
      ),
    );
  }
}
