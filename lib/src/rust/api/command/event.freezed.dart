// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$EventEnum {
  Object get field0 => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Start field0) start,
    required TResult Function(Stop field0) stop,
    required TResult Function(RequestToReceive field0) requestToReceive,
    required TResult Function(SendFile field0) sendFile,
    required TResult Function(StartToReceive field0) startReceive,
    required TResult Function(DiscoveryIp field0) discoveryIp,
    required TResult Function(FileProgress field0) fileProgress,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Start field0)? start,
    TResult? Function(Stop field0)? stop,
    TResult? Function(RequestToReceive field0)? requestToReceive,
    TResult? Function(SendFile field0)? sendFile,
    TResult? Function(StartToReceive field0)? startReceive,
    TResult? Function(DiscoveryIp field0)? discoveryIp,
    TResult? Function(FileProgress field0)? fileProgress,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Start field0)? start,
    TResult Function(Stop field0)? stop,
    TResult Function(RequestToReceive field0)? requestToReceive,
    TResult Function(SendFile field0)? sendFile,
    TResult Function(StartToReceive field0)? startReceive,
    TResult Function(DiscoveryIp field0)? discoveryIp,
    TResult Function(FileProgress field0)? fileProgress,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(EventEnum_Start value) start,
    required TResult Function(EventEnum_Stop value) stop,
    required TResult Function(EventEnum_RequestToReceive value)
        requestToReceive,
    required TResult Function(EventEnum_SendFile value) sendFile,
    required TResult Function(EventEnum_StartReceive value) startReceive,
    required TResult Function(EventEnum_DiscoveryIp value) discoveryIp,
    required TResult Function(EventEnum_FileProgress value) fileProgress,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(EventEnum_Start value)? start,
    TResult? Function(EventEnum_Stop value)? stop,
    TResult? Function(EventEnum_RequestToReceive value)? requestToReceive,
    TResult? Function(EventEnum_SendFile value)? sendFile,
    TResult? Function(EventEnum_StartReceive value)? startReceive,
    TResult? Function(EventEnum_DiscoveryIp value)? discoveryIp,
    TResult? Function(EventEnum_FileProgress value)? fileProgress,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(EventEnum_Start value)? start,
    TResult Function(EventEnum_Stop value)? stop,
    TResult Function(EventEnum_RequestToReceive value)? requestToReceive,
    TResult Function(EventEnum_SendFile value)? sendFile,
    TResult Function(EventEnum_StartReceive value)? startReceive,
    TResult Function(EventEnum_DiscoveryIp value)? discoveryIp,
    TResult Function(EventEnum_FileProgress value)? fileProgress,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventEnumCopyWith<$Res> {
  factory $EventEnumCopyWith(EventEnum value, $Res Function(EventEnum) then) =
      _$EventEnumCopyWithImpl<$Res, EventEnum>;
}

/// @nodoc
class _$EventEnumCopyWithImpl<$Res, $Val extends EventEnum>
    implements $EventEnumCopyWith<$Res> {
  _$EventEnumCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$EventEnum_StartImplCopyWith<$Res> {
  factory _$$EventEnum_StartImplCopyWith(_$EventEnum_StartImpl value,
          $Res Function(_$EventEnum_StartImpl) then) =
      __$$EventEnum_StartImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Start field0});
}

/// @nodoc
class __$$EventEnum_StartImplCopyWithImpl<$Res>
    extends _$EventEnumCopyWithImpl<$Res, _$EventEnum_StartImpl>
    implements _$$EventEnum_StartImplCopyWith<$Res> {
  __$$EventEnum_StartImplCopyWithImpl(
      _$EventEnum_StartImpl _value, $Res Function(_$EventEnum_StartImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$EventEnum_StartImpl(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as Start,
    ));
  }
}

/// @nodoc

class _$EventEnum_StartImpl implements EventEnum_Start {
  const _$EventEnum_StartImpl(this.field0);

  @override
  final Start field0;

