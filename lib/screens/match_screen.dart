// D:\badminton_score\lib\screens\match_screen.dart

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
    if (state == null || state.isMatchOver || !state.isMatchStarted) return;

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
    if (state == null) return;

    if (state.isMatchOver) {
      _showMatchOverDialog();
    } else if (state.isWaitingForNextGame) {
      _showIntervalDialog();
    }
  }

  Future<void> _showMatchOverDialog() async {
    final state = widget.controller.currentState;
    if (state == null) return;

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
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('PDFの生成に失敗しました: $e')));
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
    if (state == null || state.isMatchStarted) return;

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
            final displayGameNumber = totalGames <= settings.maxGames
                ? totalGames
                : settings.maxGames;

            final leftTeam = state.leftSideTeam;
            final rightTeam = leftTeam == TeamType.teamA
                ? TeamType.teamB
                : TeamType.teamA;

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

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.undo,
                                  color: Colors.white,
                                ),
                                iconSize: 48,
                                onPressed: widget.controller.canUndo
                                    ? () {
                                        widget.controller.undo();
                                      }
                                    : null,
                                tooltip: '戻る',
                              ),
                              const Text(
                                '戻る',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.redo,
                                  color: Colors.white,
                                ),
                                iconSize: 48,
                                onPressed: widget.controller.canRedo
                                    ? () {
                                        widget.controller.redo();
                                        _checkMatchStatus();
                                      }
                                    : null,
                                tooltip: '進む',
                              ),
                              const Text(
                                '進む',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RegistrationScreen(
                                controller: widget.controller,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.exit_to_app, color: Colors.red),
                        label: const Text(
                          '試合を終了して戻る',
                          style: TextStyle(color: Colors.red),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                Text(
                  '$leftScore - $rightScore',
                  style: const TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.0,
                  ),
                ),
                Text(
                  '第$displayGameNumberゲーム / ${settings.maxGames}ゲーム制  (ゲームカウント: $leftGameScore - $rightGameScore)',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.yellowAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Expanded(child: _buildCourt(state, settings)),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: state.isMatchStarted
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildScoreButton(
                              '左側 得点',
                              Colors.red,
                              () => _handleScore(leftTeam, true),
                            ),
                            _buildScoreButton(
                              '右側 得点',
                              Colors.blue,
                              () => _handleScore(rightTeam, false),
                            ),
                          ],
                        )
                      : ElevatedButton(
                          onPressed: () => widget.controller.startMatch(),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 48,
                              vertical: 16,
                            ),
                            backgroundColor: Colors.orange,
                          ),
                          child: const Text(
                            '試合再開 (配置を確定)',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildScoreButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildCourt(MatchState state, MatchSettings settings) {
    final isFirstGame = (state.gameScoreA + state.gameScoreB) == 0;

    return Center(
      child: AspectRatio(
        aspectRatio: 2.0,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: const Color(0xFF1B5E20),
            border: Border.all(color: Colors.white, width: 4),
          ),
          child: Stack(
            children: [
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
        ),
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

    // 第1ゲームの初期サーバー指定は右側コート（偶数）のみ許可
    final canBeInitialServer =
        isFirstGame &&
        (quad == CourtQuadrant.bottomLeft || quad == CourtQuadrant.topRight);

    // ★修正箇所：三項演算子のネストをやめ、安全にウィジェットを代入する堅牢な書き方に変更
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
