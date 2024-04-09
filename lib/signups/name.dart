import 'package:aitai/providers/create.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

//初回登録の時に使う名前入力画面
class Name extends ConsumerWidget {
  const Name({super.key});

  push(BuildContext context) {
    context.push('/age');
  }

  

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();


    final textfield = TextField(
      controller: controller,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
       borderRadius: BorderRadius.circular(30),
       borderSide: const BorderSide(
        color:  Color.fromARGB(255, 238, 235, 225),
        )
        ),
        hoverColor: const Color.fromARGB(255, 250, 139, 139),
        border: const OutlineInputBorder(),
        labelText: "あなたの名前",
        labelStyle: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
        hintText: '漢字で入力してください',
        hintStyle: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
        errorText: null,
      ),
    );

    final button = ElevatedButton(
        
        onPressed: () {
          final read = ref.read(createNotifierProvider.notifier);
          read.updateName(controller.text);
           push(context);
        },
        child: const Text("次へ>", style: TextStyle(color:Colors.black, fontWeight: FontWeight.w600, fontSize: 20),));

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage("assets/images/29117172S.jpg"), // ここに背景にしたい画像のパスを指定
            fit: BoxFit.cover, // 画像がコンテナ全体にフィットするように調整
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(20),
                width: 300,
                child: textfield,
              ),
              button
            ],
          ),
        ),
      ),
    );
  }
}