  @override
  String toString() {
    return 'EventEnum.start(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventEnum_StartImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventEnum_StartImplCopyWith<_$EventEnum_StartImpl> get copyWith =>
      __$$EventEnum_StartImplCopyWithImpl<_$EventEnum_StartImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Start field0) start,
    required TResult Function(Stop field0) stop,
    required TResult Function(RequestToReceive field0) requestToReceive,
    required TResult Function(SendFile field0) sendFile,
    required TResult Function(StartToReceive field0) startReceive,
    required TResult Function(DiscoveryIp field0) discoveryIp,
    required TResult Function(FileProgress field0) fileProgress,
  }) {
    return start(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Start field0)? start,
    TResult? Function(Stop field0)? stop,
    TResult? Function(RequestToReceive field0)? requestToReceive,
    TResult? Function(SendFile field0)? sendFile,
    TResult? Function(StartToReceive field0)? startReceive,
    TResult? Function(DiscoveryIp field0)? discoveryIp,
    TResult? Function(FileProgress field0)? fileProgress,
  }) {
    return start?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Start field0)? start,
    TResult Function(Stop field0)? stop,
    TResult Function(RequestToReceive field0)? requestToReceive,
    TResult Function(SendFile field0)? sendFile,
    TResult Function(StartToReceive field0)? startReceive,
    TResult Function(DiscoveryIp field0)? discoveryIp,
    TResult Function(FileProgress field0)? fileProgress,
    required TResult orElse(),
  }) {
    if (start != null) {
      return start(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(EventEnum_Start value) start,
    required TResult Function(EventEnum_Stop value) stop,
    required TResult Function(EventEnum_RequestToReceive value)
        requestToReceive,
    required TResult Function(EventEnum_SendFile value) sendFile,
    required TResult Function(EventEnum_StartReceive value) startReceive,
    required TResult Function(EventEnum_DiscoveryIp value) discoveryIp,
    required TResult Function(EventEnum_FileProgress value) fileProgress,
  }) {
    return start(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(EventEnum_Start value)? start,
    TResult? Function(EventEnum_Stop value)? stop,
    TResult? Function(EventEnum_RequestToReceive value)? requestToReceive,
    TResult? Function(EventEnum_SendFile value)? sendFile,
    TResult? Function(EventEnum_StartReceive value)? startReceive,
    TResult? Function(EventEnum_DiscoveryIp value)? discoveryIp,
    TResult? Function(EventEnum_FileProgress value)? fileProgress,
  }) {
    return start?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(EventEnum_Start value)? start,
    TResult Function(EventEnum_Stop value)? stop,
    TResult Function(EventEnum_RequestToReceive value)? requestToReceive,
    TResult Function(EventEnum_SendFile value)? sendFile,
    TResult Function(EventEnum_StartReceive value)? startReceive,
    TResult Function(EventEnum_DiscoveryIp value)? discoveryIp,
    TResult Function(EventEnum_FileProgress value)? fileProgress,
    required TResult orElse(),
  }) {
    if (start != null) {
      return start(this);
    }
    return orElse();
  }
}

abstract class EventEnum_Start implements EventEnum {
  const factory EventEnum_Start(final Start field0) = _$EventEnum_StartImpl;

  @override
  Start get field0;
  @JsonKey(ignore: true)
  _$$EventEnum_StartImplCopyWith<_$EventEnum_StartImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$EventEnum_StopImplCopyWith<$Res> {
  factory _$$EventEnum_StopImplCopyWith(_$EventEnum_StopImpl value,
          $Res Function(_$EventEnum_StopImpl) then) =
      __$$EventEnum_StopImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Stop field0});
}

/// @nodoc
class __$$EventEnum_StopImplCopyWithImpl<$Res>
    extends _$EventEnumCopyWithImpl<$Res, _$EventEnum_StopImpl>
    implements _$$EventEnum_StopImplCopyWith<$Res> {
  __$$EventEnum_StopImplCopyWithImpl(
      _$EventEnum_StopImpl _value, $Res Function(_$EventEnum_StopImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$EventEnum_StopImpl(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as Stop,
    ));
  }
}

/// @nodoc

class _$EventEnum_StopImpl implements EventEnum_Stop {
  const _$EventEnum_StopImpl(this.field0);

  @override
  final Stop field0;

