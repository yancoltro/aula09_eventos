import 'package:cloud_firestore/cloud_firestore.dart';

class Favorito {
  late String? _id;
  late String _eventoId;
  late String _userId;

  Favorito(
    this._id,
    this._eventoId,
    this._userId,
  );

  Favorito.map(DocumentSnapshot document) {
    var data = document.data();
    this._id = document.id;
    this._eventoId = document['eventId'];
    this._userId = document['userId'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      // 'id': this._id,
      'eventId': this._eventoId,
      'userId': this._userId,
    };

    return map;
  }

  String? get id => this._id;

  set id(String? value) => this._id = value;

  get eventoId => this._eventoId;

  set eventoId(value) => this._eventoId = value;

  get iserId => this._userId;

  set iserId(value) => this._userId = value;
}
