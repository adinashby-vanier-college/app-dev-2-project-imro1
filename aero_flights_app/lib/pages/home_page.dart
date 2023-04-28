// ignore_for_file: prefer_const_constructors
import 'package:aero_flights/read%20data/get_user_name.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:aero_flights/pages/register_page.dart';
import 'package:aero_flights/pages/flights_page.dart';
import 'package:aero_flights/pages/map_page.dart';
import 'package:aero_flights/pages/favorites_page.dart';
import 'package:aero_flights/pages/search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  // document IDs
  List<String> docIDs = [];

  // get docIDS
  Future<void> getDocId() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();
    setState(() {
      docIDs = snapshot.docs.map((document) => document.reference.id).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    getDocId();
  }

  void flights_page() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FlightsPage()),
    );
  }

  void favorites_page() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FavoritesPage()),
    );
  }

  void search_page() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${user.email!}'s profile"),
        actions: [
          GestureDetector(
            onTap: () {
              FirebaseAuth.instance.signOut();
            },
            child: Icon(Icons.logout),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://wallpaperaccess.com/full/6800802.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: docIDs.isEmpty
              ? CircularProgressIndicator()
              : ListView.builder(
                  itemCount: docIDs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListTile(
                        title: GetUserName(documentId: docIDs[index]),
                        tileColor: Colors.lightBlueAccent,
                        minLeadingWidth: 10
                      ),
                    );
                  },
                ),
        ),
      ),
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              onPressed: flights_page,
              child: Icon(Icons.flight),
              backgroundColor: Colors.blue,
              mini: false,
              heroTag: null,
            ),
            FloatingActionButton(
              onPressed: favorites_page,
              child: Icon(Icons.favorite),
              backgroundColor: Colors.blue,
              mini: false,
              heroTag: null,
            ),
            FloatingActionButton(
              onPressed: search_page,
              child: Icon(Icons.search),
              backgroundColor: Colors.blue,
              mini: false,
              heroTag: null,
            ),
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapPage()),
                );
              },
              child: Icon(Icons.map),
              backgroundColor: Colors.blue,
              mini: false,
              heroTag: null,
            ),
          ],
        ),
      ),
    );
  }
}
