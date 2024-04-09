//初回登録の時に使うプロフィール画像登録画面
import 'dart:io';
import 'package:aitai/providers/create.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';


class NewImage extends ConsumerStatefulWidget {
  const NewImage({super.key});


  @override
  NewImageState createState() => NewImageState();
}

class NewImageState extends ConsumerState<NewImage> {
  String imageUrl = '';
  bool isImageUploaded = false; // 画像がアップロードされたかどうかのフラグ
  push(BuildContext context) {
    context.push('/profile');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/29117172S.jpg"), // 背景画像
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  ImagePicker imagePicker = ImagePicker();
                  XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
                  if (file == null) return;

                  String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
                  Reference referenceRoot = FirebaseStorage.instance.ref();
                  Reference referenceImageToUpload = referenceRoot.child('images/$uniqueFileName');

                  try {
                    await referenceImageToUpload.putFile(File(file.path));
                    imageUrl = await referenceImageToUpload.getDownloadURL();   
                    final read = ref.watch(createNotifierProvider.notifier);
                    read.updateImage(imageUrl); 
                    setState(() {
                      isImageUploaded = true;
                    });
                  } catch (error) {
                    debugPrint(error.toString());
                  }
                },
                child: const Text(
                  "画像をアップロードする",
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 20),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: isImageUploaded ? () => push(context) : null, // 画像がアップロードされている場合のみ有効
                style: ElevatedButton.styleFrom(
                  backgroundColor: isImageUploaded ? Colors.blue : Colors.grey, // アップロード状態に基づいて色を変更
                ),
                child: const Text(
                  "次へ>",
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}