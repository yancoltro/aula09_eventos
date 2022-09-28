import 'package:aula09_eventos/commom/authentication.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';
import 'evento_screen.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({Key? key}) : super(key: key);

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  late MaterialPageRoute route;

  void forceLoad() async {
    await Future.delayed(Duration(seconds: 3));
    Authetication auth = Authetication();
    auth.getUser().then((user) {
      if (user != null) {
        route = MaterialPageRoute(builder: (context) => EventoScreen(user.uid));
      } else {
        route = MaterialPageRoute(builder: (context) => LoginScreen());
      }
      Navigator.pushReplacement(context, route);
    }).catchError((error) => print(error));
  }

  @override
  void initState() {
    forceLoad();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eventos'),
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
