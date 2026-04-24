// lib/screens/match_screen.dart

import 'package:flutter/material.dart';
import '../models/models.dart';
import '../controllers/match_controller.dart';
import '../utils/pdf_generator.dart';
import 'registration_screen.dart';

class MatchScreen extends StatefulWidget {
  final MatchController controller;

  const MatchScreen({super.key, required this.controller});

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  DateTime _lastTapTimeLeft = DateTime.fromMillisecondsSinceEpoch(0);
  DateTime _lastTapTimeRight = DateTime.fromMillisecondsSinceEpoch(0);
  static const int _debounceDelayMs = 500;

  void _handleScore(TeamType scoringTeam, bool isLeftTap) {
    final state = widget.controller.currentState;
    if (state == null || state.isMatchOver || !state.isMatchStarted) {
      return;
    }

    final now = DateTime.now();
    if (isLeftTap) {
      if (now.difference(_lastTapTimeLeft).inMilliseconds < _debounceDelayMs) {
        return;
      }
      _lastTapTimeLeft = now;
    } else {
      if (now.difference(_lastTapTimeRight).inMilliseconds < _debounceDelayMs) {
        return;
      }
      _lastTapTimeRight = now;
    }

    widget.controller.addScore(scoringTeam);
    _checkMatchStatus();
  }

  void _checkMatchStatus() {
    final state = widget.controller.currentState;
    if (state == null) {
      return;
    }

    if (state.isMatchOver) {
      _showMatchOverDialog();
    } else if (state.isWaitingForNextGame) {
      _showIntervalDialog();
    }
  }

