import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_game_duo/constants/platform_constants.dart';
import 'package:good_game_duo/screens/splash/splash_page.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  KakaoSdk.init(
    nativeAppKey: PlatformConstants.kakaoNativeAppKey,
    javaScriptAppKey: PlatformConstants.kakaoJavaScriptKey,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: myTheme,
      debugShowCheckedModeBanner: false,
      home: const SplashPage(),
    );
  }

  final ThemeData myTheme = ThemeData(
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: Colors.black, // 선택된 항목의 색상
      unselectedItemColor: Colors.grey, // 선택되지 않은 항목의 색상
      //showUnselectedLabels: true, // 선택되지 않은 항목에도 라벨을 표시
      //selectedLabelStyle: TextStyle(fontSize: 16), // 선택된 항목의 라벨 스타일
      //unselectedLabelStyle: TextStyle(fontSize: 16), // 선택되지 않은 항목의 라벨 스타일
    ),
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Colors.white12,
      // AppBar background, button background,
      onPrimary: Colors.black,
      // Appbar Text, Appbar Icon, Button Text
      secondary: Colors.blue,
      onSecondary: Colors.white,
      error: Colors.red,
      onError: Colors.redAccent,
      background: Colors.white,
      onBackground: Colors.black,
      surface: Colors.white,
      onSurface: Colors.black,
    ),
  );
}
