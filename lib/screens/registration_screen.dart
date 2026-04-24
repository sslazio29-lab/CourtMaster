// lib/screens/registration_screen.dart

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/models.dart';
import '../controllers/match_controller.dart';
import 'match_screen.dart';

class RegistrationScreen extends StatefulWidget {
  final MatchController controller;

  const RegistrationScreen({super.key, required this.controller});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _teamAController = TextEditingController();
  final TextEditingController _teamBController = TextEditingController();

  bool _isDoubles = true;
  int _winningScore = 21;
  int _maxGames = 3;

  @override
  void dispose() {
    _teamAController.dispose();
    _teamBController.dispose();
    super.dispose();
  }

  List<Player> _parsePlayers(
    String input,
    String defaultPrefix,
    int requiredCount,
  ) {
    final rawNames = input
        .split(RegExp(r'[,\n]'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final uuid = Uuid();
    final List<Player> players = [];

    for (int i = 0; i < requiredCount; i++) {
      final name =
          i < rawNames.length ? rawNames[i] : '$defaultPrefix${i + 1}';
      players.add(Player(id: uuid.v4(), name: name));
    }
    return players;
  }

  void _startMatch() {
    final requiredPlayers = _isDoubles ? 2 : 1;

    final teamAPlayers = _parsePlayers(
      _teamAController.text,
      'TeamA-',
      requiredPlayers,
    );
    final teamBPlayers = _parsePlayers(
      _teamBController.text,
      'TeamB-',
      requiredPlayers,
    );

    final settings = MatchSettings(
      isDoubles: _isDoubles,
      winningScore: _winningScore,
      maxGames: _maxGames,
    );

    widget.controller.initializeMatch(
      teamAPlayers: teamAPlayers,
      teamBPlayers: teamBPlayers,
      settings: settings,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => MatchScreen(controller: widget.controller),
      ),
    );
  }

  /// 試合設定（シングルス/ダブルス・点数・ゲーム数）
  /// Wrap で横に並べ、幅が足りない場合は折り返す
  Widget _buildSettingsControls() {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 16,
      runSpacing: 8,
      children: [
        ToggleButtons(
          isSelected: [_isDoubles, !_isDoubles],
          onPressed: (index) {
            setState(() {
              _isDoubles = index == 0;
            });
          },
          children: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text('ダブルス'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text('シングルス'),
            ),
          ],
        ),
        DropdownButton<int>(
          value: _winningScore,
          items: [11, 15, 21, 30].map((score) {
            return DropdownMenuItem(
              value: score,
              child: Text('$score 点マッチ'),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() => _winningScore = value);
            }
          },
        ),
        DropdownButton<int>(
          value: _maxGames,
          items: [1, 3, 5].map((games) {
            return DropdownMenuItem(
              value: games,
              child: Text('$games ゲーム制'),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() => _maxGames = value);
            }
          },
        ),
      ],
    );
  }

  /// コートへ進むボタン
  Widget _buildStartButton() {
    return ElevatedButton(
      onPressed: _startMatch,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 56),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      child: const Text(
        'コートへ進む',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTeamInputSection(
    String title,
    TextEditingController controller,
    Color bgColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'コピーで一括登録可\n（カンマまたは改行区切り）',
            style: TextStyle(fontSize: 11, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: TextField(
              controller: controller,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              decoration: const InputDecoration(
                hintText: '例:\n田中 花子\n鈴木 美紀',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── 上部: 試合設定3項目 ──
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _buildSettingsControls(),
              ),
              const SizedBox(height: 12),
              // ── 中央: 両陣営入力欄（画面の大半を占める）──
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: _buildTeamInputSection(
                        '左陣営 (Aチーム)',
                        _teamAController,
                        Colors.red.shade100,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildTeamInputSection(
                        '右陣営 (Bチーム)',
                        _teamBController,
                        Colors.blue.shade100,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // ── 下部: コートへ進むボタン ──
              _buildStartButton(),
            ],
          ),
        ),
      ),
    );
  }
}
