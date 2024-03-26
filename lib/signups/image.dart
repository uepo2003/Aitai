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

  TextEditingController controller = TextEditingController();

  push(BuildContext context) {
    context.push('/profile');
  }


  @override
  Widget build(BuildContext context) {

      final button2 = ElevatedButton(
      onPressed: () async {
        ImagePicker imagePicker = ImagePicker();

         XFile? file =
          await imagePicker.pickImage(source: ImageSource.gallery);
          debugPrint('${file?.path}');
          if(file==null) return;


          String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

          Reference referenceRoot = FirebaseStorage.instance.ref();

          Reference referenceDirImages = referenceRoot.child('images');

           Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

          try {
            final String os = Platform.operatingSystem;
            debugPrint("OS = $os");
            final bool isIOS = Platform.isIOS;
            debugPrint("isOS = $isIOS");
          } catch (e) {
            // Platform関連のコードがWebで実行された場合にここが実行される
            debugPrint("Platform information not available in web environment");
          }


           try{
             await referenceImageToUpload.putFile(File(file.path));

             imageUrl = await referenceImageToUpload.getDownloadURL();

             debugPrint(imageUrl);

             final read = ref.read(createNotifierProvider.notifier);
             read.updateImage(imageUrl); 

           }catch(error){
            debugPrint(error.toString());
           }

      }, 
      child: const Text("画像をアップロードする"));
    
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
        
          ElevatedButton(onPressed: (){

            final read = ref.read(createNotifierProvider.notifier);
            read.updateName(controller.text);
             push(context);
          }, 
          child:const Text("次へ>")
          ),
          const SizedBox(
            height: 40,
          ),
          button2
        ],
      ),
    ),
  ),
);
  }
}