  @override
  String toString() {
    return 'EventEnum.stop(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventEnum_StopImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventEnum_StopImplCopyWith<_$EventEnum_StopImpl> get copyWith =>
      __$$EventEnum_StopImplCopyWithImpl<_$EventEnum_StopImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Start field0) start,
    required TResult Function(Stop field0) stop,
    required TResult Function(RequestToReceive field0) requestToReceive,
    required TResult Function(SendFile field0) sendFile,
    required TResult Function(StartToReceive field0) startReceive,
    required TResult Function(DiscoveryIp field0) discoveryIp,
    required TResult Function(FileProgress field0) fileProgress,
  }) {
    return stop(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Start field0)? start,
    TResult? Function(Stop field0)? stop,
    TResult? Function(RequestToReceive field0)? requestToReceive,
    TResult? Function(SendFile field0)? sendFile,
    TResult? Function(StartToReceive field0)? startReceive,
    TResult? Function(DiscoveryIp field0)? discoveryIp,
    TResult? Function(FileProgress field0)? fileProgress,
  }) {
    return stop?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Start field0)? start,
    TResult Function(Stop field0)? stop,
    TResult Function(RequestToReceive field0)? requestToReceive,
    TResult Function(SendFile field0)? sendFile,
    TResult Function(StartToReceive field0)? startReceive,
    TResult Function(DiscoveryIp field0)? discoveryIp,
    TResult Function(FileProgress field0)? fileProgress,
    required TResult orElse(),
  }) {
    if (stop != null) {
      return stop(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(EventEnum_Start value) start,
    required TResult Function(EventEnum_Stop value) stop,
    required TResult Function(EventEnum_RequestToReceive value)
        requestToReceive,
    required TResult Function(EventEnum_SendFile value) sendFile,
    required TResult Function(EventEnum_StartReceive value) startReceive,
    required TResult Function(EventEnum_DiscoveryIp value) discoveryIp,
    required TResult Function(EventEnum_FileProgress value) fileProgress,
  }) {
    return stop(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(EventEnum_Start value)? start,
    TResult? Function(EventEnum_Stop value)? stop,
    TResult? Function(EventEnum_RequestToReceive value)? requestToReceive,
    TResult? Function(EventEnum_SendFile value)? sendFile,
    TResult? Function(EventEnum_StartReceive value)? startReceive,
    TResult? Function(EventEnum_DiscoveryIp value)? discoveryIp,
    TResult? Function(EventEnum_FileProgress value)? fileProgress,
  }) {
    return stop?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(EventEnum_Start value)? start,
    TResult Function(EventEnum_Stop value)? stop,
    TResult Function(EventEnum_RequestToReceive value)? requestToReceive,
    TResult Function(EventEnum_SendFile value)? sendFile,
    TResult Function(EventEnum_StartReceive value)? startReceive,
    TResult Function(EventEnum_DiscoveryIp value)? discoveryIp,
    TResult Function(EventEnum_FileProgress value)? fileProgress,
    required TResult orElse(),
  }) {
    if (stop != null) {
      return stop(this);
    }
    return orElse();
  }
}

abstract class EventEnum_Stop implements EventEnum {
  const factory EventEnum_Stop(final Stop field0) = _$EventEnum_StopImpl;

  @override
  Stop get field0;
  @JsonKey(ignore: true)
  _$$EventEnum_StopImplCopyWith<_$EventEnum_StopImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$EventEnum_RequestToReceiveImplCopyWith<$Res> {
  factory _$$EventEnum_RequestToReceiveImplCopyWith(
          _$EventEnum_RequestToReceiveImpl value,
          $Res Function(_$EventEnum_RequestToReceiveImpl) then) =
      __$$EventEnum_RequestToReceiveImplCopyWithImpl<$Res>;
  @useResult
  $Res call({RequestToReceive field0});
}

/// @nodoc
class __$$EventEnum_RequestToReceiveImplCopyWithImpl<$Res>
    extends _$EventEnumCopyWithImpl<$Res, _$EventEnum_RequestToReceiveImpl>
    implements _$$EventEnum_RequestToReceiveImplCopyWith<$Res> {
  __$$EventEnum_RequestToReceiveImplCopyWithImpl(
      _$EventEnum_RequestToReceiveImpl _value,
      $Res Function(_$EventEnum_RequestToReceiveImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$EventEnum_RequestToReceiveImpl(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as RequestToReceive,
    ));
  }
}

/// @nodoc

class _$EventEnum_RequestToReceiveImpl implements EventEnum_RequestToReceive {
  const _$EventEnum_RequestToReceiveImpl(this.field0);

  @override
  final RequestToReceive field0;

