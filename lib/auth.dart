

import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currnetUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
/* some experiments
//kullanilmiyor su anlik sonra SIL
  Future<bool> Admin()async{
    
      if(currnetUser=='9HOoNGVbHNPcjMTaMmW0kpjvjZF3'){
      return true;
    }
    return false;
  }
Future<String> inputData(String veri) async {// deneme SIL
  FirebaseAuth.instance
    .authStateChanges()
    .listen((User? user) {
      if (user != null) {
        veri=user.uid;
         
        
      }
    });
    return veri;
}*/
}
