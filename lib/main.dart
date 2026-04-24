// lib/main.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/registration_screen.dart';
import 'controllers/match_controller.dart';

void main() async {
  // 非同期処理をmain内で実行するための必須記述
  WidgetsFlutterBinding.ensureInitialized();

  // SharedPreferencesのインスタンスを非同期で取得
  final prefs = await SharedPreferences.getInstance();

  // 取得したprefsを渡してコントローラーを生成
  final matchController = MatchController(prefs);

  runApp(BadmintonScoreApp(controller: matchController));
}

class BadmintonScoreApp extends StatelessWidget {
  final MatchController controller;

  const BadmintonScoreApp({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CourtMaster',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green.shade800,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: RegistrationScreen(controller: controller),
    );
  }
}