  @override
  String toString() {
    return 'EventEnum.requestToReceive(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventEnum_RequestToReceiveImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventEnum_RequestToReceiveImplCopyWith<_$EventEnum_RequestToReceiveImpl>
      get copyWith => __$$EventEnum_RequestToReceiveImplCopyWithImpl<
          _$EventEnum_RequestToReceiveImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Start field0) start,
    required TResult Function(Stop field0) stop,
    required TResult Function(RequestToReceive field0) requestToReceive,
    required TResult Function(SendFile field0) sendFile,
    required TResult Function(StartToReceive field0) startReceive,
    required TResult Function(DiscoveryIp field0) discoveryIp,
    required TResult Function(FileProgress field0) fileProgress,
  }) {
    return requestToReceive(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Start field0)? start,
    TResult? Function(Stop field0)? stop,
    TResult? Function(RequestToReceive field0)? requestToReceive,
    TResult? Function(SendFile field0)? sendFile,
    TResult? Function(StartToReceive field0)? startReceive,
    TResult? Function(DiscoveryIp field0)? discoveryIp,
    TResult? Function(FileProgress field0)? fileProgress,
  }) {
    return requestToReceive?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Start field0)? start,
    TResult Function(Stop field0)? stop,
    TResult Function(RequestToReceive field0)? requestToReceive,
    TResult Function(SendFile field0)? sendFile,
    TResult Function(StartToReceive field0)? startReceive,
    TResult Function(DiscoveryIp field0)? discoveryIp,
    TResult Function(FileProgress field0)? fileProgress,
    required TResult orElse(),
  }) {
    if (requestToReceive != null) {
      return requestToReceive(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(EventEnum_Start value) start,
    required TResult Function(EventEnum_Stop value) stop,
    required TResult Function(EventEnum_RequestToReceive value)
        requestToReceive,
    required TResult Function(EventEnum_SendFile value) sendFile,
    required TResult Function(EventEnum_StartReceive value) startReceive,
    required TResult Function(EventEnum_DiscoveryIp value) discoveryIp,
    required TResult Function(EventEnum_FileProgress value) fileProgress,
  }) {
    return requestToReceive(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(EventEnum_Start value)? start,
    TResult? Function(EventEnum_Stop value)? stop,
    TResult? Function(EventEnum_RequestToReceive value)? requestToReceive,
    TResult? Function(EventEnum_SendFile value)? sendFile,
    TResult? Function(EventEnum_StartReceive value)? startReceive,
    TResult? Function(EventEnum_DiscoveryIp value)? discoveryIp,
    TResult? Function(EventEnum_FileProgress value)? fileProgress,
  }) {
    return requestToReceive?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(EventEnum_Start value)? start,
    TResult Function(EventEnum_Stop value)? stop,
    TResult Function(EventEnum_RequestToReceive value)? requestToReceive,
    TResult Function(EventEnum_SendFile value)? sendFile,
    TResult Function(EventEnum_StartReceive value)? startReceive,
    TResult Function(EventEnum_DiscoveryIp value)? discoveryIp,
    TResult Function(EventEnum_FileProgress value)? fileProgress,
    required TResult orElse(),
  }) {
    if (requestToReceive != null) {
      return requestToReceive(this);
    }
    return orElse();
  }
}

abstract class EventEnum_RequestToReceive implements EventEnum {
  const factory EventEnum_RequestToReceive(final RequestToReceive field0) =
      _$EventEnum_RequestToReceiveImpl;

  @override
  RequestToReceive get field0;
  @JsonKey(ignore: true)
  _$$EventEnum_RequestToReceiveImplCopyWith<_$EventEnum_RequestToReceiveImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$EventEnum_SendFileImplCopyWith<$Res> {
  factory _$$EventEnum_SendFileImplCopyWith(_$EventEnum_SendFileImpl value,
          $Res Function(_$EventEnum_SendFileImpl) then) =
      __$$EventEnum_SendFileImplCopyWithImpl<$Res>;
  @useResult
  $Res call({SendFile field0});
}

/// @nodoc
class __$$EventEnum_SendFileImplCopyWithImpl<$Res>
    extends _$EventEnumCopyWithImpl<$Res, _$EventEnum_SendFileImpl>
    implements _$$EventEnum_SendFileImplCopyWith<$Res> {
  __$$EventEnum_SendFileImplCopyWithImpl(_$EventEnum_SendFileImpl _value,
      $Res Function(_$EventEnum_SendFileImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$EventEnum_SendFileImpl(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as SendFile,
    ));
  }
}

/// @nodoc

class _$EventEnum_SendFileImpl implements EventEnum_SendFile {
  const _$EventEnum_SendFileImpl(this.field0);

  @override
  final SendFile field0;

