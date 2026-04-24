// D:\badminton_score\lib\utils\pdf_generator.dart

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/models.dart';

class PdfGenerator {
  // メモリ枯渇（OOM）を防ぐための静的フォントキャッシュ
  static pw.Font? _cachedRegularFont;
  static pw.Font? _cachedBoldFont;

  /// フォントを安全にロードし、メモリにキャッシュする
  static Future<void> _loadFontsIfNeeded() async {
    // 既にキャッシュされていればロード処理をスキップ
    if (_cachedRegularFont != null && _cachedBoldFont != null) {
      return;
    }

    try {
      // メモリ制限が厳しいiOS向けに、直列（await）で1つずつ確実にロードする
      final regularData = await rootBundle.load(
        'assets/fonts/NotoSansJP-Regular.ttf',
      );
      _cachedRegularFont = pw.Font.ttf(regularData);

      final boldData = await rootBundle.load(
        'assets/fonts/NotoSansJP-Bold.ttf',
      );
      _cachedBoldFont = pw.Font.ttf(boldData);
    } catch (e) {
      throw Exception(
        'フォントの読み込みに失敗しました。\n'
        'PWAの初期データ保存が完了する前にオフラインになった可能性があります。\n'
        '一度通信環境下でアプリを開き直し、数秒待ってから再度お試しください。',
      );
    }
  }

