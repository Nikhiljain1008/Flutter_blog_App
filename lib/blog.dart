import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class writeblog extends StatefulWidget {
  const writeblog({super.key});

  @override
  State<writeblog> createState() => _writeblogState();
}

class _writeblogState extends State<writeblog> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _textController1 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('write a new BLOG'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _textController,
              maxLines: null,
              decoration: InputDecoration(
                labelText: 'name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _textController1,
              maxLines: null,
              decoration: InputDecoration(
                labelText: 'blog',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final user = User(
                    name: _textController.text, blog: _textController1.text);
                createUser(user);
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

Future createUser(User user) async {
  final docUser = FirebaseFirestore.instance.collection('users').doc();
  user.id = docUser.id;

  final json = user.toJson();
  await docUser.set(json);
}

class User {
  String id;
  final String name;
  final String blog;

  User({this.id = '', required this.name, required this.blog});

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'blog': blog,
      };

  //static fromJson(Map<String, dynamic> data) {}
}
