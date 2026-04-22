// D:\badminton_score\lib\logic\match_logic.dart

import '../models/models.dart';

class MatchLogic {
  static MatchState calculateNextState({
    required MatchState currentState,
    required MatchSettings settings,
    required TeamType scoringTeam,
  }) {
    if (currentState.isMatchOver || currentState.isWaitingForNextGame) {
      return currentState;
    }

    // 1. スコア更新
    final newScoreA =
        currentState.scoreTeamA + (scoringTeam == TeamType.teamA ? 1 : 0);
    final newScoreB =
        currentState.scoreTeamB + (scoringTeam == TeamType.teamB ? 1 : 0);
    final isServiceOver = currentState.currentServeTeam != scoringTeam;
    final scoringTeamScore = scoringTeam == TeamType.teamA
        ? newScoreA
        : newScoreB;
    final isEvenScore = scoringTeamScore % 2 == 0;

    // 2. 座標とサーバーの計算
    Map<CourtQuadrant, Player> newPositions = Map.of(currentState.positions);
    String? newServerId;
    String? newReceiverId;

    if (settings.isDoubles) {
      if (!isServiceOver) {
        // 連続得点時のスワップ
        final teamQuads = _getTeamQuadrants(
          scoringTeam,
          currentState.leftSideTeam,
        );
        final player1 = newPositions[teamQuads[0]];
        final player2 = newPositions[teamQuads[1]];
        if (player1 != null && player2 != null) {
          newPositions[teamQuads[0]] = player2;
          newPositions[teamQuads[1]] = player1;
        }
        newServerId = currentState.serverId;
      } else {
        // サービスオーバー
        final serverQuad = _getServerQuadrant(
          scoringTeam,
          isEvenScore,
          currentState.leftSideTeam,
        );
        newServerId = newPositions[serverQuad]?.id;
      }
    } else {
      // シングルス
      final serverQuad = _getServerQuadrant(
        scoringTeam,
        isEvenScore,
        currentState.leftSideTeam,
      );
      final receiverQuad = _getDiagonalQuadrant(serverQuad);

      final scoringTeamPlayer = currentState.positions.entries
          .where(
            (e) => _isTeamCourt(e.key, scoringTeam, currentState.leftSideTeam),
          )
          .map((e) => e.value)
          .firstOrNull;
      final otherTeam = scoringTeam == TeamType.teamA
          ? TeamType.teamB
          : TeamType.teamA;
      final otherTeamPlayer = currentState.positions.entries
          .where(
            (e) => _isTeamCourt(e.key, otherTeam, currentState.leftSideTeam),
          )
          .map((e) => e.value)
          .firstOrNull;

      if (scoringTeamPlayer != null && otherTeamPlayer != null) {
        newPositions.removeWhere((k, v) => true);
        newPositions[serverQuad] = scoringTeamPlayer;
        newPositions[receiverQuad] = otherTeamPlayer;
        newServerId = scoringTeamPlayer.id;
      }
    }

    // レシーバー特定
    if (newServerId != null) {
      final serverEntry = newPositions.entries
          .where((e) => e.value.id == newServerId)
          .firstOrNull;
      if (serverEntry != null) {
        newReceiverId = newPositions[_getDiagonalQuadrant(serverEntry.key)]?.id;
      }
    }

    // 3. ゲーム・試合終了判定
    bool isGameWon = _checkGameWon(newScoreA, newScoreB, settings.winningScore);
    int newGameScoreA = currentState.gameScoreA;
    int newGameScoreB = currentState.gameScoreB;
    bool isMatchOver = false;
    bool isWaitingForNextGame = false;

    if (isGameWon) {
      if (newScoreA > newScoreB) {
        newGameScoreA++;
      } else {
        newGameScoreB++;
      }

      final requiredGames = (settings.maxGames / 2).floor() + 1;
      if (newGameScoreA >= requiredGames || newGameScoreB >= requiredGames) {
        isMatchOver = true;
      } else {
        isWaitingForNextGame = true; // 次のゲームへのインターバルへ
      }
    }

    return currentState.copyWith(
      scoreTeamA: newScoreA,
      scoreTeamB: newScoreB,
      gameScoreA: newGameScoreA,
      gameScoreB: newGameScoreB,
      currentServeTeam: scoringTeam,
      positions: newPositions,
      serverId: newServerId,
      receiverId: newReceiverId,
      isMatchOver: isMatchOver,
      isWaitingForNextGame: isWaitingForNextGame,
    );
  }

  static List<CourtQuadrant> _getTeamQuadrants(
    TeamType team,
    TeamType leftSideTeam,
  ) {
    return team == leftSideTeam
        ? [CourtQuadrant.topLeft, CourtQuadrant.bottomLeft]
        : [CourtQuadrant.topRight, CourtQuadrant.bottomRight];
  }

  static CourtQuadrant _getServerQuadrant(
    TeamType team,
    bool isEven,
    TeamType leftSideTeam,
  ) {
    if (team == leftSideTeam) {
      return isEven ? CourtQuadrant.bottomLeft : CourtQuadrant.topLeft;
    } else {
      return isEven ? CourtQuadrant.topRight : CourtQuadrant.bottomRight;
    }
  }

  static CourtQuadrant _getDiagonalQuadrant(CourtQuadrant quad) {
    switch (quad) {
      case CourtQuadrant.topLeft:
        return CourtQuadrant.bottomRight;
      case CourtQuadrant.bottomLeft:
        return CourtQuadrant.topRight;
      case CourtQuadrant.topRight:
        return CourtQuadrant.bottomLeft;
      case CourtQuadrant.bottomRight:
        return CourtQuadrant.topLeft;
    }
  }

  static bool _isTeamCourt(
    CourtQuadrant quad,
    TeamType team,
    TeamType leftSideTeam,
  ) {
    final isLeft =
        quad == CourtQuadrant.topLeft || quad == CourtQuadrant.bottomLeft;
    return (team == leftSideTeam) ? isLeft : !isLeft;
  }

  static bool _checkGameWon(int scoreA, int scoreB, int winningScore) {
    final maxCap = winningScore == 21
        ? 30
        : (winningScore == 15 ? 21 : winningScore + 9);
    if (scoreA >= winningScore || scoreB >= winningScore) {
      if ((scoreA - scoreB).abs() >= 2) return true;
      if (scoreA == maxCap || scoreB == maxCap) return true;
    }
    return false;
  }
}
