import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


//firebasを使ったサインインに関するメソッドをまとめています

class AuthService {
  Future<void> signIn() async {

    const clientId =
      '815982362608-f28ctpnun8lsatche6aiusste0np8354.apps.googleusercontent.com';
    const scopes = [
      'openid',
      'profile',
      'email',
    ];

    final request = GoogleSignIn(clientId: clientId, scopes: scopes);
    final response = await request.signIn();

    final authn = await response?.authentication;
    final accessToken = authn?.accessToken;
    final idToken = authn?.idToken;

    debugPrint(idToken);

    if (accessToken == null) {
      return;
    }
    debugPrint(accessToken);
    final oAuthCredential = GoogleAuthProvider.credential(
      accessToken: accessToken,
      idToken: null
    );

    debugPrint(oAuthCredential.toString());
    await FirebaseAuth.instance.signInWithCredential(oAuthCredential);
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