  Future<void> _showMatchOverDialog() async {
    final state = widget.controller.currentState;
    if (state == null) {
      return;
    }

    final isTeamAWinner = state.gameScoreA > state.gameScoreB;
    final winningTeam = isTeamAWinner ? TeamType.teamA : TeamType.teamB;
    final winnerText = winningTeam == state.leftSideTeam ? "左側陣営" : "右側陣営";

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('試合終了！'),
        content: Text(
          '$winnerTextの勝利です。\n\n最終ゲームカウント: ${state.gameScoreA} - ${state.gameScoreB}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('閉じる'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await PdfGenerator.generateAndDownloadScoreSheet(
                  widget.controller.history,
                );
                if (context.mounted) {
                  Navigator.pop(context);
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('PDFの生成に失敗しました: $e')),
                  );
                }
              }
            },
            child: const Text('スコアシート(PDF)を出力'),
          ),
        ],
      ),
    );
  }

  Future<void> _showIntervalDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('ゲーム終了'),
        content: const Text('コートチェンジを行いますか？\n（次のゲームの準備をします）'),
        actions: [
          TextButton(
            onPressed: () {
              widget.controller.startNextGame(changeEnds: false);
              Navigator.pop(context);
            },
            child: const Text('チェンジしない'),
          ),
          ElevatedButton(
            onPressed: () {
              widget.controller.startNextGame(changeEnds: true);
              Navigator.pop(context);
            },
            child: const Text('コートチェンジする'),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditNameDialog(Player player) async {
    final state = widget.controller.currentState;
    if (state == null || state.isMatchStarted) {
      return;
    }

    final textController = TextEditingController(text: player.name);
    final newName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('選手名の編集'),
        content: TextField(
          controller: textController,
          autofocus: true,
          decoration: const InputDecoration(hintText: '名前を入力'),
          onSubmitted: (value) => Navigator.pop(context, value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, textController.text),
            child: const Text('保存'),
          ),
        ],
      ),
    );

    if (newName != null && newName.isNotEmpty) {
      widget.controller.updatePlayerName(player.id, newName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade800,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: widget.controller,
          builder: (context, _) {
            final state = widget.controller.currentState;
            if (state == null) {
              return const Center(child: CircularProgressIndicator());
            }

            final settings = widget.controller.history.settings;
            final totalGames = state.gameScoreA + state.gameScoreB + 1;
            final displayGameNumber =
                totalGames <= settings.maxGames ? totalGames : settings.maxGames;

            final leftTeam = state.leftSideTeam;
            final rightTeam =
                leftTeam == TeamType.teamA ? TeamType.teamB : TeamType.teamA;

            final leftScore = leftTeam == TeamType.teamA
                ? state.scoreTeamA
                : state.scoreTeamB;
            final rightScore = leftTeam == TeamType.teamA
                ? state.scoreTeamB
                : state.scoreTeamA;

            final leftGameScore = leftTeam == TeamType.teamA
                ? state.gameScoreA
                : state.gameScoreB;
            final rightGameScore = leftTeam == TeamType.teamA
                ? state.gameScoreB
                : state.gameScoreA;

            return LayoutBuilder(
              builder: (context, constraints) {
                final isLandscape =
                    constraints.maxWidth > constraints.maxHeight;

                return _buildLayout(
                  state: state,
                  settings: settings,
                  leftTeam: leftTeam,
                  rightTeam: rightTeam,
                  leftScore: leftScore,
                  rightScore: rightScore,
                  leftGameScore: leftGameScore,
                  rightGameScore: rightGameScore,
                  displayGameNumber: displayGameNumber,
                  isLandscape: isLandscape,
                );
              },
            );
          },
        ),
      ),
    );
  }

  /// 縦/横共通レイアウト
  /// コートを最大化するため、ヘッダーを1行にコンパクト化する
  Widget _buildLayout({
    required MatchState state,
    required MatchSettings settings,
    required TeamType leftTeam,
    required TeamType rightTeam,
    required int leftScore,
    required int rightScore,
    required int leftGameScore,
    required int rightGameScore,
    required int displayGameNumber,
    required bool isLandscape,
  }) {
    // 縦横でスコア文字サイズのみ変える
    final double scoreFontSize = isLandscape ? 40.0 : 64.0;
    final double gameInfoFontSize = isLandscape ? 11.0 : 14.0;
    final double iconSize = isLandscape ? 28.0 : 36.0;

    return Column(
      children: [
        // ── ヘッダー（1行・コンパクト）──
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
          child: Row(
            children: [
              // ← 戻るボタン
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                iconSize: iconSize,
                onPressed: widget.controller.canUndo
                    ? () => widget.controller.undo()
                    : null,
                tooltip: '戻る',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 4),
              // → 進むボタン
              IconButton(
                icon: const Icon(Icons.arrow_forward, color: Colors.white),
                iconSize: iconSize,
                onPressed: widget.controller.canRedo
                    ? () {
                        widget.controller.redo();
                        _checkMatchStatus();
                      }
                    : null,
                tooltip: '進む',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 8),
              // スコア・ゲーム情報（中央・Expanded）
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$leftScore  -  $rightScore',
                      style: TextStyle(
                        fontSize: scoreFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.0,
                      ),
                    ),
                    Text(
                      '第${displayGameNumber}G / ${settings.maxGames}G制'
                      '  ($leftGameScore - $rightGameScore)',
                      style: TextStyle(
                        fontSize: gameInfoFontSize,
                        color: Colors.yellowAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // 終了ボタン
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          RegistrationScreen(controller: widget.controller),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.exit_to_app,
                  color: Colors.red,
                  size: 16,
                ),
                label: const Text(
                  '終了',
                  style: TextStyle(color: Colors.red, fontSize: 13),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ),
        // ── コート（最大化）──
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
            child: _buildCourt(state, settings),
          ),
        ),
        // ── 得点ボタン / 試合開始ボタン ──
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: isLandscape ? 4.0 : 12.0,
          ),
          child: state.isMatchStarted
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildScoreButton(
                      '左側 得点',
                      Colors.red,
                      () => _handleScore(leftTeam, true),
                      small: isLandscape,
                    ),
                    _buildScoreButton(
                      '右側 得点',
                      Colors.blue,
                      () => _handleScore(rightTeam, false),
                      small: isLandscape,
                    ),
                  ],
                )
              : ElevatedButton(
                  onPressed: () => widget.controller.startMatch(),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: isLandscape ? 8 : 16,
                    ),
                    backgroundColor: Colors.orange,
                  ),
                  child: Text(
                    '試合開始 (配置を確定)',
                    style: TextStyle(
                      fontSize: isLandscape ? 18 : 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildScoreButton(
    String text,
    Color color,
    VoidCallback onPressed, {
    bool small = false,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(
          horizontal: small ? 24 : 40,
          vertical: small ? 10 : 22,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: small ? 18 : 26,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  /// コートウィジェット（AspectRatio廃止・親のExpandedに従って最大化）
  Widget _buildCourt(MatchState state, MatchSettings settings) {
    final isFirstGame = (state.gameScoreA + state.gameScoreB) == 0;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1B5E20),
        border: Border.all(color: Colors.white, width: 4),
      ),
      child: Stack(
        children: [
          // コートのライン描画
          Positioned.fill(
            child: Row(
              children: [
                Expanded(flex: 7, child: Container()),
                Container(width: 2, color: Colors.white70),
                Expanded(flex: 3, child: Container()),
                Container(width: 4, color: Colors.white),
                Expanded(flex: 3, child: Container()),
                Container(width: 2, color: Colors.white70),
                Expanded(flex: 7, child: Container()),
              ],
            ),
          ),
          // 4象限
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: _buildQuadrant(
                        CourtQuadrant.topLeft,
                        state,
                        isFirstGame,
                      ),
                    ),
                    const Divider(
                      color: Colors.white,
                      height: 4,
                      thickness: 4,
                    ),
                    Expanded(
                      child: _buildQuadrant(
                        CourtQuadrant.bottomLeft,
                        state,
                        isFirstGame,
                      ),
                    ),
                  ],
                ),
              ),
              Container(width: 8),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: _buildQuadrant(
                        CourtQuadrant.topRight,
                        state,
                        isFirstGame,
                      ),
                    ),
                    const Divider(
                      color: Colors.white,
                      height: 4,
                      thickness: 4,
                    ),
                    Expanded(
                      child: _buildQuadrant(
                        CourtQuadrant.bottomRight,
                        state,
                        isFirstGame,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // ダブルスのポジション入れ替えボタン（試合開始前のみ）
          if (!state.isMatchStarted && settings.isDoubles) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(
                  Icons.swap_vert,
                  color: Colors.white,
                  size: 64,
                ),
                onPressed: () =>
                    widget.controller.swapInitialPositions(true),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(
                  Icons.swap_vert,
                  color: Colors.white,
                  size: 64,
                ),
                onPressed: () =>
                    widget.controller.swapInitialPositions(false),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuadrant(
    CourtQuadrant quad,
    MatchState state,
    bool isFirstGame,
  ) {
    final player = state.positions[quad];
    final isServer = player?.id == state.serverId;
    final isSetup = !state.isMatchStarted;

    final canBeInitialServer =
        isFirstGame &&
        (quad == CourtQuadrant.bottomLeft || quad == CourtQuadrant.topRight);

    Widget content;
    if (player == null) {
      content = const SizedBox();
    } else {
      content = Center(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isSetup
                ? () {
                    _showEditNameDialog(player);
                  }
                : null,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSetup ? Colors.black45 : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: isSetup && isFirstGame
                    ? Border.all(color: Colors.white70, width: 2)
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isServer) ...[
                    const PureShuttleIcon(),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    player.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: (isSetup && canBeInitialServer)
          ? () => widget.controller.setInitialServer(quad)
          : null,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white24, width: 1),
        ),
        child: content,
      ),
    );
  }
}

class PureShuttleIcon extends StatelessWidget {
  const PureShuttleIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: CustomPaint(painter: _ShuttlePainter()),
    );
  }
}

class _ShuttlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.yellowAccent
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final corkRect = Rect.fromLTWH(
      size.width * 0.3,
      size.height * 0.6,
      size.width * 0.4,
      size.height * 0.4,
    );
    canvas.drawArc(corkRect, 0, 3.14, true, paint);

    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.6),
      Offset(size.width * 0.2, size.height * 0.1),
      strokePaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.6),
      Offset(size.width * 0.5, size.height * 0.05),
      strokePaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.6),
      Offset(size.width * 0.8, size.height * 0.1),
      strokePaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.3, size.height * 0.35),
      Offset(size.width * 0.7, size.height * 0.35),
      strokePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
