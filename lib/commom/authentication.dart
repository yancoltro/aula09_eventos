import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class Authetication {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>> login(String email, String password) async {
    Map<String, dynamic> feedback = {
      "success": false,
      "message": "Houve um problema com o Login"
    };
    try {
      final credential = await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((login) {
        feedback = {
          "success": true,
          "userId": login.user?.uid,
        };
      });
      print(credential);
    } on FirebaseAuthException catch (authException) {
      // print(authException.code);
      if (authException.code == 'user-not-found') {
        feedback = {
          "success": false,
          "message": "Usuário não encontrado",
        };
      } else if (authException.code == 'wrong-password') {
        feedback = {
          "success": false,
          "message": "A senha fornecida para esse usuário está incorreta",
        };
      }
    } catch (exception) {
      feedback = {
        "registered": false,
        "message": exception.toString(),
      };
    }

    return feedback;
  }

  Future<Map<String, dynamic>> register(String email, String password) async {
    Map<String, dynamic> feedback = {
      "success": false,
      "message": "Houve um problema com o Registro",
    };
    try {
      final credential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((register) {
        // print(register.user);
        feedback = {
          "success": true,
          "userId": register.user?.uid.toString(),
        };
      });
    } on FirebaseAuthException catch (authException) {
      print(authException.code);
      if (authException.code == 'weak-password') {
        feedback = {
          "success": false,
          "message": 'A senha fornecida é muito fraca.',
        };
      } else if (authException.code == 'email-already-in-use') {
        feedback = {
          "success": false,
          "message": 'Já existe uma conta para este email.',
        };
      }
    } catch (exception) {
      print(exception);
      feedback = {
        "success": false,
        "message": exception.toString(),
      };
    }
    return feedback;
  }

  Future<void> signOut() {
    return _auth.signOut();
  }

  Future<User?> getUser() async {
    return _auth.currentUser;
  }
}
