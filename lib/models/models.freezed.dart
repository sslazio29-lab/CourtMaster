// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Player {

 String get id; String get name;
/// Create a copy of Player
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerCopyWith<Player> get copyWith => _$PlayerCopyWithImpl<Player>(this as Player, _$identity);

  /// Serializes this Player to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Player&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'Player(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $PlayerCopyWith<$Res>  {
  factory $PlayerCopyWith(Player value, $Res Function(Player) _then) = _$PlayerCopyWithImpl;
@useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class _$PlayerCopyWithImpl<$Res>
    implements $PlayerCopyWith<$Res> {
  _$PlayerCopyWithImpl(this._self, this._then);

  final Player _self;
  final $Res Function(Player) _then;

/// Create a copy of Player
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Player].
extension PlayerPatterns on Player {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Player value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Player() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Player value)  $default,){
final _that = this;
switch (_that) {
case _Player():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Player value)?  $default,){
final _that = this;
switch (_that) {
case _Player() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Player() when $default != null:
return $default(_that.id,_that.name);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name)  $default,) {final _that = this;
switch (_that) {
case _Player():
return $default(_that.id,_that.name);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name)?  $default,) {final _that = this;
switch (_that) {
case _Player() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Player implements Player {
  const _Player({required this.id, required this.name});
  factory _Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);

@override final  String id;
@override final  String name;

/// Create a copy of Player
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayerCopyWith<_Player> get copyWith => __$PlayerCopyWithImpl<_Player>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlayerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Player&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'Player(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$PlayerCopyWith<$Res> implements $PlayerCopyWith<$Res> {
  factory _$PlayerCopyWith(_Player value, $Res Function(_Player) _then) = __$PlayerCopyWithImpl;
@override @useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class __$PlayerCopyWithImpl<$Res>
    implements _$PlayerCopyWith<$Res> {
  __$PlayerCopyWithImpl(this._self, this._then);

  final _Player _self;
  final $Res Function(_Player) _then;

/// Create a copy of Player
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_Player(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$MatchState {

 int get scoreTeamA; int get scoreTeamB; int get gameScoreA; int get gameScoreB; TeamType get currentServeTeam; Map<CourtQuadrant, Player> get positions; String? get serverId; String? get receiverId; bool get isMatchOver; bool get isMatchStarted; TeamType get leftSideTeam; bool get isWaitingForNextGame;
/// Create a copy of MatchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MatchStateCopyWith<MatchState> get copyWith => _$MatchStateCopyWithImpl<MatchState>(this as MatchState, _$identity);

  /// Serializes this MatchState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MatchState&&(identical(other.scoreTeamA, scoreTeamA) || other.scoreTeamA == scoreTeamA)&&(identical(other.scoreTeamB, scoreTeamB) || other.scoreTeamB == scoreTeamB)&&(identical(other.gameScoreA, gameScoreA) || other.gameScoreA == gameScoreA)&&(identical(other.gameScoreB, gameScoreB) || other.gameScoreB == gameScoreB)&&(identical(other.currentServeTeam, currentServeTeam) || other.currentServeTeam == currentServeTeam)&&const DeepCollectionEquality().equals(other.positions, positions)&&(identical(other.serverId, serverId) || other.serverId == serverId)&&(identical(other.receiverId, receiverId) || other.receiverId == receiverId)&&(identical(other.isMatchOver, isMatchOver) || other.isMatchOver == isMatchOver)&&(identical(other.isMatchStarted, isMatchStarted) || other.isMatchStarted == isMatchStarted)&&(identical(other.leftSideTeam, leftSideTeam) || other.leftSideTeam == leftSideTeam)&&(identical(other.isWaitingForNextGame, isWaitingForNextGame) || other.isWaitingForNextGame == isWaitingForNextGame));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,scoreTeamA,scoreTeamB,gameScoreA,gameScoreB,currentServeTeam,const DeepCollectionEquality().hash(positions),serverId,receiverId,isMatchOver,isMatchStarted,leftSideTeam,isWaitingForNextGame);

@override
String toString() {
  return 'MatchState(scoreTeamA: $scoreTeamA, scoreTeamB: $scoreTeamB, gameScoreA: $gameScoreA, gameScoreB: $gameScoreB, currentServeTeam: $currentServeTeam, positions: $positions, serverId: $serverId, receiverId: $receiverId, isMatchOver: $isMatchOver, isMatchStarted: $isMatchStarted, leftSideTeam: $leftSideTeam, isWaitingForNextGame: $isWaitingForNextGame)';
}


}

/// @nodoc
abstract mixin class $MatchStateCopyWith<$Res>  {
  factory $MatchStateCopyWith(MatchState value, $Res Function(MatchState) _then) = _$MatchStateCopyWithImpl;
@useResult
$Res call({
 int scoreTeamA, int scoreTeamB, int gameScoreA, int gameScoreB, TeamType currentServeTeam, Map<CourtQuadrant, Player> positions, String? serverId, String? receiverId, bool isMatchOver, bool isMatchStarted, TeamType leftSideTeam, bool isWaitingForNextGame
});




}
/// @nodoc
class _$MatchStateCopyWithImpl<$Res>
    implements $MatchStateCopyWith<$Res> {
  _$MatchStateCopyWithImpl(this._self, this._then);

  final MatchState _self;
  final $Res Function(MatchState) _then;

/// Create a copy of MatchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? scoreTeamA = null,Object? scoreTeamB = null,Object? gameScoreA = null,Object? gameScoreB = null,Object? currentServeTeam = null,Object? positions = null,Object? serverId = freezed,Object? receiverId = freezed,Object? isMatchOver = null,Object? isMatchStarted = null,Object? leftSideTeam = null,Object? isWaitingForNextGame = null,}) {
  return _then(_self.copyWith(
scoreTeamA: null == scoreTeamA ? _self.scoreTeamA : scoreTeamA // ignore: cast_nullable_to_non_nullable
as int,scoreTeamB: null == scoreTeamB ? _self.scoreTeamB : scoreTeamB // ignore: cast_nullable_to_non_nullable
as int,gameScoreA: null == gameScoreA ? _self.gameScoreA : gameScoreA // ignore: cast_nullable_to_non_nullable
as int,gameScoreB: null == gameScoreB ? _self.gameScoreB : gameScoreB // ignore: cast_nullable_to_non_nullable
as int,currentServeTeam: null == currentServeTeam ? _self.currentServeTeam : currentServeTeam // ignore: cast_nullable_to_non_nullable
as TeamType,positions: null == positions ? _self.positions : positions // ignore: cast_nullable_to_non_nullable
as Map<CourtQuadrant, Player>,serverId: freezed == serverId ? _self.serverId : serverId // ignore: cast_nullable_to_non_nullable
as String?,receiverId: freezed == receiverId ? _self.receiverId : receiverId // ignore: cast_nullable_to_non_nullable
as String?,isMatchOver: null == isMatchOver ? _self.isMatchOver : isMatchOver // ignore: cast_nullable_to_non_nullable
as bool,isMatchStarted: null == isMatchStarted ? _self.isMatchStarted : isMatchStarted // ignore: cast_nullable_to_non_nullable
as bool,leftSideTeam: null == leftSideTeam ? _self.leftSideTeam : leftSideTeam // ignore: cast_nullable_to_non_nullable
as TeamType,isWaitingForNextGame: null == isWaitingForNextGame ? _self.isWaitingForNextGame : isWaitingForNextGame // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MatchState].
extension MatchStatePatterns on MatchState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MatchState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MatchState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MatchState value)  $default,){
final _that = this;
switch (_that) {
case _MatchState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MatchState value)?  $default,){
final _that = this;
switch (_that) {
case _MatchState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int scoreTeamA,  int scoreTeamB,  int gameScoreA,  int gameScoreB,  TeamType currentServeTeam,  Map<CourtQuadrant, Player> positions,  String? serverId,  String? receiverId,  bool isMatchOver,  bool isMatchStarted,  TeamType leftSideTeam,  bool isWaitingForNextGame)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MatchState() when $default != null:
return $default(_that.scoreTeamA,_that.scoreTeamB,_that.gameScoreA,_that.gameScoreB,_that.currentServeTeam,_that.positions,_that.serverId,_that.receiverId,_that.isMatchOver,_that.isMatchStarted,_that.leftSideTeam,_that.isWaitingForNextGame);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int scoreTeamA,  int scoreTeamB,  int gameScoreA,  int gameScoreB,  TeamType currentServeTeam,  Map<CourtQuadrant, Player> positions,  String? serverId,  String? receiverId,  bool isMatchOver,  bool isMatchStarted,  TeamType leftSideTeam,  bool isWaitingForNextGame)  $default,) {final _that = this;
switch (_that) {
case _MatchState():
return $default(_that.scoreTeamA,_that.scoreTeamB,_that.gameScoreA,_that.gameScoreB,_that.currentServeTeam,_that.positions,_that.serverId,_that.receiverId,_that.isMatchOver,_that.isMatchStarted,_that.leftSideTeam,_that.isWaitingForNextGame);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int scoreTeamA,  int scoreTeamB,  int gameScoreA,  int gameScoreB,  TeamType currentServeTeam,  Map<CourtQuadrant, Player> positions,  String? serverId,  String? receiverId,  bool isMatchOver,  bool isMatchStarted,  TeamType leftSideTeam,  bool isWaitingForNextGame)?  $default,) {final _that = this;
switch (_that) {
case _MatchState() when $default != null:
return $default(_that.scoreTeamA,_that.scoreTeamB,_that.gameScoreA,_that.gameScoreB,_that.currentServeTeam,_that.positions,_that.serverId,_that.receiverId,_that.isMatchOver,_that.isMatchStarted,_that.leftSideTeam,_that.isWaitingForNextGame);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MatchState implements MatchState {
  const _MatchState({this.scoreTeamA = 0, this.scoreTeamB = 0, this.gameScoreA = 0, this.gameScoreB = 0, required this.currentServeTeam, required final  Map<CourtQuadrant, Player> positions, this.serverId, this.receiverId, this.isMatchOver = false, this.isMatchStarted = false, this.leftSideTeam = TeamType.teamA, this.isWaitingForNextGame = false}): _positions = positions;
  factory _MatchState.fromJson(Map<String, dynamic> json) => _$MatchStateFromJson(json);

@override@JsonKey() final  int scoreTeamA;
@override@JsonKey() final  int scoreTeamB;
@override@JsonKey() final  int gameScoreA;
@override@JsonKey() final  int gameScoreB;
@override final  TeamType currentServeTeam;
 final  Map<CourtQuadrant, Player> _positions;
@override Map<CourtQuadrant, Player> get positions {
  if (_positions is EqualUnmodifiableMapView) return _positions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_positions);
}

@override final  String? serverId;
@override final  String? receiverId;
@override@JsonKey() final  bool isMatchOver;
@override@JsonKey() final  bool isMatchStarted;
@override@JsonKey() final  TeamType leftSideTeam;
@override@JsonKey() final  bool isWaitingForNextGame;

/// Create a copy of MatchState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MatchStateCopyWith<_MatchState> get copyWith => __$MatchStateCopyWithImpl<_MatchState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MatchStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MatchState&&(identical(other.scoreTeamA, scoreTeamA) || other.scoreTeamA == scoreTeamA)&&(identical(other.scoreTeamB, scoreTeamB) || other.scoreTeamB == scoreTeamB)&&(identical(other.gameScoreA, gameScoreA) || other.gameScoreA == gameScoreA)&&(identical(other.gameScoreB, gameScoreB) || other.gameScoreB == gameScoreB)&&(identical(other.currentServeTeam, currentServeTeam) || other.currentServeTeam == currentServeTeam)&&const DeepCollectionEquality().equals(other._positions, _positions)&&(identical(other.serverId, serverId) || other.serverId == serverId)&&(identical(other.receiverId, receiverId) || other.receiverId == receiverId)&&(identical(other.isMatchOver, isMatchOver) || other.isMatchOver == isMatchOver)&&(identical(other.isMatchStarted, isMatchStarted) || other.isMatchStarted == isMatchStarted)&&(identical(other.leftSideTeam, leftSideTeam) || other.leftSideTeam == leftSideTeam)&&(identical(other.isWaitingForNextGame, isWaitingForNextGame) || other.isWaitingForNextGame == isWaitingForNextGame));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,scoreTeamA,scoreTeamB,gameScoreA,gameScoreB,currentServeTeam,const DeepCollectionEquality().hash(_positions),serverId,receiverId,isMatchOver,isMatchStarted,leftSideTeam,isWaitingForNextGame);

@override
String toString() {
  return 'MatchState(scoreTeamA: $scoreTeamA, scoreTeamB: $scoreTeamB, gameScoreA: $gameScoreA, gameScoreB: $gameScoreB, currentServeTeam: $currentServeTeam, positions: $positions, serverId: $serverId, receiverId: $receiverId, isMatchOver: $isMatchOver, isMatchStarted: $isMatchStarted, leftSideTeam: $leftSideTeam, isWaitingForNextGame: $isWaitingForNextGame)';
}


}

/// @nodoc
abstract mixin class _$MatchStateCopyWith<$Res> implements $MatchStateCopyWith<$Res> {
  factory _$MatchStateCopyWith(_MatchState value, $Res Function(_MatchState) _then) = __$MatchStateCopyWithImpl;
@override @useResult
$Res call({
 int scoreTeamA, int scoreTeamB, int gameScoreA, int gameScoreB, TeamType currentServeTeam, Map<CourtQuadrant, Player> positions, String? serverId, String? receiverId, bool isMatchOver, bool isMatchStarted, TeamType leftSideTeam, bool isWaitingForNextGame
});




}
/// @nodoc
class __$MatchStateCopyWithImpl<$Res>
    implements _$MatchStateCopyWith<$Res> {
  __$MatchStateCopyWithImpl(this._self, this._then);

  final _MatchState _self;
  final $Res Function(_MatchState) _then;

/// Create a copy of MatchState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? scoreTeamA = null,Object? scoreTeamB = null,Object? gameScoreA = null,Object? gameScoreB = null,Object? currentServeTeam = null,Object? positions = null,Object? serverId = freezed,Object? receiverId = freezed,Object? isMatchOver = null,Object? isMatchStarted = null,Object? leftSideTeam = null,Object? isWaitingForNextGame = null,}) {
  return _then(_MatchState(
scoreTeamA: null == scoreTeamA ? _self.scoreTeamA : scoreTeamA // ignore: cast_nullable_to_non_nullable
as int,scoreTeamB: null == scoreTeamB ? _self.scoreTeamB : scoreTeamB // ignore: cast_nullable_to_non_nullable
as int,gameScoreA: null == gameScoreA ? _self.gameScoreA : gameScoreA // ignore: cast_nullable_to_non_nullable
as int,gameScoreB: null == gameScoreB ? _self.gameScoreB : gameScoreB // ignore: cast_nullable_to_non_nullable
as int,currentServeTeam: null == currentServeTeam ? _self.currentServeTeam : currentServeTeam // ignore: cast_nullable_to_non_nullable
as TeamType,positions: null == positions ? _self._positions : positions // ignore: cast_nullable_to_non_nullable
as Map<CourtQuadrant, Player>,serverId: freezed == serverId ? _self.serverId : serverId // ignore: cast_nullable_to_non_nullable
as String?,receiverId: freezed == receiverId ? _self.receiverId : receiverId // ignore: cast_nullable_to_non_nullable
as String?,isMatchOver: null == isMatchOver ? _self.isMatchOver : isMatchOver // ignore: cast_nullable_to_non_nullable
as bool,isMatchStarted: null == isMatchStarted ? _self.isMatchStarted : isMatchStarted // ignore: cast_nullable_to_non_nullable
as bool,leftSideTeam: null == leftSideTeam ? _self.leftSideTeam : leftSideTeam // ignore: cast_nullable_to_non_nullable
as TeamType,isWaitingForNextGame: null == isWaitingForNextGame ? _self.isWaitingForNextGame : isWaitingForNextGame // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$MatchSettings {

 bool get isDoubles; int get winningScore; int get maxGames;
/// Create a copy of MatchSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MatchSettingsCopyWith<MatchSettings> get copyWith => _$MatchSettingsCopyWithImpl<MatchSettings>(this as MatchSettings, _$identity);

  /// Serializes this MatchSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MatchSettings&&(identical(other.isDoubles, isDoubles) || other.isDoubles == isDoubles)&&(identical(other.winningScore, winningScore) || other.winningScore == winningScore)&&(identical(other.maxGames, maxGames) || other.maxGames == maxGames));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isDoubles,winningScore,maxGames);

@override
String toString() {
  return 'MatchSettings(isDoubles: $isDoubles, winningScore: $winningScore, maxGames: $maxGames)';
}


}

/// @nodoc
abstract mixin class $MatchSettingsCopyWith<$Res>  {
  factory $MatchSettingsCopyWith(MatchSettings value, $Res Function(MatchSettings) _then) = _$MatchSettingsCopyWithImpl;
@useResult
$Res call({
 bool isDoubles, int winningScore, int maxGames
});




}
/// @nodoc
class _$MatchSettingsCopyWithImpl<$Res>
    implements $MatchSettingsCopyWith<$Res> {
  _$MatchSettingsCopyWithImpl(this._self, this._then);

  final MatchSettings _self;
  final $Res Function(MatchSettings) _then;

/// Create a copy of MatchSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isDoubles = null,Object? winningScore = null,Object? maxGames = null,}) {
  return _then(_self.copyWith(
isDoubles: null == isDoubles ? _self.isDoubles : isDoubles // ignore: cast_nullable_to_non_nullable
as bool,winningScore: null == winningScore ? _self.winningScore : winningScore // ignore: cast_nullable_to_non_nullable
as int,maxGames: null == maxGames ? _self.maxGames : maxGames // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MatchSettings].
extension MatchSettingsPatterns on MatchSettings {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MatchSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MatchSettings() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MatchSettings value)  $default,){
final _that = this;
switch (_that) {
case _MatchSettings():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MatchSettings value)?  $default,){
final _that = this;
switch (_that) {
case _MatchSettings() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isDoubles,  int winningScore,  int maxGames)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MatchSettings() when $default != null:
return $default(_that.isDoubles,_that.winningScore,_that.maxGames);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isDoubles,  int winningScore,  int maxGames)  $default,) {final _that = this;
switch (_that) {
case _MatchSettings():
return $default(_that.isDoubles,_that.winningScore,_that.maxGames);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isDoubles,  int winningScore,  int maxGames)?  $default,) {final _that = this;
switch (_that) {
case _MatchSettings() when $default != null:
return $default(_that.isDoubles,_that.winningScore,_that.maxGames);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MatchSettings implements MatchSettings {
  const _MatchSettings({this.isDoubles = true, this.winningScore = 21, this.maxGames = 3});
  factory _MatchSettings.fromJson(Map<String, dynamic> json) => _$MatchSettingsFromJson(json);

@override@JsonKey() final  bool isDoubles;
@override@JsonKey() final  int winningScore;
@override@JsonKey() final  int maxGames;

/// Create a copy of MatchSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MatchSettingsCopyWith<_MatchSettings> get copyWith => __$MatchSettingsCopyWithImpl<_MatchSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MatchSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MatchSettings&&(identical(other.isDoubles, isDoubles) || other.isDoubles == isDoubles)&&(identical(other.winningScore, winningScore) || other.winningScore == winningScore)&&(identical(other.maxGames, maxGames) || other.maxGames == maxGames));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isDoubles,winningScore,maxGames);

@override
String toString() {
  return 'MatchSettings(isDoubles: $isDoubles, winningScore: $winningScore, maxGames: $maxGames)';
}


}

/// @nodoc
abstract mixin class _$MatchSettingsCopyWith<$Res> implements $MatchSettingsCopyWith<$Res> {
  factory _$MatchSettingsCopyWith(_MatchSettings value, $Res Function(_MatchSettings) _then) = __$MatchSettingsCopyWithImpl;
@override @useResult
$Res call({
 bool isDoubles, int winningScore, int maxGames
});




}
/// @nodoc
class __$MatchSettingsCopyWithImpl<$Res>
    implements _$MatchSettingsCopyWith<$Res> {
  __$MatchSettingsCopyWithImpl(this._self, this._then);

  final _MatchSettings _self;
  final $Res Function(_MatchSettings) _then;

/// Create a copy of MatchSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isDoubles = null,Object? winningScore = null,Object? maxGames = null,}) {
  return _then(_MatchSettings(
isDoubles: null == isDoubles ? _self.isDoubles : isDoubles // ignore: cast_nullable_to_non_nullable
as bool,winningScore: null == winningScore ? _self.winningScore : winningScore // ignore: cast_nullable_to_non_nullable
as int,maxGames: null == maxGames ? _self.maxGames : maxGames // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$MatchHistory {

 List<MatchState> get states; int get currentIndex; MatchSettings get settings; DateTime? get startTime;
/// Create a copy of MatchHistory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MatchHistoryCopyWith<MatchHistory> get copyWith => _$MatchHistoryCopyWithImpl<MatchHistory>(this as MatchHistory, _$identity);

  /// Serializes this MatchHistory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MatchHistory&&const DeepCollectionEquality().equals(other.states, states)&&(identical(other.currentIndex, currentIndex) || other.currentIndex == currentIndex)&&(identical(other.settings, settings) || other.settings == settings)&&(identical(other.startTime, startTime) || other.startTime == startTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(states),currentIndex,settings,startTime);

@override
String toString() {
  return 'MatchHistory(states: $states, currentIndex: $currentIndex, settings: $settings, startTime: $startTime)';
}


}

/// @nodoc
abstract mixin class $MatchHistoryCopyWith<$Res>  {
  factory $MatchHistoryCopyWith(MatchHistory value, $Res Function(MatchHistory) _then) = _$MatchHistoryCopyWithImpl;
@useResult
$Res call({
 List<MatchState> states, int currentIndex, MatchSettings settings, DateTime? startTime
});


$MatchSettingsCopyWith<$Res> get settings;

}
/// @nodoc
class _$MatchHistoryCopyWithImpl<$Res>
    implements $MatchHistoryCopyWith<$Res> {
  _$MatchHistoryCopyWithImpl(this._self, this._then);

  final MatchHistory _self;
  final $Res Function(MatchHistory) _then;

/// Create a copy of MatchHistory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? states = null,Object? currentIndex = null,Object? settings = null,Object? startTime = freezed,}) {
  return _then(_self.copyWith(
states: null == states ? _self.states : states // ignore: cast_nullable_to_non_nullable
as List<MatchState>,currentIndex: null == currentIndex ? _self.currentIndex : currentIndex // ignore: cast_nullable_to_non_nullable
as int,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as MatchSettings,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of MatchHistory
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MatchSettingsCopyWith<$Res> get settings {
  
  return $MatchSettingsCopyWith<$Res>(_self.settings, (value) {
    return _then(_self.copyWith(settings: value));
  });
}
}


/// Adds pattern-matching-related methods to [MatchHistory].
extension MatchHistoryPatterns on MatchHistory {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MatchHistory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MatchHistory() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MatchHistory value)  $default,){
final _that = this;
switch (_that) {
case _MatchHistory():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MatchHistory value)?  $default,){
final _that = this;
switch (_that) {
case _MatchHistory() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<MatchState> states,  int currentIndex,  MatchSettings settings,  DateTime? startTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MatchHistory() when $default != null:
return $default(_that.states,_that.currentIndex,_that.settings,_that.startTime);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<MatchState> states,  int currentIndex,  MatchSettings settings,  DateTime? startTime)  $default,) {final _that = this;
switch (_that) {
case _MatchHistory():
return $default(_that.states,_that.currentIndex,_that.settings,_that.startTime);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<MatchState> states,  int currentIndex,  MatchSettings settings,  DateTime? startTime)?  $default,) {final _that = this;
switch (_that) {
case _MatchHistory() when $default != null:
return $default(_that.states,_that.currentIndex,_that.settings,_that.startTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MatchHistory implements MatchHistory {
  const _MatchHistory({final  List<MatchState> states = const [], this.currentIndex = 0, required this.settings, this.startTime}): _states = states;
  factory _MatchHistory.fromJson(Map<String, dynamic> json) => _$MatchHistoryFromJson(json);

 final  List<MatchState> _states;
@override@JsonKey() List<MatchState> get states {
  if (_states is EqualUnmodifiableListView) return _states;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_states);
}

@override@JsonKey() final  int currentIndex;
@override final  MatchSettings settings;
@override final  DateTime? startTime;

/// Create a copy of MatchHistory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MatchHistoryCopyWith<_MatchHistory> get copyWith => __$MatchHistoryCopyWithImpl<_MatchHistory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MatchHistoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MatchHistory&&const DeepCollectionEquality().equals(other._states, _states)&&(identical(other.currentIndex, currentIndex) || other.currentIndex == currentIndex)&&(identical(other.settings, settings) || other.settings == settings)&&(identical(other.startTime, startTime) || other.startTime == startTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_states),currentIndex,settings,startTime);

@override
String toString() {
  return 'MatchHistory(states: $states, currentIndex: $currentIndex, settings: $settings, startTime: $startTime)';
}


}

/// @nodoc
abstract mixin class _$MatchHistoryCopyWith<$Res> implements $MatchHistoryCopyWith<$Res> {
  factory _$MatchHistoryCopyWith(_MatchHistory value, $Res Function(_MatchHistory) _then) = __$MatchHistoryCopyWithImpl;
@override @useResult
$Res call({
 List<MatchState> states, int currentIndex, MatchSettings settings, DateTime? startTime
});


@override $MatchSettingsCopyWith<$Res> get settings;

}
/// @nodoc
class __$MatchHistoryCopyWithImpl<$Res>
    implements _$MatchHistoryCopyWith<$Res> {
  __$MatchHistoryCopyWithImpl(this._self, this._then);

  final _MatchHistory _self;
  final $Res Function(_MatchHistory) _then;

/// Create a copy of MatchHistory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? states = null,Object? currentIndex = null,Object? settings = null,Object? startTime = freezed,}) {
  return _then(_MatchHistory(
states: null == states ? _self._states : states // ignore: cast_nullable_to_non_nullable
as List<MatchState>,currentIndex: null == currentIndex ? _self.currentIndex : currentIndex // ignore: cast_nullable_to_non_nullable
as int,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as MatchSettings,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of MatchHistory
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MatchSettingsCopyWith<$Res> get settings {
  
  return $MatchSettingsCopyWith<$Res>(_self.settings, (value) {
    return _then(_self.copyWith(settings: value));
  });
}
}

// dart format on
