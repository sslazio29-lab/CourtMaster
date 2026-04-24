// D:\badminton_score\lib\controllers\match_controller.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import '../logic/match_logic.dart';

class MatchController extends ChangeNotifier {
  static const String _prefsKey = 'saved_match_history';
  MatchHistory _history;
  final SharedPreferences _prefs;

  MatchController(this._prefs)
    : _history = const MatchHistory(settings: MatchSettings()) {
    _loadFromPrefs();
  }

  MatchHistory get history => _history;
  MatchState? get currentState => _history.states.isNotEmpty
      ? _history.states[_history.currentIndex]
      : null;
  bool get canUndo => _history.currentIndex > 0;
  bool get canRedo => _history.currentIndex < _history.states.length - 1;

  void initializeMatch({
    required List<Player> teamAPlayers,
    required List<Player> teamBPlayers,
    required MatchSettings settings,
  }) {
    final Map<CourtQuadrant, Player> initialPositions = {};
    initialPositions[CourtQuadrant.bottomLeft] = teamAPlayers[0];

    if (settings.isDoubles && teamAPlayers.length > 1) {
      initialPositions[CourtQuadrant.topLeft] = teamAPlayers[1];
    }

    initialPositions[CourtQuadrant.topRight] = teamBPlayers[0];

    if (settings.isDoubles && teamBPlayers.length > 1) {
      initialPositions[CourtQuadrant.bottomRight] = teamBPlayers[1];
    }

    final initialState = MatchState(
      currentServeTeam: TeamType.teamA,
      positions: initialPositions,
      serverId: teamAPlayers[0].id,
      receiverId: teamBPlayers[0].id,
      leftSideTeam: TeamType.teamA,
    );

    _history = MatchHistory(
      states: [initialState],
      currentIndex: 0,
      settings: settings,
    );
    _saveAndNotify();
  }

  void startNextGame({required bool changeEnds}) {
    final state = currentState;
    if (state == null || !state.isWaitingForNextGame) {
      return;
    }

    final nextServeTeam = state.currentServeTeam;
    final nextLeftSideTeam = changeEnds
        ? (state.leftSideTeam == TeamType.teamA
              ? TeamType.teamB
              : TeamType.teamA)
        : state.leftSideTeam;

    final Map<CourtQuadrant, Player> nextPositions = {};

    state.positions.forEach((quad, player) {
      CourtQuadrant nextQuad = quad;
      if (changeEnds) {
        if (quad == CourtQuadrant.topLeft) {
          nextQuad = CourtQuadrant.bottomRight;
        } else if (quad == CourtQuadrant.bottomLeft) {
          nextQuad = CourtQuadrant.topRight;
        } else if (quad == CourtQuadrant.topRight) {
          nextQuad = CourtQuadrant.bottomLeft;
        } else if (quad == CourtQuadrant.bottomRight) {
          nextQuad = CourtQuadrant.topLeft;
        }
      }
      nextPositions[nextQuad] = player;
    });

    final serverQuad = nextServeTeam == nextLeftSideTeam
        ? CourtQuadrant.bottomLeft
        : CourtQuadrant.topRight;
    final nextServerId = nextPositions[serverQuad]?.id;
    final nextReceiverId =
        nextPositions[serverQuad == CourtQuadrant.bottomLeft
                ? CourtQuadrant.topRight
                : CourtQuadrant.bottomLeft]
            ?.id;

    final nextState = MatchState(
      scoreTeamA: 0,
      scoreTeamB: 0,
      gameScoreA: state.gameScoreA,
      gameScoreB: state.gameScoreB,
      currentServeTeam: nextServeTeam,
      positions: nextPositions,
      serverId: nextServerId,
      receiverId: nextReceiverId,
      leftSideTeam: nextLeftSideTeam,
      isMatchStarted: false,
    );

    _addState(nextState);
  }

  void startMatch() {
    if (currentState != null && !currentState!.isMatchStarted) {
      // ★開始時刻が未設定なら、現在の端末時刻を記録する
      final newStartTime = _history.startTime ?? DateTime.now();

      _addState(currentState!.copyWith(isMatchStarted: true));

      // history自体も更新する
      _history = _history.copyWith(startTime: newStartTime);
      _saveAndNotify();
    }
  }

  void addScore(TeamType team) {
    final next = MatchLogic.calculateNextState(
      currentState: currentState!,
      settings: _history.settings,
      scoringTeam: team,
    );
    _addState(next);
  }

