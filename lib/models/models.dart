// D:\badminton_score\lib\models\models.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'models.freezed.dart';
part 'models.g.dart';

/// 陣営の定義
enum TeamType {
  teamA, // チームA
  teamB, // チームB
}

/// 絶対座標の定義 (画面上の4分割コート)
enum CourtQuadrant {
  topLeft, // 左陣営：左（奇数）
  bottomLeft, // 左陣営：右（偶数）
  topRight, // 右陣営：右（偶数）
  bottomRight, // 右陣営：左（奇数）
}

/// 選手モデル
@freezed
abstract class Player with _$Player {
  const factory Player({required String id, required String name}) = _Player;

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);
}

/// 1アクション（スナップショット）の状態モデル
@freezed
abstract class MatchState with _$MatchState {
  const factory MatchState({
    @Default(0) int scoreTeamA,
    @Default(0) int scoreTeamB,
    @Default(0) int gameScoreA,
    @Default(0) int gameScoreB,
    required TeamType currentServeTeam,
    required Map<CourtQuadrant, Player> positions,
    String? serverId,
    String? receiverId,
    @Default(false) bool isMatchOver,
    @Default(false) bool isMatchStarted,
    @Default(TeamType.teamA) TeamType leftSideTeam,
    @Default(false) bool isWaitingForNextGame,
  }) = _MatchState;

  factory MatchState.fromJson(Map<String, dynamic> json) =>
      _$MatchStateFromJson(json);
}

/// 試合設定
@freezed
abstract class MatchSettings with _$MatchSettings {
  const factory MatchSettings({
    @Default(true) bool isDoubles,
    @Default(21) int winningScore,
    @Default(3) int maxGames,
  }) = _MatchSettings;

  factory MatchSettings.fromJson(Map<String, dynamic> json) =>
      _$MatchSettingsFromJson(json);
}

/// 試合全体の履歴モデル
@freezed
abstract class MatchHistory with _$MatchHistory {
  const factory MatchHistory({
    @Default([]) List<MatchState> states,
    @Default(0) int currentIndex,
    required MatchSettings settings,
    DateTime? startTime, // ← ★これを追加
  }) = _MatchHistory;

  factory MatchHistory.fromJson(Map<String, dynamic> json) =>
      _$MatchHistoryFromJson(json);
}