  @override
  String toString() {
    return 'EventEnum.sendFile(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventEnum_SendFileImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventEnum_SendFileImplCopyWith<_$EventEnum_SendFileImpl> get copyWith =>
      __$$EventEnum_SendFileImplCopyWithImpl<_$EventEnum_SendFileImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Start field0) start,
    required TResult Function(Stop field0) stop,
    required TResult Function(RequestToReceive field0) requestToReceive,
    required TResult Function(SendFile field0) sendFile,
    required TResult Function(StartToReceive field0) startReceive,
    required TResult Function(DiscoveryIp field0) discoveryIp,
    required TResult Function(FileProgress field0) fileProgress,
  }) {
    return sendFile(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Start field0)? start,
    TResult? Function(Stop field0)? stop,
    TResult? Function(RequestToReceive field0)? requestToReceive,
    TResult? Function(SendFile field0)? sendFile,
    TResult? Function(StartToReceive field0)? startReceive,
    TResult? Function(DiscoveryIp field0)? discoveryIp,
    TResult? Function(FileProgress field0)? fileProgress,
  }) {
    return sendFile?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Start field0)? start,
    TResult Function(Stop field0)? stop,
    TResult Function(RequestToReceive field0)? requestToReceive,
    TResult Function(SendFile field0)? sendFile,
    TResult Function(StartToReceive field0)? startReceive,
    TResult Function(DiscoveryIp field0)? discoveryIp,
    TResult Function(FileProgress field0)? fileProgress,
    required TResult orElse(),
  }) {
    if (sendFile != null) {
      return sendFile(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(EventEnum_Start value) start,
    required TResult Function(EventEnum_Stop value) stop,
    required TResult Function(EventEnum_RequestToReceive value)
        requestToReceive,
    required TResult Function(EventEnum_SendFile value) sendFile,
    required TResult Function(EventEnum_StartReceive value) startReceive,
    required TResult Function(EventEnum_DiscoveryIp value) discoveryIp,
    required TResult Function(EventEnum_FileProgress value) fileProgress,
  }) {
    return sendFile(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(EventEnum_Start value)? start,
    TResult? Function(EventEnum_Stop value)? stop,
    TResult? Function(EventEnum_RequestToReceive value)? requestToReceive,
    TResult? Function(EventEnum_SendFile value)? sendFile,
    TResult? Function(EventEnum_StartReceive value)? startReceive,
    TResult? Function(EventEnum_DiscoveryIp value)? discoveryIp,
    TResult? Function(EventEnum_FileProgress value)? fileProgress,
  }) {
    return sendFile?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(EventEnum_Start value)? start,
    TResult Function(EventEnum_Stop value)? stop,
    TResult Function(EventEnum_RequestToReceive value)? requestToReceive,
    TResult Function(EventEnum_SendFile value)? sendFile,
    TResult Function(EventEnum_StartReceive value)? startReceive,
    TResult Function(EventEnum_DiscoveryIp value)? discoveryIp,
    TResult Function(EventEnum_FileProgress value)? fileProgress,
    required TResult orElse(),
  }) {
    if (sendFile != null) {
      return sendFile(this);
    }
    return orElse();
  }
}

abstract class EventEnum_SendFile implements EventEnum {
  const factory EventEnum_SendFile(final SendFile field0) =
      _$EventEnum_SendFileImpl;

  @override
  SendFile get field0;
  @JsonKey(ignore: true)
  _$$EventEnum_SendFileImplCopyWith<_$EventEnum_SendFileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$EventEnum_StartReceiveImplCopyWith<$Res> {
  factory _$$EventEnum_StartReceiveImplCopyWith(
          _$EventEnum_StartReceiveImpl value,
          $Res Function(_$EventEnum_StartReceiveImpl) then) =
      __$$EventEnum_StartReceiveImplCopyWithImpl<$Res>;
  @useResult
  $Res call({StartToReceive field0});
}

/// @nodoc
class __$$EventEnum_StartReceiveImplCopyWithImpl<$Res>
    extends _$EventEnumCopyWithImpl<$Res, _$EventEnum_StartReceiveImpl>
    implements _$$EventEnum_StartReceiveImplCopyWith<$Res> {
  __$$EventEnum_StartReceiveImplCopyWithImpl(
      _$EventEnum_StartReceiveImpl _value,
      $Res Function(_$EventEnum_StartReceiveImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$EventEnum_StartReceiveImpl(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as StartToReceive,
    ));
  }
}

/// @nodoc

class _$EventEnum_StartReceiveImpl implements EventEnum_StartReceive {
  const _$EventEnum_StartReceiveImpl(this.field0);

