import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:aero_flights/pages/favorites_page.dart';

class FlightsPage extends StatefulWidget {
  FlightsPage({Key? key}) : super(key: key);

  @override
  _FlightsPageState createState() => _FlightsPageState();
}

class _FlightsPageState extends State<FlightsPage> {
  List<Map<String, dynamic>> _favoriteFlights = [];
  List<Map<String, dynamic>> _flights = [];
  Map<String, dynamic>? _selectedFlight;


  @override
  void initState() {
    super.initState();
    fetchFlightData();
  }

  Future<void> fetchFlightData() async {
    final apiKey = 'f8f4e34c1f6fba91e910e330b28ce41e';
    final apiUrl = 'http://api.aviationstack.com/v1/flights';

    final requestUrl = Uri.parse('$apiUrl?access_key=$apiKey');

    try {
      final response = await http.get(requestUrl);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic>? flightsData = responseData['data'];

        if (flightsData != null) {
          setState(() {
            _flights = flightsData
                .map((flight) => {
              'id': flight['flight']['number'],
              'airline': flight['airline']['name'],
              'departure': flight['departure']['airport'],
              'destination': flight['arrival']['airport'],
              'price': '199.99', // Placeholder value for price
              'status': flight['status'],
              'time': flight['departure']['estimated'],
            })
                .toList();
          });
        } else {
          print('No flight data available.');
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Request error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          'Flights',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: _selectedFlight != null
          ? FlightDetailsPage(flight: _selectedFlight!)
          : _flights.isEmpty
          ? Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: _flights.length,
        itemBuilder: (context, index) {
          final flight = _flights[index];
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FlightDetailsPage(
                      flight: flight,
                    ),
                  ),
                );
              },
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
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Price: \$${flight['price']}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      FlightDetailsPage(
                                        flight: flight,
                                      ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Colors.teal),
                            child: Text('Details'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FavoritesPage(
                                    favoriteFlights: _favoriteFlights,
                                  ),
                                ),
                              );

                              setState(() {
                                _favoriteFlights.add(flight);
                              });
                            },

                            style: ElevatedButton.styleFrom(
                                primary: Colors.teal),
                            child: Text('save'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class FlightDetailsPage extends StatelessWidget {
  final Map<String, dynamic> flight;

  const FlightDetailsPage({Key? key, required this.flight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal, // Set background color
        title: Text(
          'Flight Details',
          style: TextStyle(
            color: Colors.white, // Set text color
          ),
        ),
      ),
      backgroundColor: Colors.grey[100], // Set background color
      body: _buildFlightDetails(context),
    );
  }

  Widget _buildFlightDetails(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center the content vertically
        children: [
          Image.asset(
            'images/flight.png', // Provide the path to your flight image
            width: MediaQuery.of(context).size.width * 0.6, // Take 80% of the screen width
          ),
          SizedBox(height: 16),
          Text(
            '${flight['airline']} - ${flight['id']}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Departure: ${flight['departure'] ?? 'Unknown'}',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            'Destination: ${flight['destination'] ?? 'Unknown'}',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            'Time: ${flight['time'] ?? 'Unknown'}',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            'Price: \$${flight['price'] ?? 'Unknown'}',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Go back to the previous route
            },
            style: ElevatedButton.styleFrom(primary: Colors.teal), // Set button color
            child: Text('Back to Flights'),
          ),
        ],
      ),
    );
  }
}







