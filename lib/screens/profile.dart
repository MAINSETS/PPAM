import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/screens/login_screen.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Stream<QuerySnapshot> _firestore =
      FirebaseFirestore.instance.collection('users').snapshots();

  late String email;
  late String hobby;
  late String drink;
  late String food;
  late String movie;
  late String game;

  Future<void> getUserData() async {
    final User? user = _auth.currentUser;
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> _logout() async {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Email: ${_auth.currentUser!.email}',
              style: TextStyle(fontSize: 20.0),
            ),
            Center(child: gethobby()),
            Center(
              child: ElevatedButton(
                onPressed: _logout,
                child: Text('Logout'),
              ),
            ),
            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }

  Widget gethobby() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore,
      builder: (context, querySnapshot) {
        if (querySnapshot != null) {
          final List<DocumentSnapshot> documents = querySnapshot.data!.docs;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: documents.length,
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Hobby: ${documents[index]['hobby']}',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  Text(
                    'Drink: ${documents[index]['drink']}',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  Text(
                    'Food: ${documents[index]['food']}',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  Text(
                    'Movies: ${documents[index]['movie']}',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  Text(
                    'Games: ${documents[index]['game']}',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ],
              );
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
