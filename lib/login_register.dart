import 'package:flutter/material.dart';
import 'package:yeni/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LogRegpage extends StatefulWidget {
  const LogRegpage({super.key});

  @override
  State<LogRegpage> createState() => _LogRegpageState();
}

class _LogRegpageState extends State<LogRegpage> {
  String? errorMassege = '';
  bool isLogin = true;
  // experiment String veri='';//denemein parcasi SIL
  String admin='9HOoNGVbHNPcjMTaMmW0kpjvjZF3';//buda denemenin parcasi SIL
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerpassword = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    
    try {
      // just some testing again  await Auth().inputData(veri);//denemeler sil sonra SIL
      await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerpassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMassege = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      Auth().createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerpassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMassege = e.message;
      });
    }
  }

  Widget title() {
    return Text('Giriş yapma Ekranı');
  }

  Widget _entryField(
    String title,
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(fillColor:  Colors.white,
        labelText: title),
      
    );
  }

  Widget _errorMessage() {
    return Text(errorMassege == '' ? '' : 'Humm? $errorMassege');
  }

  Widget _submitButton() {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 99, 12, 6)),
      ),
      onPressed:
          isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword,
      child: Text(isLogin ? 'Login' : 'Register'),
    );
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
        onPressed: () {
          setState(() {
            isLogin = !isLogin;
          });
        },
        child: Text(
          isLogin ? 'Register instead' : 'Login instead',
          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: title(),
        backgroundColor: const Color.fromARGB(255, 99, 12, 6),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _entryField('email', _controllerEmail),
            _entryField('password', _controllerpassword),
            _errorMessage(),
            _submitButton(),
            _loginOrRegisterButton(),
          ],
        ),
      ),
    );
  }
}
