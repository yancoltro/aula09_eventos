import 'package:aula09_eventos/commom/authentication.dart';
import 'package:aula09_eventos/components/evento_list.dart';
import 'package:aula09_eventos/screens/login_screen.dart';
import 'package:flutter/material.dart';

class EventoScreen extends StatelessWidget {
  // const EventoScreen({Key? key}) : super(key: key);

  final Authetication auth = Authetication();
  late String uid = "";
  EventoScreen(this.uid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eventos'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              auth.signOut().then((value) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              });
            },
          )
        ],
      ),
      body: EventoList(uid),
    );
  }
}
