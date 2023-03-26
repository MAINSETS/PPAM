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
    hobby = ' ';
    drink = ' ';
    food = ' ';
    movie = ' ';
    game = ' ';
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
    return MaterialApp(
      title: 'Profile',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Center(
            child: const Text('Profile'),
          ),
        ),
        body: ListView(
          children: <Widget>[
            Container(
              height: 250,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red, Colors.deepOrange.shade300],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: [0.5, 0.9],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.red.shade300,
                        minRadius: 35.0,
                        child: Icon(
                          Icons.call,
                          size: 30.0,
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.white70,
                        minRadius: 60.0,
                        child: CircleAvatar(
                          radius: 50.0,
                          backgroundImage: NetworkImage(
                              'https://sportshub.cbsistatic.com/i/2022/11/13/2c7984b1-b8e3-44f1-84a3-85218a3743c0/suzume-no-tojimari-makoto-shinkai-anime-movie-poster.jpg'),
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.red.shade300,
                        minRadius: 35.0,
                        child: Icon(
                          Icons.message,
                          size: 30.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Email: ${_auth.currentUser!.email}',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Hello',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Divider(),
                  ListTile(
                    title: Text(
                      'What I Like: ',
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      child: gethobby(),
                    ),
                  ),
                  Divider(),
                  Center(
                    child: ElevatedButton(
                      onPressed: _logout,
                      child: Text('Logout'),
                    ),
                  ),
                ],
              ),
            )
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
