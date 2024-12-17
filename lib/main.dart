import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:unicorn_flutter/Route/router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:unicorn_flutter/firebase_options.dart';

import 'gen/colors.gen.dart';

void main() async {
  await dotenv.load(fileName: kDebugMode ? '.env.release' : '.env.release');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  WidgetsFlutterBinding.ensureInitialized();
  // 画面の向きを固定.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  // 日本語化
  await initializeDateFormatting('ja');

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      routeInformationProvider: router.routeInformationProvider,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
        navigationBarTheme: NavigationBarThemeData(
          labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                return const TextStyle(
                  color: ColorName.mainColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NotoSansJP',
                  fontSize: 12,
                );
              }
              return const TextStyle(
                color: ColorName.textGray,
                fontWeight: FontWeight.bold,
                fontFamily: 'NotoSansJP',
                fontSize: 10,
              );
            },
          ),
        ),
      ),
    );
  }
}
