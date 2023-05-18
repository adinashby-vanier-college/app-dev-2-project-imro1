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
  List<Map<String, dynamic>> _favoriteFlights = [];

  // document IDs
  List<String> docIDs = [];

  // get docIDS
  Future<void> getDocId() async {
    final snapshot = await FirebaseFirestore.instance.collection('user').get();
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
      MaterialPageRoute(builder: (context) => FavoritesPage(favoriteFlights: _favoriteFlights)),
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
        backgroundColor: Colors.teal,
        title: Text("${user.email!}"),
        actions: [
          GestureDetector(
            onTap: () {
              FirebaseAuth.instance.signOut();
            },
            child: Icon(Icons.logout),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              // show a confirmation dialog
              bool confirmDelete = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Delete Account?"),
                  content: Text("Are you sure you want to delete your account? This action cannot be undone."),
                  actions: [
                    TextButton(
                      child: Text("CANCEL"),
                      onPressed: () => Navigator.pop(context, false),
                    ),
                    TextButton(
                      child: Text("DELETE"),
                      onPressed: () => Navigator.pop(context, true),
                    ),
                  ],
                ),
              );

              // if user confirms deletion, delete account from database and sign out
              if (confirmDelete == true) {
                try {
                  // delete user document from Firestore
                  await FirebaseFirestore.instance.collection('user').doc(user.uid).delete();
                  // delete user account from Firebase Auth
                  await FirebaseAuth.instance.currentUser!.delete();
                  // sign out user
                  await FirebaseAuth.instance.signOut();
                } catch (e) {
                  print("Error deleting user account: $e");
                  // show an error message
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Error deleting user account. Please try again."),
                  ));
                }
              }
            },
          )

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
              backgroundColor: Colors.teal,
              mini: false,
              heroTag: null,
            ),
            Spacer(),
            FloatingActionButton(
              onPressed: favorites_page,
              child: Icon(Icons.favorite),
              backgroundColor: Colors.teal,
              mini: false,
              heroTag: null,
            ),
            Spacer(),
            FloatingActionButton(
              onPressed: search_page,
              child: Icon(Icons.search),
              backgroundColor: Colors.teal,
              mini: false,
              heroTag: null,
            ),
            Spacer(),
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapPage()),
                );
              },
              child: Icon(Icons.map),
              backgroundColor: Colors.teal,
              mini: false,
              heroTag: null,
            ),
          ],
        ),
      ),
    );
  }
}
