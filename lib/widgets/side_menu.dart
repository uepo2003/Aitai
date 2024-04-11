import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
         DrawerHeader(
          padding: const EdgeInsets.all(0),
          margin: const EdgeInsets.all(0),
          child: Container(
            width: 100,
            color: Colors.blue,
            alignment: Alignment.center,
            child: const Text('ドロワーヘッダー'),
          ),
        ),
        ListTile(
          title: const Text('メッセージ'),
          onTap: () {
            debugPrint('リストタイル A をタップしました');
          },
        ),
        ListTile(
          title: const Text('プロフィール'),
          onTap: () {
            debugPrint('プロフィールをタップしました');
          },
        ),
        ListTile(
          title: const Text('設定'),
          onTap: () {
            debugPrint('設定をタップしました');
          },
        ),
      ]
    );
  }
}