  void undo() {
    if (canUndo) {
      _history = _history.copyWith(currentIndex: _history.currentIndex - 1);
      notifyListeners();
    }
  }

  void redo() {
    if (canRedo) {
      _history = _history.currentIndex < _history.states.length - 1
          ? _history.copyWith(currentIndex: _history.currentIndex + 1)
          : _history;
      notifyListeners();
    }
  }

  void _addState(MatchState newState) {
    final newStates = _history.states.sublist(0, _history.currentIndex + 1)
      ..add(newState);
    _history = _history.copyWith(
      states: newStates,
      currentIndex: newStates.length - 1,
    );
    _saveAndNotify();
  }

  void _saveAndNotify() {
    _saveToPrefs();
    notifyListeners();
  }

  Future<void> _saveToPrefs() async {
    await _prefs.setString(_prefsKey, jsonEncode(_history.toJson()));
  }

  void _loadFromPrefs() {
    final s = _prefs.getString(_prefsKey);
    if (s != null) {
      _history = MatchHistory.fromJson(jsonDecode(s));
      notifyListeners();
    }
  }

  void updatePlayerName(String id, String name) {
    final state = currentState;
    if (state == null || state.isMatchStarted) {
      return;
    }

    final pos = Map<CourtQuadrant, Player>.of(state.positions);
    pos.updateAll((k, v) => v.id == id ? v.copyWith(name: name) : v);

    final newStates = List<MatchState>.from(_history.states);
    newStates[_history.currentIndex] = state.copyWith(positions: pos);
    _history = _history.copyWith(states: newStates);
    notifyListeners();
  }

  void setInitialServer(CourtQuadrant quad) {
    final state = currentState;
    if (state == null || state.isMatchStarted) {
      return;
    }
    if (quad != CourtQuadrant.bottomLeft && quad != CourtQuadrant.topRight) {
      return;
    }

    // 第1ゲーム開始前のみチームごとのサーブ権変更を許可
    if ((state.gameScoreA + state.gameScoreB) > 0) {
      return;
    }

    final positions = state.positions;
    final isLeft = (quad == CourtQuadrant.bottomLeft);
    final newServeTeam = isLeft
        ? state.leftSideTeam
        : (state.leftSideTeam == TeamType.teamA
              ? TeamType.teamB
              : TeamType.teamA);

    final newServerId = positions[quad]?.id;
    final newReceiverId =
        positions[isLeft ? CourtQuadrant.topRight : CourtQuadrant.bottomLeft]
            ?.id;

    final newState = state.copyWith(
      currentServeTeam: newServeTeam,
      serverId: newServerId,
      receiverId: newReceiverId,
    );

    final newStates = List<MatchState>.from(_history.states);
    newStates[_history.currentIndex] = newState;
    _history = _history.copyWith(states: newStates);
    _saveAndNotify();
  }

  void swapInitialPositions(bool isLeft) {
    final state = currentState;
    if (state == null || state.isMatchStarted || !_history.settings.isDoubles) {
      return;
    }

    final positions = Map<CourtQuadrant, Player>.of(state.positions);
    final topQuad = isLeft ? CourtQuadrant.topLeft : CourtQuadrant.topRight;
    final bottomQuad = isLeft
        ? CourtQuadrant.bottomLeft
        : CourtQuadrant.bottomRight;

    final topPlayer = positions[topQuad];
    final bottomPlayer = positions[bottomQuad];

    if (topPlayer != null && bottomPlayer != null) {
      positions[topQuad] = bottomPlayer;
      positions[bottomQuad] = topPlayer;
    }

    // スワップした陣営が「現在のサーバー陣営」だった場合、右コートに移動した選手をサーバーに設定する
    String? newServerId = state.serverId;
    String? newReceiverId = state.receiverId;
    final serveSideIsLeft = (state.currentServeTeam == state.leftSideTeam);

    if (isLeft && serveSideIsLeft) {
      newServerId = positions[CourtQuadrant.bottomLeft]?.id;
      newReceiverId = positions[CourtQuadrant.topRight]?.id;
    } else if (!isLeft && !serveSideIsLeft) {
      newServerId = positions[CourtQuadrant.topRight]?.id;
      newReceiverId = positions[CourtQuadrant.bottomLeft]?.id;
    }

    final newState = state.copyWith(
      positions: positions,
      serverId: newServerId,
      receiverId: newReceiverId,
    );

    final newStates = List<MatchState>.from(_history.states);
    newStates[_history.currentIndex] = newState;
    _history = _history.copyWith(states: newStates);
    _saveAndNotify();
  }
}
