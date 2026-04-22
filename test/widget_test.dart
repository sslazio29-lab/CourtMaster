// D:\badminton_score\test\widget_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:badminton_score/main.dart';
import 'package:badminton_score/controllers/match_controller.dart';

void main() {
  testWidgets('App initialization smoke test', (WidgetTester tester) async {
    // テスト環境用にSharedPreferencesのモックデータを設定（空の状態で初期化）
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    // モックのprefsを渡してテスト用のコントローラーを生成
    final matchController = MatchController(prefs);

    // アプリをビルドしてフレームをトリガー
    await tester.pumpWidget(BadmintonScoreApp(controller: matchController));

    // RegistrationScreen が正常に起動し、「試合設定」のテキストが存在するか検証
    expect(find.text('試合設定'), findsOneWidget);
  });
}
