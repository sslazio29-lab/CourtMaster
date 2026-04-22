// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Player _$PlayerFromJson(Map<String, dynamic> json) =>
    _Player(id: json['id'] as String, name: json['name'] as String);

Map<String, dynamic> _$PlayerToJson(_Player instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
};

_MatchState _$MatchStateFromJson(Map<String, dynamic> json) => _MatchState(
  scoreTeamA: (json['scoreTeamA'] as num?)?.toInt() ?? 0,
  scoreTeamB: (json['scoreTeamB'] as num?)?.toInt() ?? 0,
  gameScoreA: (json['gameScoreA'] as num?)?.toInt() ?? 0,
  gameScoreB: (json['gameScoreB'] as num?)?.toInt() ?? 0,
  currentServeTeam: $enumDecode(_$TeamTypeEnumMap, json['currentServeTeam']),
  positions: (json['positions'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(
      $enumDecode(_$CourtQuadrantEnumMap, k),
      Player.fromJson(e as Map<String, dynamic>),
    ),
  ),
  serverId: json['serverId'] as String?,
  receiverId: json['receiverId'] as String?,
  isMatchOver: json['isMatchOver'] as bool? ?? false,
  isMatchStarted: json['isMatchStarted'] as bool? ?? false,
  leftSideTeam:
      $enumDecodeNullable(_$TeamTypeEnumMap, json['leftSideTeam']) ??
      TeamType.teamA,
  isWaitingForNextGame: json['isWaitingForNextGame'] as bool? ?? false,
  selectedPlayerId: json['selectedPlayerId'] as String?,
);

Map<String, dynamic> _$MatchStateToJson(_MatchState instance) =>
    <String, dynamic>{
      'scoreTeamA': instance.scoreTeamA,
      'scoreTeamB': instance.scoreTeamB,
      'gameScoreA': instance.gameScoreA,
      'gameScoreB': instance.gameScoreB,
      'currentServeTeam': _$TeamTypeEnumMap[instance.currentServeTeam]!,
      'positions': instance.positions.map(
        (k, e) => MapEntry(_$CourtQuadrantEnumMap[k]!, e),
      ),
      'serverId': instance.serverId,
      'receiverId': instance.receiverId,
      'isMatchOver': instance.isMatchOver,
      'isMatchStarted': instance.isMatchStarted,
      'leftSideTeam': _$TeamTypeEnumMap[instance.leftSideTeam]!,
      'isWaitingForNextGame': instance.isWaitingForNextGame,
      'selectedPlayerId': instance.selectedPlayerId,
    };

const _$TeamTypeEnumMap = {TeamType.teamA: 'teamA', TeamType.teamB: 'teamB'};

const _$CourtQuadrantEnumMap = {
  CourtQuadrant.topLeft: 'topLeft',
  CourtQuadrant.bottomLeft: 'bottomLeft',
  CourtQuadrant.topRight: 'topRight',
  CourtQuadrant.bottomRight: 'bottomRight',
};

_MatchSettings _$MatchSettingsFromJson(Map<String, dynamic> json) =>
    _MatchSettings(
      isDoubles: json['isDoubles'] as bool? ?? true,
      winningScore: (json['winningScore'] as num?)?.toInt() ?? 21,
      maxGames: (json['maxGames'] as num?)?.toInt() ?? 3,
    );

Map<String, dynamic> _$MatchSettingsToJson(_MatchSettings instance) =>
    <String, dynamic>{
      'isDoubles': instance.isDoubles,
      'winningScore': instance.winningScore,
      'maxGames': instance.maxGames,
    };

_MatchHistory _$MatchHistoryFromJson(Map<String, dynamic> json) =>
    _MatchHistory(
      states:
          (json['states'] as List<dynamic>?)
              ?.map((e) => MatchState.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      currentIndex: (json['currentIndex'] as num?)?.toInt() ?? 0,
      settings: MatchSettings.fromJson(
        json['settings'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$MatchHistoryToJson(_MatchHistory instance) =>
    <String, dynamic>{
      'states': instance.states,
      'currentIndex': instance.currentIndex,
      'settings': instance.settings,
    };
