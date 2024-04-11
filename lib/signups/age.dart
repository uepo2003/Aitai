import 'package:aitai/providers/create.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class Age extends ConsumerWidget {
  const Age({super.key});

  push(BuildContext context) {
    context.push('/image');
  }
  

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final controller = TextEditingController();

    final textfield = TextField(
      controller: controller,
      decoration: const InputDecoration(
        hoverColor: Color.fromARGB(255, 250, 139, 139),
        border: OutlineInputBorder(),
        labelText: "あなたの年齢",
        labelStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
        hintText: '年齢を入力してください',
        hintStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
        errorText: null,
      ),
    );

    final button = ElevatedButton(
      onPressed: ()  {
    //記述する順番コードは上から下に向かって実行される
      final read = ref.read(createNotifierProvider.notifier);
       read.updateAge(int.parse(controller.text));
       push(context);
      },  
      child: const Text("次へ>", style: TextStyle(color:Colors.black, fontWeight: FontWeight.w600, fontSize: 20),)
      );
    
return Scaffold(
  body: Container(
    decoration: const BoxDecoration(
      image: DecorationImage(
        image: AssetImage("assets/images/29117172S.jpg"), // ここに背景にしたい画像のパスを指定
        fit: BoxFit.cover, // 画像がコンテナ全体にフィットするように調整
      ),
    ),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin:const EdgeInsets.all(20),
            width: 300,
            child: textfield,
          ),
          button,

        ],
      ),
    ),
  ),
);
  }
}
