// ignore_for_file: prefer_const_constructors
import 'package:aero_flights/read%20data/get_user_name.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:aero_flights/pages/register_page.dart';
import 'package:aero_flights/pages/flights_page.dart';
import 'package:aero_flights/pages/map_page.dart';

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
      body: Center(
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
              ),
            );
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: flights_page,
            child: Icon(Icons.flight),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MapPage()),
              );
            },
            child: Icon(Icons.map),
          ),
        ],
      ),
    );
  }
}
