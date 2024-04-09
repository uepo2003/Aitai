import 'package:aitai/providers/state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'create.freezed.dart';

//firebaseを使った初回登録のcreate機能
@freezed
class Profile with _$Profile {
  const factory Profile({
    required String name,
    required int age,
    required String image,
    required String profile,
  }) = _Profile;
}
 final createNotifierProvider = StateNotifierProvider<CreateNotifier, Profile>((ref) {
      return CreateNotifier();
});

@riverpod
class CreateNotifier extends StateNotifier<Profile> {

CreateNotifier() : super(const Profile(name: '', age: 0, image: '', profile: ''));

 void updateName(String newName) {
    state = Profile(
      name: newName, 
      age: state.age, 
      image: state.image, 
      profile: state.profile,
    );
  }

  void updateAge(int newAge) {
   
    state = Profile(
      name: state.name, 
      age: newAge, 
      image: state.image, 
      profile: state.profile,
    );
  }

  void updateImage(String newImage) {
   
    state = Profile(
      name: state.name, 
      age: state.age, 
      image: newImage, 
      profile: state.profile,
    );
  }

   void updateProfile(String newProfile) {
   
    state = Profile(
      name: state.name, 
      age: state.age, 
      image: state.image, 
      profile: newProfile,
    );
  }
}

class FireDB {
  final db = FirebaseFirestore.instance;
  Future<void> create(
    String name,int age,
    String image, String profile,
    WidgetRef ref
     ) async {

    final display = ref.watch(currentUserProvider);
    await db.collection('users').doc(display).set({
      'name': name,
      'age': age,
      'image': image,
      'profile': profile
    });
  }
}
