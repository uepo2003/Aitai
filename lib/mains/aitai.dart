import 'package:aitai/mains/home.dart';
import 'package:aitai/mains/favorite.dart';
import 'package:aitai/mains/message.dart';
import 'package:aitai/mains/profile.dart';
import 'package:aitai/widgets/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

final indexProvider = StateProvider((ref) {
  return 0;
});

class Aitai extends ConsumerWidget {
  const Aitai({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(indexProvider);


    final appBar = index == 0 || index == 2 || index == 1 || index == 3
        ? AppBar(
    automaticallyImplyLeading: false,
    title: Row(
    children: <Widget>[
      Column(
      children: [
        IconButton(
        icon: const Icon(
          Icons.menu,
          size: 35
        ), // 画面左側に配置するアイコン
        onPressed: () {
         const Drawer(
           child: SideMenu(),
           );
        },
      ),
     const SizedBox(
        height: 10
      )
      ]
      ),
      Container(
        width: 100
      ),
      Column(
      children: [
        Text(
          'Aitai',
          style: GoogleFonts.dancingScript(fontSize: 40),
        ),
      const SizedBox(
        height: 10
      )
      ]
      ),
      Container(
        width: 75
      ),
       Column(
      children: [
        IconButton(
        icon: const Icon(
          Icons.settings,
          size: 35
        ), // 画面左側に配置するアイコン
        onPressed: () {
          // アイコンボタンの動作
        },
      ),
      const SizedBox(
        height: 10
      )
      ]
      )
      // ここに他のアイコンやウィジェットを配置しても良い
    ],
  ),
            backgroundColor: const Color.fromARGB(255, 234, 109, 151),
          )
        : null;

        //パディングを使って調整するっぽい？？

    const items = [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ホーム'),
      BottomNavigationBarItem(icon: Icon(IconData(0xe65b, fontFamily: 'MaterialIcons')), label: 'いいね'),
      BottomNavigationBarItem(icon: Icon(IconData(0xf1c6, fontFamily: 'MaterialIcons')), label: 'メッセージ'),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: 'マイページ'),
    ];

    final underBar = BottomNavigationBar(
      items: items,
      backgroundColor: Colors.blue,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      currentIndex: index,
      showUnselectedLabels: true,
      onTap: (index) {
        ref.read(indexProvider.notifier).state = index;
      },
    );

   final pages = [
      const Home(),
      const Favorite(),
      const Messages(),
      const Profile(),
    ];

    return Scaffold(
      appBar: appBar,
      body: pages[index],
      bottomNavigationBar: underBar,
      
    );
  }
}
