import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maps/pages/firebase/user_get.dart';

class AddUser extends StatelessWidget {
  final String fullName;
  final String company;
  final int age;

  AddUser(this.fullName, this.company, this.age);
  final firestoreInstance = FirebaseFirestore.instance;

  void _onPressed() {
    var firebaseUser =  FirebaseAuth.instance.currentUser;
    firestoreInstance.collection("Users").doc(firebaseUser!.uid).set(
        {
          "username" : "userX",
        },SetOptions(merge: true)).then((_){
      print("success!");
    });
  }

  @override
  Widget build(BuildContext context) {
    // Create a CollectionReference called users that references the firestore collection
    CollectionReference users = FirebaseFirestore.instance.collection('Users');




    Future<void> addUser() {
      // Call the user's CollectionReference to add a new user
      return users
          .add({
            'full_name': fullName, // John Doe
            'company': company, // Stokes and Sons
            'age': age // 42
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Add User'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.local_fire_department),
          ),
        ],
      ),
      body: Column(
        children: [
          Center(
            child: Container(
              child: TextButton(
                onPressed: _onPressed,
                child: Text('Add User to Firebase'),
              ),
            ),
          ),
          Center(
            child: Container(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          GetUserName("q5nCQqhrzksunIgbWbRT"),
                    ),
                  );
                },
                child: Text('Get User Firebase'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
