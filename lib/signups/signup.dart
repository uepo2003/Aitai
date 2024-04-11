import 'package:aitai/providers/service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';


//サインアップ画面
class SignUp extends ConsumerWidget {
  const SignUp({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final signup = SizedBox(
        height: 70,
        width: double.infinity,
    
        child: Align(
          alignment: Alignment.center,
          child: Text('~Welcome~',
           style: GoogleFonts.dancingScript(fontSize: 60))
        )
      );

    final button = Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      child:  SignInButton(
          Buttons.Google,
          onPressed: () async {
             final service = AuthService();
        service.signIn().catchError((e) {
          debugPrint('サインインできませんでした $e');
        });
            
          },
        ),
    );
    return Scaffold(
      appBar:AppBar(
      title:  Text(
          'Aitai',
          style: GoogleFonts.dancingScript(fontSize: 40),
      ),
      backgroundColor: const Color.fromARGB(255, 234, 109, 151),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [signup,button],)
    );
  }
}