  @override
  final StartToReceive field0;

  @override
  String toString() {
    return 'EventEnum.startReceive(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventEnum_StartReceiveImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventEnum_StartReceiveImplCopyWith<_$EventEnum_StartReceiveImpl>
      get copyWith => __$$EventEnum_StartReceiveImplCopyWithImpl<
          _$EventEnum_StartReceiveImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Start field0) start,
    required TResult Function(Stop field0) stop,
    required TResult Function(RequestToReceive field0) requestToReceive,
    required TResult Function(SendFile field0) sendFile,
    required TResult Function(StartToReceive field0) startReceive,
    required TResult Function(DiscoveryIp field0) discoveryIp,
    required TResult Function(FileProgress field0) fileProgress,
  }) {
    return startReceive(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Start field0)? start,
    TResult? Function(Stop field0)? stop,
    TResult? Function(RequestToReceive field0)? requestToReceive,
    TResult? Function(SendFile field0)? sendFile,
    TResult? Function(StartToReceive field0)? startReceive,
    TResult? Function(DiscoveryIp field0)? discoveryIp,
    TResult? Function(FileProgress field0)? fileProgress,
  }) {
    return startReceive?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Start field0)? start,
    TResult Function(Stop field0)? stop,
    TResult Function(RequestToReceive field0)? requestToReceive,
    TResult Function(SendFile field0)? sendFile,
    TResult Function(StartToReceive field0)? startReceive,
    TResult Function(DiscoveryIp field0)? discoveryIp,
    TResult Function(FileProgress field0)? fileProgress,
    required TResult orElse(),
  }) {
    if (startReceive != null) {
      return startReceive(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(EventEnum_Start value) start,
    required TResult Function(EventEnum_Stop value) stop,
    required TResult Function(EventEnum_RequestToReceive value)
        requestToReceive,
    required TResult Function(EventEnum_SendFile value) sendFile,
    required TResult Function(EventEnum_StartReceive value) startReceive,
    required TResult Function(EventEnum_DiscoveryIp value) discoveryIp,
    required TResult Function(EventEnum_FileProgress value) fileProgress,
  }) {
    return startReceive(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(EventEnum_Start value)? start,
    TResult? Function(EventEnum_Stop value)? stop,
    TResult? Function(EventEnum_RequestToReceive value)? requestToReceive,
    TResult? Function(EventEnum_SendFile value)? sendFile,
    TResult? Function(EventEnum_StartReceive value)? startReceive,
    TResult? Function(EventEnum_DiscoveryIp value)? discoveryIp,
    TResult? Function(EventEnum_FileProgress value)? fileProgress,
  }) {
    return startReceive?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(EventEnum_Start value)? start,
    TResult Function(EventEnum_Stop value)? stop,
    TResult Function(EventEnum_RequestToReceive value)? requestToReceive,
    TResult Function(EventEnum_SendFile value)? sendFile,
    TResult Function(EventEnum_StartReceive value)? startReceive,
    TResult Function(EventEnum_DiscoveryIp value)? discoveryIp,
    TResult Function(EventEnum_FileProgress value)? fileProgress,
    required TResult orElse(),
  }) {
    if (startReceive != null) {
      return startReceive(this);
    }
    return orElse();
  }
}

abstract class EventEnum_StartReceive implements EventEnum {
  const factory EventEnum_StartReceive(final StartToReceive field0) =
      _$EventEnum_StartReceiveImpl;

  @override
  StartToReceive get field0;
  @JsonKey(ignore: true)
  _$$EventEnum_StartReceiveImplCopyWith<_$EventEnum_StartReceiveImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$EventEnum_DiscoveryIpImplCopyWith<$Res> {
  factory _$$EventEnum_DiscoveryIpImplCopyWith(
          _$EventEnum_DiscoveryIpImpl value,
          $Res Function(_$EventEnum_DiscoveryIpImpl) then) =
      __$$EventEnum_DiscoveryIpImplCopyWithImpl<$Res>;
  @useResult
  $Res call({DiscoveryIp field0});
}

/// @nodoc
class __$$EventEnum_DiscoveryIpImplCopyWithImpl<$Res>
    extends _$EventEnumCopyWithImpl<$Res, _$EventEnum_DiscoveryIpImpl>
    implements _$$EventEnum_DiscoveryIpImplCopyWith<$Res> {
  __$$EventEnum_DiscoveryIpImplCopyWithImpl(_$EventEnum_DiscoveryIpImpl _value,
      $Res Function(_$EventEnum_DiscoveryIpImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$EventEnum_DiscoveryIpImpl(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as DiscoveryIp,
    ));
  }
}

/// @nodoc

class _$EventEnum_DiscoveryIpImpl implements EventEnum_DiscoveryIp {
  const _$EventEnum_DiscoveryIpImpl(this.field0);

