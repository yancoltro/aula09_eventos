import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class Evento {
  String? id;
  late String nome;
  late String descricao;
  late DateTime data;
  late TimeOfDay inicio;
  late TimeOfDay fim;
  late String ministrante;
  late bool favorito;

  Evento.fromJson(String? id, Map<String, dynamic> json) {
    this.id = id;
    this.nome = json['nome'];
    this.descricao = json['descricao'];
    this.data = DateFormat.yMd('en_US').parse(json['data']);
    this.inicio = TimeOfDay.fromDateTime(DateFormat('Hm', 'en_US').parse(json['inicio']));
    this.fim = TimeOfDay.fromDateTime(DateFormat('Hm', 'en_US').parse(json['fim']));
    this.ministrante = json['ministrante'];
    this.favorito = json['favorito'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id': this.id,
      'nome': this.nome,
      'descricao': this.descricao,
      'data': this.data,
      'inicio': this.inicio,
      'fim': this.fim,
      'ministrante': this.ministrante,
      'favorito': this.favorito,
    };

    return map;
  }

}
