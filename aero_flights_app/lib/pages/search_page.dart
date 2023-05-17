import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'flights_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Map<String, dynamic>> _flights = [];
  List<Map<String, dynamic>> _searchResults = [];

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

  void searchFlights(String query) {
    setState(() {
      _searchResults = _flights
          .where((flight) =>
      flight['airline']
          .toString()
          .toLowerCase()
          .contains(query.toLowerCase()) ||
          flight['departure']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()) ||
          flight['destination']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
        backgroundColor: Colors.teal,
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 10),
            TextFormField(
              onChanged: (value) => searchFlights(value),
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              style: TextStyle(color: Colors.teal),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Button action
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              child: Text(
                'Search',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: _searchResults.isEmpty
                    ? Center(
                  child: Text(
                    'No flights available',
                    style: TextStyle(fontSize: 16),
                  ),
                )
                    : Column(
                  children: _searchResults.map((flight) {
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
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
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
                                      child: Text('Save'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