  @override
  final DiscoveryIp field0;

  @override
  String toString() {
    return 'EventEnum.discoveryIp(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventEnum_DiscoveryIpImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventEnum_DiscoveryIpImplCopyWith<_$EventEnum_DiscoveryIpImpl>
      get copyWith => __$$EventEnum_DiscoveryIpImplCopyWithImpl<
          _$EventEnum_DiscoveryIpImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Start field0) start,
    required TResult Function(Stop field0) stop,
    required TResult Function(RequestToReceive field0) requestToReceive,
    required TResult Function(SendFile field0) sendFile,
    required TResult Function(StartToReceive field0) startReceive,
    required TResult Function(DiscoveryIp field0) discoveryIp,
    required TResult Function(FileProgress field0) fileProgress,
  }) {
    return discoveryIp(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Start field0)? start,
    TResult? Function(Stop field0)? stop,
    TResult? Function(RequestToReceive field0)? requestToReceive,
    TResult? Function(SendFile field0)? sendFile,
    TResult? Function(StartToReceive field0)? startReceive,
    TResult? Function(DiscoveryIp field0)? discoveryIp,
    TResult? Function(FileProgress field0)? fileProgress,
  }) {
    return discoveryIp?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Start field0)? start,
    TResult Function(Stop field0)? stop,
    TResult Function(RequestToReceive field0)? requestToReceive,
    TResult Function(SendFile field0)? sendFile,
    TResult Function(StartToReceive field0)? startReceive,
    TResult Function(DiscoveryIp field0)? discoveryIp,
    TResult Function(FileProgress field0)? fileProgress,
    required TResult orElse(),
  }) {
    if (discoveryIp != null) {
      return discoveryIp(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(EventEnum_Start value) start,
    required TResult Function(EventEnum_Stop value) stop,
    required TResult Function(EventEnum_RequestToReceive value)
        requestToReceive,
    required TResult Function(EventEnum_SendFile value) sendFile,
    required TResult Function(EventEnum_StartReceive value) startReceive,
    required TResult Function(EventEnum_DiscoveryIp value) discoveryIp,
    required TResult Function(EventEnum_FileProgress value) fileProgress,
  }) {
    return discoveryIp(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(EventEnum_Start value)? start,
    TResult? Function(EventEnum_Stop value)? stop,
    TResult? Function(EventEnum_RequestToReceive value)? requestToReceive,
    TResult? Function(EventEnum_SendFile value)? sendFile,
    TResult? Function(EventEnum_StartReceive value)? startReceive,
    TResult? Function(EventEnum_DiscoveryIp value)? discoveryIp,
    TResult? Function(EventEnum_FileProgress value)? fileProgress,
  }) {
    return discoveryIp?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(EventEnum_Start value)? start,
    TResult Function(EventEnum_Stop value)? stop,
    TResult Function(EventEnum_RequestToReceive value)? requestToReceive,
    TResult Function(EventEnum_SendFile value)? sendFile,
    TResult Function(EventEnum_StartReceive value)? startReceive,
    TResult Function(EventEnum_DiscoveryIp value)? discoveryIp,
    TResult Function(EventEnum_FileProgress value)? fileProgress,
    required TResult orElse(),
  }) {
    if (discoveryIp != null) {
      return discoveryIp(this);
    }
    return orElse();
  }
}

abstract class EventEnum_DiscoveryIp implements EventEnum {
  const factory EventEnum_DiscoveryIp(final DiscoveryIp field0) =
      _$EventEnum_DiscoveryIpImpl;

