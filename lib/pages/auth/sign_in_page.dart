import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maps/pages/auth/email_sign_in_page.dart';
import 'package:maps/pages/home_page.dart';
import 'package:maps/services/auth.dart';
import 'package:maps/widgets/my_raised_button.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _isLoading = false;
  final firestoreInstance = FirebaseFirestore.instance;


  // void _onPressed() {
  //   firestoreInstance.collection("users").add({
  //     "username": "eren",
  //     "email": "erenkara@hotmail.com",
  //     "password": 12345,
  //     "latitude": 40.2192579,
  //     "longitude": 28.9516985,
  //   });
  // }

  void _onPressed() {
    firestoreInstance.collection("Users").doc().get().then((value){
      print(value.data());
    });
  }

  Future<void> _signInAnonymously() async {
    setState(() {
      _isLoading = true;
    });
    final user =
    await Provider.of<Auth>(context, listen: false).signInAnonymously();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sign In Page',
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(
              height: 30,
            ),
            MyRaisedButton(
              color: Colors.orangeAccent,
              child: Text('Sign In Anonymously'),
              onPressed: _isLoading
                  ? null
                  : () async {
                await _signInAnonymously();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => HomePage(),
                  ),
                );
              },
            ),
            SizedBox(
              height: 10,
            ),
            MyRaisedButton(
              color: Colors.yellow,
              child: Text('Sign In Email/Password'),
              onPressed: _isLoading
                  ? null
                  : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EmailSignInPage(),
                  ),
                );
              },
            ),
            SizedBox(height: 10,),
            MyRaisedButton(color: Colors.green, onPressed: _onPressed, child: Text('Collection'),),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}