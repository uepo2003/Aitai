import 'package:flutter/material.dart';

/// レモン ダイアログ
class FabDialog extends StatelessWidget {
  const FabDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Text('いいねには課金が必要です', style: TextStyle(fontSize: 20 ,fontWeight: FontWeight.w500, color: Color.fromARGB(255, 92, 167, 227))),
      content: const Text('AppStoreを開いてもいいですか？', style: TextStyle(fontSize: 20 ,fontWeight: FontWeight.w500, color: Color.fromARGB(255, 92, 167, 227))),
      actions: [
        // ボタン
        TextButton(
          onPressed: () {
            // ダイアログを閉じる
            Navigator.pop(context, 'A');
          },
          child: const Text('キャンセル',style: TextStyle(fontSize: 20 ,fontWeight: FontWeight.w500, color: Color.fromARGB(255, 92, 167, 227))),
        ),
        // ボタン
        TextButton(
          onPressed: () {
            // ダイアログを閉じる
            Navigator.pop(context, 'B');
          },
          child: const Text('はい',style: TextStyle(fontSize: 20 ,fontWeight: FontWeight.w500, color: Color.fromARGB(255, 92, 167, 227))),
        ),
      ],
    );
  }
}