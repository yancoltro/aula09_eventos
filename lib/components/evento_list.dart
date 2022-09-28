// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:aula09_eventos/helpers/firestore_helper.dart';
import 'package:aula09_eventos/models/evento.dart';
import 'package:aula09_eventos/models/favorito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

class EventoList extends StatefulWidget {

  late final String userUid;
  EventoList(this.userUid);

  @override
  State<EventoList> createState() => _EventoListState();
}

class _EventoListState extends State<EventoList> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  List<Evento> eventos = [];
  List<Favorito> favoritos = [];


  Future<List<Evento>> getEventos() async {
    List<Evento> _eventosList = [];
    await db.collection('eventos').get().then((_eventos) {
      _eventos.docs.forEach((_evento) {
        _eventosList.add(Evento.fromJson(_evento.id, _evento.data()));
      });
    });
    return _eventosList;
  }

  @override
  void initState() {
    getEventos().then((data) {
      setState(() {
        eventos = data;
      });
    });
    FirestoreHelper.getFavoritos(widget.userUid).then((data){
      setState(() {
        favoritos = data;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: eventos.length,
      itemBuilder: (context, index) {
        return Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          elevation: 2,
          margin: EdgeInsets.all(12.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ExpansionTile(
              backgroundColor: Colors.white,
              title: ListTile(
                title: Text(eventos[index].nome),
                subtitle: Text(eventos[index].descricao),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.star,
                  color: (ehFavorito(eventos[index].id!)) ? Colors.amber : Colors.grey,
                ),
                onPressed: () {
                  addicionaFavorito(eventos[index]);
                },
              ),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                        child: Icon(Icons.person),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: Text(eventos[index].ministrante),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                              child: Icon(Icons.date_range)),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                            child: Text(DateFormat('dd/MM/yyyy')
                                .format(eventos[index].data)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                            child: Icon(Icons.alarm_on),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                            child: Text(eventos[index].inicio.hour.toString() +
                                ":" +
                                eventos[index].inicio.minute.toString()),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(75, 0, 8, 0),
                            child: Icon(Icons.alarm_off),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                            child: Text(eventos[index].fim.hour.toString() +
                                ":" +
                                eventos[index].fim.minute.toString()),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void addicionaFavorito(Evento evento) async{
    if(ehFavorito(evento.id!)){
      Favorito? favoritoToDelete = favoritos.firstWhereIndexedOrNull((index, Favorito f) => (f.eventoId == evento.id!));
      await FirestoreHelper.delFavorito(favoritoToDelete!.id!);
    }else{
      await FirestoreHelper.addFavorito(evento, widget.userUid);  
    }

    List<Favorito> favoritosAtualizado = await FirestoreHelper.getFavoritos(widget.userUid);
    setState(() {
      favoritos = favoritosAtualizado;
    });
  }

  bool ehFavorito(String eventId){
    Favorito? favorito = favoritos.firstWhereIndexedOrNull((index, Favorito f) => (f.eventoId == eventId));
    return favorito == null ? false : true;
  }
}
