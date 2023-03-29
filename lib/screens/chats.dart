//buatlah halaman yang berisi tombol untuk ke halaman lain

import 'package:chat_app/screens/anime.dart';
import 'package:chat_app/screens/drakor.dart';
import 'package:chat_app/screens/home.dart';
import 'package:chat_app/screens/sports.dart';
import 'package:flutter/material.dart';

class Chats extends StatelessWidget {
  const Chats({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ));
            }),
      ),
      body: Container(
        child: Column(
          children: [
            Center(
              child: ElevatedButton(
                child: Text('Sports'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ChatScreen2();
                  }));
                },
              ),
            ),
            Divider(),
            Center(
              child: ElevatedButton(
                child: Text('Anime'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ChatScreen3();
                  }));
                },
              ),
            ),
            Divider(),
            Center(
              child: ElevatedButton(
                child: Text('Korean Drama'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ChatScreen4();
                  }));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
