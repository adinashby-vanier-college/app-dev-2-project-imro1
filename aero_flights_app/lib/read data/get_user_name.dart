import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:aero_flights/pages/register_page.dart';

class GetUserName extends StatelessWidget {
  final String documentId;

  GetUserName({required this.documentId});

  @override
  Widget build(BuildContext context) {
    //get the collection
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
          snapshot.data!.data() as Map<String, dynamic>;
          return Row(
            children: [
              Icon(
                Icons.person,
                size: 30,
                color: Colors.white,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'username: ' + ' ${data['username']}',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white, // set desired font size here
                ),
              ),
            ],
          );
        }
        return Text('loading..');
      }),
    );
  }
}
