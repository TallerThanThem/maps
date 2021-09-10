import 'package:flutter/material.dart';
import 'package:maps/pages/auth/sign_in_page.dart';
import 'package:maps/services/auth.dart';
import 'package:maps/widgets/home_page_body_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Auth _auth = Auth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Map Example'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await _auth.signOut();
              Navigator.pop(context);
            },
            icon: Icon(Icons.close),
          ),
        ],
      ),
      body: HomePageBodyWidget(),
    );
  }
}
