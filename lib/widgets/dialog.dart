import 'package:flutter/material.dart';

/// レモン ダイアログ
class FabDialog extends StatelessWidget {
  const FabDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('レモン'),
      content: const Text('唐揚げにかけてもいいですか？'),
      actions: [
        // ボタン
        TextButton(
          onPressed: () {
            // ダイアログを閉じる
            Navigator.pop(context, 'A');
          },
          child: const Text('キャンセル'),
        ),
        // ボタン
        TextButton(
          onPressed: () {
            // ダイアログを閉じる
            Navigator.pop(context, 'B');
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}