  @override
  DiscoveryIp get field0;
  @JsonKey(ignore: true)
  _$$EventEnum_DiscoveryIpImplCopyWith<_$EventEnum_DiscoveryIpImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$EventEnum_FileProgressImplCopyWith<$Res> {
  factory _$$EventEnum_FileProgressImplCopyWith(
          _$EventEnum_FileProgressImpl value,
          $Res Function(_$EventEnum_FileProgressImpl) then) =
      __$$EventEnum_FileProgressImplCopyWithImpl<$Res>;
  @useResult
  $Res call({FileProgress field0});
}

/// @nodoc
class __$$EventEnum_FileProgressImplCopyWithImpl<$Res>
    extends _$EventEnumCopyWithImpl<$Res, _$EventEnum_FileProgressImpl>
    implements _$$EventEnum_FileProgressImplCopyWith<$Res> {
  __$$EventEnum_FileProgressImplCopyWithImpl(
      _$EventEnum_FileProgressImpl _value,
      $Res Function(_$EventEnum_FileProgressImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$EventEnum_FileProgressImpl(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as FileProgress,
    ));
  }
}

/// @nodoc

class _$EventEnum_FileProgressImpl implements EventEnum_FileProgress {
  const _$EventEnum_FileProgressImpl(this.field0);

  @override
  final FileProgress field0;

  @override
  String toString() {
    return 'EventEnum.fileProgress(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventEnum_FileProgressImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventEnum_FileProgressImplCopyWith<_$EventEnum_FileProgressImpl>
      get copyWith => __$$EventEnum_FileProgressImplCopyWithImpl<
          _$EventEnum_FileProgressImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Start field0) start,
    required TResult Function(Stop field0) stop,
    required TResult Function(RequestToReceive field0) requestToReceive,
    required TResult Function(SendFile field0) sendFile,
    required TResult Function(StartToReceive field0) startReceive,
    required TResult Function(DiscoveryIp field0) discoveryIp,
    required TResult Function(FileProgress field0) fileProgress,
  }) {
    return fileProgress(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Start field0)? start,
    TResult? Function(Stop field0)? stop,
    TResult? Function(RequestToReceive field0)? requestToReceive,
    TResult? Function(SendFile field0)? sendFile,
    TResult? Function(StartToReceive field0)? startReceive,
    TResult? Function(DiscoveryIp field0)? discoveryIp,
    TResult? Function(FileProgress field0)? fileProgress,
  }) {
    return fileProgress?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Start field0)? start,
    TResult Function(Stop field0)? stop,
    TResult Function(RequestToReceive field0)? requestToReceive,
    TResult Function(SendFile field0)? sendFile,
    TResult Function(StartToReceive field0)? startReceive,
    TResult Function(DiscoveryIp field0)? discoveryIp,
    TResult Function(FileProgress field0)? fileProgress,
    required TResult orElse(),
  }) {
    if (fileProgress != null) {
      return fileProgress(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(EventEnum_Start value) start,
    required TResult Function(EventEnum_Stop value) stop,
    required TResult Function(EventEnum_RequestToReceive value)
        requestToReceive,
    required TResult Function(EventEnum_SendFile value) sendFile,
    required TResult Function(EventEnum_StartReceive value) startReceive,
    required TResult Function(EventEnum_DiscoveryIp value) discoveryIp,
    required TResult Function(EventEnum_FileProgress value) fileProgress,
  }) {
    return fileProgress(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(EventEnum_Start value)? start,
    TResult? Function(EventEnum_Stop value)? stop,
    TResult? Function(EventEnum_RequestToReceive value)? requestToReceive,
    TResult? Function(EventEnum_SendFile value)? sendFile,
    TResult? Function(EventEnum_StartReceive value)? startReceive,
    TResult? Function(EventEnum_DiscoveryIp value)? discoveryIp,
    TResult? Function(EventEnum_FileProgress value)? fileProgress,
  }) {
    return fileProgress?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(EventEnum_Start value)? start,
    TResult Function(EventEnum_Stop value)? stop,
    TResult Function(EventEnum_RequestToReceive value)? requestToReceive,
    TResult Function(EventEnum_SendFile value)? sendFile,
    TResult Function(EventEnum_StartReceive value)? startReceive,
    TResult Function(EventEnum_DiscoveryIp value)? discoveryIp,
    TResult Function(EventEnum_FileProgress value)? fileProgress,
    required TResult orElse(),
  }) {
    if (fileProgress != null) {
      return fileProgress(this);
    }
    return orElse();
  }
}

abstract class EventEnum_FileProgress implements EventEnum {
  const factory EventEnum_FileProgress(final FileProgress field0) =
      _$EventEnum_FileProgressImpl;

  @override
  FileProgress get field0;
  @JsonKey(ignore: true)
  _$$EventEnum_FileProgressImplCopyWith<_$EventEnum_FileProgressImpl>
      get copyWith => throw _privateConstructorUsedError;
}
