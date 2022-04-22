import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserAuthProvider{
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ["email"]);
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool isAuthenticated(){
    return _firebaseAuth.currentUser != null;
  }

  Future googleSignOut() async{
    await _googleSignIn.signOut();
  }

  Future fbSignOut() async{
    await _firebaseAuth.signOut();
  }

  Future googleSignIn() async{
    final guser = await _googleSignIn.signIn();
    if(guser == null) return;
    final gauth = await guser.authentication;
    await _firebaseAuth.signInWithCredential(GoogleAuthProvider.credential(idToken: gauth.idToken, accessToken: gauth.accessToken));
    await newSignIn(_firebaseAuth.currentUser!.uid);
  }

  Future newSignIn(String uid) async{
    var user = await FirebaseFirestore.instance.collection("user").doc(uid).get();
    if(user.exists) return;
    await FirebaseFirestore.instance.collection("user").doc(uid).set({"favorites":[]});
  }
}
