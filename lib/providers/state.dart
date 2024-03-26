import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
part 'state.g.dart';

@riverpod
Stream<User?> userChanges(UserChangesRef ref) { 
  return FirebaseAuth.instance.authStateChanges();
}

@riverpod 
String? currentUser(CurrentUserRef ref){
  final userinfo = ref.watch(userProvider);
  return userinfo?.uid;
}

@riverpod
Future<QuerySnapshot<Map<String, dynamic>>> profileImage(ProfileImageRef ref) async {
  final db = FirebaseFirestore.instance;
   final snapshot = await db.collection("profileImage").get();
   return snapshot;
}





@riverpod
User? user(UserRef ref) {
  final userChanges = ref.watch(userChangesProvider);
  return userChanges.when(
    loading: () => null,
    error: (_,__) => null,
    data: (d) => d,
  );
}




@riverpod
bool signedIn(SignedInRef ref) {
  final user = ref.watch(userProvider);
  return user != null;
}



@riverpod
String userId(UserIdRef ref) {
  throw 'スコープ内の画面でしか使えません';
}


class UserIdScope extends ConsumerWidget {
  const UserIdScope({
    super.key,
    required this.child});

    final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    if(user == null) {
      return const CircularProgressIndicator();
    } else {
      return ProviderScope(
        overrides: [
          userIdProvider.overrideWithValue(user.uid),
        ],
        child: child,
      );
    }
  }
}




