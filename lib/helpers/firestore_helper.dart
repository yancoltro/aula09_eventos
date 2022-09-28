import '../models/evento.dart';
import '../models/favorito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreHelper {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  static Future addFavorito(Evento evento, String uid) {
    Favorito favorito = Favorito(null, evento.id!, uid);
    var result = db.collection('favoritos').add(favorito.toMap()).then((fav) {
      print(fav);
    }).catchError((error) => print(error));

    return result;
  }

  static Future delFavorito(String favoritoId) async {
    await db.collection('favoritos').doc(favoritoId).delete();
  }

  static Future<List<Favorito>> getFavoritos(String userId) async {
    List<Favorito> favoritos = [];
    QuerySnapshot documentos = await db
        .collection('favoritos')
        .where('userId', isEqualTo: userId)
        .get();

    if(documentos != null){
      favoritos = documentos.docs.map((data) => Favorito.map(data)).toList();
    }
    return favoritos;
  }
}
