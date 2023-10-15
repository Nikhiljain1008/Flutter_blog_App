import 'package:blogg_flutter/blog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class display extends StatefulWidget {
  const display({super.key});

  @override
  State<display> createState() => _displayState();
}

class _displayState extends State<display> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('saved blogs'),
        ),
        body: StreamBuilder<List<User>>(
            stream: readUsers(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('something went wrong ${snapshot.error}');
              }
              if (snapshot.hasData) {
                final users = snapshot.data!;
                return ListView(
                  children:
                      users.map((user) => buildUser(context, user)).toList(),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }));
  }
}

Widget buildUser(BuildContext context, User user) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(
          user.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlogScreen(user: user),
            ),
          );
        },
      ),
    );

Stream<List<User>> readUsers() =>
    FirebaseFirestore.instance.collection('users').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => User.fromJson(doc.data())).toList());

class User {
  String id;
  final String name;
  final String blog;

  User({this.id = '', required this.name, required this.blog});

  static User fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        name: json['name'],
        blog: json['blog'],
      );
}

class BlogScreen extends StatelessWidget {
  final User user;

  BlogScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Blog'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name of blog:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                user.name,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Blog:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                user.blog,
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
