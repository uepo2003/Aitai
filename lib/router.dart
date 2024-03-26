import 'package:aitai/signups/age.dart';
import 'package:aitai/mains/aitai.dart';
import 'package:aitai/subs/chat.dart';

import 'package:aitai/signups/image.dart';
import 'package:aitai/signups/name.dart';
import 'package:aitai/signups/new_profile.dart';
import 'package:aitai/signups/signup.dart';
import 'package:aitai/providers/state.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';
part 'router.g.dart';

class PagePath {
  static const signIn = '/sign-in';
  static const name = '/name';
  static const home = '/home';
  static const image = '/image';
}



@riverpod 
GoRouter router(RouterRef ref){

  final routes = [
    GoRoute(
      path: PagePath.signIn,
      builder: (_,__) => const SignUp()
    ),
    GoRoute(
      path: PagePath.name,
      builder:(_,__) => const Name(),
    ),
    GoRoute(
          path: PagePath.home,
          builder: (_,__) => const Aitai()
    ),
    GoRoute(
      path: '/age',
      builder:(_,__) => const Age(),
    ),
    GoRoute(
      path: '/image',
      builder:(_,__) => const NewImage(),
    ),
    GoRoute(
      path: '/profile',
      builder:(_,__) => const SpeechScreen(),
    ),

     GoRoute(
      path: '/chat',
      builder:(_,__) => const Chat(),
    ),
  ];

  String? redirect(BuildContext context, GoRouterState state){
    final page = state.uri.toString();
    final signedIn = ref.read(signedInProvider);

    if(signedIn && page == PagePath.signIn) {
      return PagePath.home;
    } else if(!signedIn){
      return PagePath.signIn;
    } else {
      return null;
    }
  }

  final listenable = ValueNotifier<Object?>(null);
  ref.listen<Object?>(signedInProvider, (_, newState) {
   listenable.value = newState;
  });

  ref.onDispose(listenable.dispose);
  
  return GoRouter(
    initialLocation: PagePath.name,
    routes: routes,
    redirect: redirect,
    refreshListenable: listenable,
  );
}




class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,

    );
  }
}