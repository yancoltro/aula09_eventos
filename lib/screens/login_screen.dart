import 'package:aula09_eventos/commom/authentication.dart';
import 'package:aula09_eventos/screens/evento_screen.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLogin = true;
  late String? _userId = null;
  late String _email = "";
  late String _senha = "";
  late String _mensagem = "";
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();
  late Authetication auth;

  @override
  void initState() {
    auth = Authetication();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 50),
        margin: EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Form(
              child: Column(
            children: [
              emailInput(),
              passwordlInput(),
              mainButton(),
              secondaryButton(),
              validationMessage(),
            ],
          )),
        ),
      ),
    );
  }

  Widget emailInput() {
    return Padding(
      padding: EdgeInsets.only(bottom: 50),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: txtEmail,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: 'Email',
          icon: Icon(Icons.email),
        ),
        validator: (email) =>
            EmailValidator.validate(email!) ? null : 'Forneça um email válido',
      ),
    );
  }

  Widget passwordlInput() {
    return Padding(
      padding: EdgeInsets.only(bottom: 50),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: txtPassword,
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'Senha',
          icon: Icon(Icons.enhanced_encryption),
        ),
        validator: (text) => text!.isEmpty ? 'Senha é obrigatório' : '',
      ),
    );
  }

  Widget mainButton() {
    String buttonText = _isLogin ? "Login" : "Registrar";
    return Padding(
      padding: EdgeInsets.only(top: 5),
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              // color
              elevation: MaterialStateProperty.all<double>(3.0)),
          child: Text(buttonText),
          onPressed: () {
            submit();
          },
        ),
      ),
    );
  }

  Widget secondaryButton() {
    String buttonText = _isLogin ? "Registrar-se" : "Login";
    return TextButton(
      child: Text(buttonText),
      onPressed: () {
        setState(() {
          _isLogin = !_isLogin;
        });
      },
    );
  }

  Widget validationMessage() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: Text(
        _mensagem,
        style: TextStyle(
          fontSize: 16,
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future submit() async {
    setState(() {
      _mensagem = "";
    });

    Map<String, dynamic> status;

    try {
      if (_isLogin) {
        status = await auth.login(txtEmail.text, txtPassword.text);
      } else {
        status = await auth.register(txtEmail.text, txtPassword.text);
      }
    print(status);
      if (status['success']) {
        setState(() {
          _userId = status['userId'];
        });
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => EventoScreen(_userId!)));
      } else {
        setState(() {
          _mensagem = status['message'];
        });
      }
    } catch (exception) {
      setState(() {
        _mensagem = exception.toString();
      });
    }
  }
}
