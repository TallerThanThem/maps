import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps/constants/home_page_sizedbox_constant.dart';
import 'package:maps/constants/home_page_text_constants.dart';
import 'package:maps/constants/icon_constant.dart';
import 'package:maps/constants/map_button_sizedbox_constant.dart';
import 'package:maps/pages/firebase/user_add.dart';
import 'package:maps/pages/map_page.dart';
import 'package:maps/widgets/my_raised_button.dart';

class HomePageBodyWidget extends StatefulWidget {
  @override
  _HomePageBodyWidgetState createState() => _HomePageBodyWidgetState();
}

class _HomePageBodyWidgetState extends State<HomePageBodyWidget> {
  final firestoreInstance = FirebaseFirestore.instance;

  String fullName = 'Eren';

  String company = 'RON';

  int age = 20;

  late double newLatitude;

  late double newLongitude;

  var _center;

  void onPressedGetLocation() {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    firestoreInstance
        .collection("Users")
        .doc(firebaseUser!.uid)
        .get()
        .then((value) {
      newLatitude = value.data()!["latitude"];
      newLongitude = value.data()!["longitude"];
      setState(() {
        _center = LatLng(newLatitude, newLongitude);
      });
    });
    print(_center);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          kHomeIcon,
          SizedBox(
            height: HomeKHeight,
          ),
          Text(
            'Get User Location',
            style: kHomeTextStyle,
          ),
          SizedBox(
            height: HomeKHeight,
          ),
          SizedBox(
            height: HomeKHeight,
          ),
          FlatButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => MapPage(),
                ),
              );
            },
            color: Color.fromRGBO(4, 122, 24, 0.2),
            splashColor: Colors.green,
            child: Text('Open Google Map'),
          ),
          MyRaisedButton(
            color: Colors.green,
            onPressed: () {
              onPressedGetLocation();
            },
            child: Text('Firebase'),
          ),
          SizedBox(height: kHeight,),
          Text('$_center'),
        ],
      ),
    );
  }
}
