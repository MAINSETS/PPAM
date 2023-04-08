import 'dart:io';
import 'package:chat_app/screens/password.dart';
import 'package:chat_app/screens/questionaire.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Stream<QuerySnapshot> _firestore =
      FirebaseFirestore.instance.collection('users').snapshots();
  File? _image;
  String _imageUrl = '';

  late String email;
  late String hobby;
  late String drink;
  late String food;
  late String movie;
  late String game;

  Future<void> _getImageAndUpload() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      final User? user = _auth.currentUser;
      final String fileName = user!.uid + '.png';
      final Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child(fileName);
      final UploadTask uploadTask = firebaseStorageRef.putFile(_image!);
      await uploadTask.whenComplete(() async {
        print('File Uploaded');
        _imageUrl = await firebaseStorageRef.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .update({'profile_picture': _imageUrl});
        setState(() {});
      });
    } else {
      print('No image selected.');
    }
  }

  Future<void> getUserData() async {
    final User? user = _auth.currentUser;
    final DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();
    hobby = snapshot.get('hobby') ?? '';
    drink = snapshot.get('drink') ?? '';
    food = snapshot.get('food') ?? '';
    movie = snapshot.get('movie') ?? '';
    game = snapshot.get('game') ?? '';
  }

  @override
  void initState() {
    super.initState();
    getUserData();
    FirebaseStorage.instance
        .ref()
        .child('${_auth.currentUser!.uid}.png')
        .getDownloadURL()
        .then((url) {
      setState(() {
        _imageUrl = url;
      });
    });
  }

  Future<void> _logout() async {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  Future<void> _question() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Questionaire()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;
    final String fileName = user!.uid + '.png';
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          leading: null,
          backgroundColor: Colors.red,
          title: const Text('Profile'),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
          centerTitle: true,
          automaticallyImplyLeading: false),
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
                    GestureDetector(
                      onTap: _getImageAndUpload,
                      child: CircleAvatar(
                        backgroundColor: Colors.white70,
                        minRadius: 60.0,
                        backgroundImage: _imageUrl.isNotEmpty
                            ? NetworkImage(_imageUrl)
                            : null,
                      ),
                    ),
                  ],
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
                    onPressed: _question,
                    child: Text("Questionaire"),
                  ),
                ),
                Divider(),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PasswordReset()),
                      );
                    },
                    child: Text("Change Password"),
                  ),
                ),
                Divider(),
                Center(
                  child: ElevatedButton(
                    onPressed: _logout,
                    child: Text("Logout"),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget gethobby() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore,
      builder: (context, querySnapshot) {
        if (querySnapshot != null) {
          final List<DocumentSnapshot> documents = querySnapshot.data!.docs;
          DocumentSnapshot? userData;
          for (var doc in documents) {
            if (doc.id == _auth.currentUser!.email) {
              userData = doc;
              break;
            }
          }
          if (userData == null) {
            return Text('Please answer the questionaire');
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: 1,
            itemBuilder: (context, index) {
              DocumentSnapshot document = documents[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Hobby: ${userData!['hobby'] ?? ''}',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  Text(
                    'Drink: ${userData!['drink'] ?? ''}',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  Text(
                    'Food: ${userData!['food'] ?? ''}',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  Text(
                    'Movies: ${userData!['movie'] ?? ''}',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  Text(
                    'Games: ${userData!['game'] ?? ''}',
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
