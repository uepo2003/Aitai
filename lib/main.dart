import 'package:aitai/router.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'ignores/firebase_options.dart';
import 'package:flutter/foundation.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('ここまではクリアしています!!2');
    const app = MyApp();
    const scope = ProviderScope(child: app);
    final devicePreview = DevicePreview(builder: (_) => scope);
    if(kIsWeb) {
      runApp(devicePreview);
    } else {
      runApp(scope);
    }

  debugPrint('ここまではクリアしています!!1');
}


