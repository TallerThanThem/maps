import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps/pages/home_page.dart';
import 'package:maps/services/auth.dart';
import 'package:maps/widgets/text_form_widget.dart';
import 'package:provider/provider.dart';

enum FormStatus { signIn, register, reset }

class EmailSignInPage extends StatefulWidget {
  @override
  _EmailSignInPageState createState() => _EmailSignInPageState();
}

class _EmailSignInPageState extends State<EmailSignInPage> {
  FormStatus _formStatus = FormStatus.signIn;
  final firestoreInstance = FirebaseFirestore.instance;

  late double latitude;
  late double longitude;
  void getCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    var lati = position.latitude;
    var long = position.longitude;

    // passing this to latitude and longitude strings
    latitude = lati;
    longitude = long;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _formStatus == FormStatus.signIn
            ? buildSignInForm()
            : _formStatus == FormStatus.register
                ? buildRegisterForm()
                : buildResetForm(),
      ),
    );
  }

  Widget buildSignInForm() {
    final _signInFormKey = GlobalKey<FormState>();
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _signInFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'L??tfen Giri?? Yap??n??z',
              style: TextStyle(fontSize: 25),
            ),
            TextFormWidget(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              obscureText: false,
              validator: (value) {
                if (!EmailValidator.validate(value!)) {
                  return 'L??tfen ge??erli bir E-Mail giriniz';
                } else {
                  return null;
                }
              },
              hintText: 'E-Mail',
              prefixIcon: Icon(Icons.email),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormWidget(
              controller: _passwordController,
              obscureText: true,
              hintText: 'Parola',
              prefixIcon: Icon(Icons.lock),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Bu alan bo?? b??rak??lamaz';
                } else {
                  return null;
                }
              },
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                if (_signInFormKey.currentState!.validate()) {
                  final user = await Provider.of<Auth>(context, listen: false)
                      .signWithEmailAndPassword(
                          _emailController.text, _passwordController.text);

                  // if (!user!.emailVerified) {
                  //   await _showMyDialog();
                  //   await Provider.of<Auth>(context, listen: false).signOut();
                  // }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => HomePage(),
                    ),
                  );
                }
              },
              child: Text('Giri??'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _formStatus = FormStatus.register;
                });
              },
              child: Text('Yeni kay??t i??in t??klay??n??z'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _formStatus = FormStatus.reset;
                });
              },
              child: Text('??ifremi unuttum'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildResetForm() {
    final _resetFormKey = GlobalKey<FormState>();
    TextEditingController _emailController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _resetFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Parola Yenileme',
              style: TextStyle(fontSize: 25),
            ),
            TextFormWidget(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              obscureText: false,
              validator: (value) {
                if (!EmailValidator.validate(value!)) {
                  return 'L??tfen ge??erli bir E-Mail giriniz';
                } else {
                  return null;
                }
              },
              hintText: 'E-Mail',
              prefixIcon: Icon(Icons.email),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                if (_resetFormKey.currentState!.validate()) {
                  await Provider.of<Auth>(context, listen: false)
                      .sendPasswordResetEmail(_emailController.text);
                  await _showResetDialog();

                  Navigator.pop(context);
                }
              },
              child: Text('G??nder'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRegisterForm() {
    final _registerFormKey = GlobalKey<FormState>();
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    TextEditingController _passwordConfirmController = TextEditingController();

    void _onPressed(){
      var firebaseUser =  FirebaseAuth.instance.currentUser;
      firestoreInstance.collection("Users").doc(firebaseUser!.uid).set(
          {
            "email" : "${_emailController.text}",
            "password": _passwordController.text,
            "latitude": latitude,
            "longitude": longitude,
          }).then((_){
        print("success!");
      });
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _registerFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Kay??t Formu',
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormWidget(
              keyboardType: TextInputType.emailAddress,
              obscureText: false,
              validator: (value) {
                if (!EmailValidator.validate(value!)) {
                  return 'L??tfen ge??erli bir E-Mail giriniz';
                } else {
                  return null;
                }
              },
              controller: _emailController,
              hintText: 'E-Mail',
              prefixIcon: Icon(Icons.email),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormWidget(
              obscureText: true,
              validator: (value) {
                if (value!.length < 6) {
                  return 'L??tfen minimum 6 haneli bir parola giriniz';
                } else {
                  return null;
                }
              },
              controller: _passwordController,
              hintText: 'Parola',
              prefixIcon: Icon(Icons.lock),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormWidget(
              obscureText: true,
              validator: (value) {
                if (value != _passwordController.text) {
                  return 'Parolalar uyu??muyor';
                } else {
                  return null;
                }
              },
              controller: _passwordConfirmController,
              prefixIcon: Icon(Icons.lock),
              hintText: 'Parola Onay',
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  if (_registerFormKey.currentState!.validate()) {
                    final user = await Provider.of<Auth>(context, listen: false)
                        .createUserWithEmailAndPassword(
                      _emailController.text,
                      _passwordController.text,
                    );
                    _onPressed();
                    // if (!user!.emailVerified) {
                    //   await user.sendEmailVerification();
                    // }
                    await _showMyDialog();
                    setState(() {
                      _formStatus = FormStatus.signIn;
                    });
                  }
                } on FirebaseAuthException catch (e) {
                  _showErrorDialog('Email zaten kullan??l??yor.');
                }
              },
              child: Text('Kay??t'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _formStatus = FormStatus.signIn;
                });
              },
              child: Text('Zaten ??ye misiniz? T??klay??n??z'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ONAY GEREK??YOR'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Merhaba, l??tfen mailinizi kontrol ediniz.'),
                Text('Onay linkini t??klay??p tekrar giri?? yap??n??z.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ANLADIM'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showResetDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('PAROLA YEN??LEME'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Merhaba, l??tfen mailinizi kontrol ediniz.'),
                Text('Linki t??klayarak parolan??z?? yenileyiniz'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ANLADIM'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showErrorDialog(String errorText) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('B??R HATA OLU??TU'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(errorText),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
