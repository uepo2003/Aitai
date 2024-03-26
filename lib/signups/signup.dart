import 'package:aitai/providers/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//サインアップ画面
class SignUp extends ConsumerWidget {
  const SignUp({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final signup = Container(
        height: 60,
        width: double.infinity,
        color: Colors.green,
        child: const Align(
          alignment: Alignment.center,
          child: Text('サインアップ'),
        )
      );

    final button = Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      child: ElevatedButton( 
        style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(20),
        backgroundColor: Colors.blue,
      ),
      onPressed: () async {
        final service = AuthService();
        await service.signIn().catchError((e) {
          debugPrint('サインインできませんでした $e');
        });
       
      }, 
      child: const Text('サインイン')
      ),
    );


    return Scaffold(
      appBar: AppBar(
        title: const Text('Aitai'),
        backgroundColor: const Color.fromARGB(255, 224, 135, 135),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [signup,button],)
    );
  }
}

