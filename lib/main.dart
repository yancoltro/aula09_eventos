import 'package:aula09_eventos/screens/evento_screen.dart';
import 'package:aula09_eventos/screens/launch_screen.dart';
import 'package:aula09_eventos/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future testDb() async {
  FirebaseFirestore db = FirebaseFirestore.instance;

  await db.collection('eventos').get().then((evento) {
    for(var doc in evento.docs){
      print("${doc.id} => ${doc.data()}");
    }
  });

}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(AppEventos());
}

class AppEventos extends StatelessWidget {
  const AppEventos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // testDb();
    return MaterialApp(
        title: "App Eventos",
        // home: EventoScreen()
        home: LaunchScreen()
    );
  }
}