  /// 試合履歴データからPDFを生成し、ダウンロード/共有処理を実行する
  static Future<void> generateAndDownloadScoreSheet(
    MatchHistory history,
  ) async {
    final pdf = pw.Document();

    // 1. 日本語フォントの読み込み (キャッシュを利用)
    await _loadFontsIfNeeded();
    final pw.Font font = _cachedRegularFont!;
    final pw.Font fontBold = _cachedBoldFont!;

    // 2. 日付・時刻・所要時間の計算
    final startTime = history.startTime ?? DateTime.now();
    final endTime = DateTime.now(); // PDF出力ボタンを押した瞬間の時刻
    final duration = endTime.difference(startTime).inMinutes;

    final dateStr =
        '${startTime.year}/${startTime.month.toString().padLeft(2, '0')}/${startTime.day.toString().padLeft(2, '0')}';
    final timeStr =
        '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')} - '
        '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')} '
        '($duration分)';

    // 3. 有効な履歴の抽出（Undoで消えた未来を除外）
    final validStates = history.states.sublist(0, history.currentIndex + 1);
    final firstState = validStates.isNotEmpty
        ? validStates.first
        : const MatchState(currentServeTeam: TeamType.teamA, positions: {});
    final lastState = validStates.isNotEmpty
        ? validStates.last
        : const MatchState(currentServeTeam: TeamType.teamA, positions: {});

    // 4. 履歴をゲームごとに正確に分割
    List<List<MatchState>> gamesHistory = _splitHistoryByGames(validStates);

    // 5. PDFページの構築 (A4横向き)
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(24),
        theme: pw.ThemeData.withFont(base: font, bold: fontBold),
        // ★ フッターを指定（改ページしても一番下に配置される）
        footer: (pw.Context context) {
          return pw.Container(
            margin: const pw.EdgeInsets.only(top: 12),
            child: _buildFooter(),
          );
        },
        build: (pw.Context context) {
          return [
            // ★ 新しくなったヘッダー（サマリー表と時刻入り）
            _buildHeader(dateStr, timeStr, gamesHistory, firstState, lastState),
            pw.SizedBox(height: 12),

            // 設定されたゲーム数（1, 3, 5）に応じてループ
            ...List.generate(history.settings.maxGames, (index) {
              return pw.Column(
                children: [
                  _buildGameSection(
                    index + 1,
                    index < gamesHistory.length ? gamesHistory[index] : [],
                    history.settings,
                  ),
                  pw.SizedBox(height: 12),
                ],
              );
            }),
          ];
        },
      ),
    );

    // 6. 保存とダウンロード
    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'バドミントンスコアシート.pdf',
    );
  }

  /// 得点が0-0に戻った瞬間を境界としてリストを分割する（21点目を確実に含めるロジック）
  static List<List<MatchState>> _splitHistoryByGames(List<MatchState> states) {
    if (states.isEmpty) {
      return [];
    }

    List<List<MatchState>> games = [];
    List<MatchState> current = [];
    bool gameHasScored = false;

    for (var state in states) {
      if (state.scoreTeamA == 0 && state.scoreTeamB == 0) {
        // 得点が入った後に0-0が来た場合、前のゲームが終了し新しいゲームが始まったと判定
        if (gameHasScored) {
          games.add(List.from(current));
          current = [];
          gameHasScored = false;
        }
      } else {
        // 1点でも入ったらフラグを立てる
        gameHasScored = true;
      }
      current.add(state);
    }

    if (current.isNotEmpty) {
      games.add(current);
    }

    return games;
  }

  /// スコアシート上部の情報欄（大会名、サマリー表、時刻情報）
  static pw.Widget _buildHeader(
    String dateStr,
    String timeStr,
    List<List<MatchState>> gamesHistory,
    MatchState firstState,
    MatchState lastState,
  ) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // 左側: 大会情報など
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'バドミントン スコアシート',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 6),
              pw.Wrap(
                spacing: 0,
                runSpacing: 4,
                children: [
                  _blankBox('大会名 / 種目', 180),
                  _blankBox('日付', 80, value: dateStr), // 日付を自動印字
                  _blankBox('コート', 40),
                  _blankBox('試合番号', 60),
                ],
              ),
            ],
          ),
        ),

        // 中央: マッチサマリー表（公式レイアウト）
        _buildMatchSummary(gamesHistory, firstState, lastState),

        // 右側: クレジットと時刻情報
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                'badminton score sheet by Kasai',
                style: const pw.TextStyle(fontSize: 8),
              ),
              pw.SizedBox(height: 6),
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: pw.BoxDecoration(border: pw.Border.all(width: 0.5)),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text('試合時間', style: const pw.TextStyle(fontSize: 8)),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      timeStr,
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 上部中央の勝敗・スコアサマリー表を生成する
  static pw.Widget _buildMatchSummary(
    List<List<MatchState>> gamesHistory,
    MatchState firstState,
    MatchState lastState,
  ) {
    // 初期状態から選手名を抽出
    final teamAPlayers = _getTeamPlayerNames(TeamType.teamA, firstState);
    final teamBPlayers = _getTeamPlayerNames(TeamType.teamB, firstState);

    final pA = teamAPlayers.isNotEmpty ? teamAPlayers[0] : '';
    final pB = teamAPlayers.length > 1 ? teamAPlayers[1] : '';
    final pC = teamBPlayers.isNotEmpty ? teamBPlayers[0] : '';
    final pD = teamBPlayers.length > 1 ? teamBPlayers[1] : '';

    // 取得したゲーム数（状態モデルから安全に取得）
    final teamAWins = lastState.gameScoreA;
    final teamBWins = lastState.gameScoreB;

    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: pw.Row(
        mainAxisSize: pw.MainAxisSize.min,
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          // 左側: Team A 選手名と取得ゲーム数
          pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              if (pA.isNotEmpty)
                pw.Text(pA, style: const pw.TextStyle(fontSize: 10)),
              pw.SizedBox(height: 2),
              pw.Text(
                teamAWins.toString(),
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 2),
              if (pB.isNotEmpty)
                pw.Text(pB, style: const pw.TextStyle(fontSize: 10)),
            ],
          ),
          pw.SizedBox(width: 8),

          // 中央: 各ゲームのスコア（縦に並べる）
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                left: pw.BorderSide(width: 0.5),
                right: pw.BorderSide(width: 0.5),
              ),
            ),
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: gamesHistory.map((game) {
                final last = game.isNotEmpty
                    ? game.last
                    : const MatchState(
                        currentServeTeam: TeamType.teamA,
                        positions: {},
                      );
                return pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 1),
                  child: pw.Text(
                    '${last.scoreTeamA} - ${last.scoreTeamB}',
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          pw.SizedBox(width: 8),

          // 右側: Team B 取得ゲーム数と選手名
          pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              if (pC.isNotEmpty)
                pw.Text(pC, style: const pw.TextStyle(fontSize: 10)),
              pw.SizedBox(height: 2),
              pw.Text(
                teamBWins.toString(),
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 2),
              if (pD.isNotEmpty)
                pw.Text(pD, style: const pw.TextStyle(fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }

  /// サマリー表示用に、初期状態からチームごとの選手名リストを抽出するヘルパー
  static List<String> _getTeamPlayerNames(
    TeamType team,
    MatchState startState,
  ) {
    bool isTeamALeft = startState.leftSideTeam == TeamType.teamA;
    bool isThisTeamLeft = (team == TeamType.teamA) == isTeamALeft;

    final quads = isThisTeamLeft
        ? [CourtQuadrant.bottomLeft, CourtQuadrant.topLeft]
        : [CourtQuadrant.topRight, CourtQuadrant.bottomRight];

    List<String> names = [];
    for (var q in quads) {
      if (startState.positions[q] != null &&
          startState.positions[q]!.name.isNotEmpty) {
        names.add(startState.positions[q]!.name);
      }
    }
    return names;
  }

  /// シート下部のフッター（署名欄）
  static pw.Widget _buildFooter() {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      children: [
        _blankBox('勝者署名', 150),
        _blankBox('主審署名', 150),
        _blankBox('サービスジャッジ署名', 150),
      ],
    );
  }

  /// 下線付きの記入欄ウィジェット（valueが渡された場合は上にテキストを印字する）
  static pw.Widget _blankBox(String label, double width, {String? value}) {
    return pw.Container(
      width: width,
      margin: const pw.EdgeInsets.only(right: 12),
      decoration: const pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(width: 0.5)),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Text('$label: ', style: const pw.TextStyle(fontSize: 9)),
          if (value != null)
            pw.Padding(
              padding: const pw.EdgeInsets.only(left: 4),
              child: pw.Text(value, style: const pw.TextStyle(fontSize: 10)),
            ),
        ],
      ),
    );
  }

  /// ゲームごとのスコア表
  static pw.Widget _buildGameSection(
    int gameNum,
    List<MatchState> states,
    MatchSettings settings,
  ) {
    // 延長戦を考慮した最大マス数 (インデックス0〜54。55ラリー分)
    const int maxCols = 55;

    // ★ 列幅を公式寄りの指定サイズに変更
    final Map<int, pw.TableColumnWidth> colWidths = {
      0: const pw.FixedColumnWidth(40), // チーム名を28→40に変更
      1: const pw.FixedColumnWidth(63), // 選手名を75→63に変更
      2: const pw.FixedColumnWidth(14), // S/R
    };
    // 得点マス（幅を12に縮小し、数を増やす）
    for (int i = 0; i < maxCols; i++) {
      colWidths[i + 3] = const pw.FixedColumnWidth(12);
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          '第 $gameNum ゲーム',
          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
        ),
        pw.Table(
          border: pw.TableBorder.all(width: 0.5),
          columnWidths: colWidths,
          children: [
            ..._buildTeamRows(
              TeamType.teamA,
              states,
              settings.isDoubles,
              maxCols,
            ),
            ..._buildTeamRows(
              TeamType.teamB,
              states,
              settings.isDoubles,
              maxCols,
            ),
          ],
        ),
      ],
    );
  }

  /// チームの各選手の行を生成
  static List<pw.TableRow> _buildTeamRows(
    TeamType team,
    List<MatchState> states,
    bool isDoubles,
    int maxCols,
  ) {
    final List<pw.TableRow> rows = [];
    final int playerCount = isDoubles ? 2 : 1;

    // 1ポイント目が入る直前（一番最後の0-0の状態）を初期状態として定義する
    final startState = states.isNotEmpty
        ? states.lastWhere(
            (s) => s.scoreTeamA == 0 && s.scoreTeamB == 0,
            orElse: () => states.first,
          )
        : const MatchState(currentServeTeam: TeamType.teamA, positions: {});

    List<Player> players = [];
    if (states.isNotEmpty) {
      bool isTeamALeft = startState.leftSideTeam == TeamType.teamA;
      bool isThisTeamLeft = (team == TeamType.teamA) == isTeamALeft;

      final quads = isThisTeamLeft
          ? [CourtQuadrant.bottomLeft, CourtQuadrant.topLeft]
          : [CourtQuadrant.topRight, CourtQuadrant.bottomRight];

      for (var q in quads) {
        if (startState.positions[q] != null) {
          players.add(startState.positions[q]!);
        }
      }
    }

    while (players.length < playerCount) {
      players.add(const Player(id: '', name: ''));
    }

    for (int pIdx = 0; pIdx < playerCount; pIdx++) {
      final player = players[pIdx];

      final List<String> scoreRow = List.filled(maxCols, '');
      String srMark = '';

      if (states.isNotEmpty && player.id.isNotEmpty) {
        // startStateを渡して、正確な初期S/Rとスコアをマッピングする
        srMark = _getInitialSRMark(startState, player.id);
        _mapPointsToRow(scoreRow, states, team, player.id, startState);
      }

      List<pw.Widget> rowCells = [
        _cell(
          pIdx == 0 ? (team == TeamType.teamA ? 'Team A' : 'Team B') : '',
          fontSize: 8,
        ),
        _cell(player.name, fontSize: 8),
        _cell(srMark, fontSize: 8), // 独立したS/R列
      ];

      for (int i = 0; i < scoreRow.length; i++) {
        rowCells.add(_cell(scoreRow[i], width: 12)); // 幅12の得点マス
      }

      rows.add(pw.TableRow(children: rowCells));
    }
    return rows;
  }

  /// 初期状態におけるS/Rの判定
  static String _getInitialSRMark(MatchState startState, String playerId) {
    if (startState.serverId == playerId) {
      return 'S';
    } else if (startState.receiverId == playerId) {
      return 'R';
    }
    return '';
  }

  /// 公式ルールに則り、「0」の初期化と全得点の階段状マッピングを行う純粋関数
  static void _mapPointsToRow(
    List<String> row,
    List<MatchState> states,
    TeamType team,
    String playerId,
    MatchState startState,
  ) {
    // 試合開始時、サーバーとレシーバーの0列目に「0」を記入
    if (startState.serverId == playerId || startState.receiverId == playerId) {
      if (row.isNotEmpty) {
        row[0] = '0';
      }
    }

    int currentCol = 0; // 現在の書き込み対象は「0列目」

    for (int i = 1; i < states.length; i++) {
      final prev = states[i - 1];
      final curr = states[i];

      // スコアが変動していない（設定中やUndo）場合は無視
      if (curr.scoreTeamA == prev.scoreTeamA &&
          curr.scoreTeamB == prev.scoreTeamB) {
        continue;
      }

      // 得点が動いたので、必ず列（Column）を右に1つ進める
      currentCol++;

      if (currentCol >= row.length) {
        break; // 配列の境界を超えないよう保護
      }

      // そのラリーを制して「新しくサーバーになった人（キープ含む）」の行に得点を記入
      if (curr.serverId == playerId) {
        int score = (team == TeamType.teamA)
            ? curr.scoreTeamA
            : curr.scoreTeamB;
        row[currentCol] = score.toString();

        // 21点到達時（ゲーム終了時）は、最後の得点を括弧で囲む
        if (curr.isWaitingForNextGame || curr.isMatchOver) {
          row[currentCol] = '($score)';
        }
      }
    }
  }

  static pw.Widget _cell(String text, {double fontSize = 9, double? width}) {
    return pw.Container(
      width: width,
      height: 16,
      alignment: pw.Alignment.center,
      child: pw.Text(text, style: pw.TextStyle(fontSize: fontSize)),
    );
  }
}
