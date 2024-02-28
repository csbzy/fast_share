// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'progress_type.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ProgressTypeEnum {
  int get field0 => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int field0) upload,
    required TResult Function(int field0) download,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int field0)? upload,
    TResult? Function(int field0)? download,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int field0)? upload,
    TResult Function(int field0)? download,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ProgressTypeEnum_Upload value) upload,
    required TResult Function(ProgressTypeEnum_Download value) download,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ProgressTypeEnum_Upload value)? upload,
    TResult? Function(ProgressTypeEnum_Download value)? download,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ProgressTypeEnum_Upload value)? upload,
    TResult Function(ProgressTypeEnum_Download value)? download,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ProgressTypeEnumCopyWith<ProgressTypeEnum> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProgressTypeEnumCopyWith<$Res> {
  factory $ProgressTypeEnumCopyWith(
          ProgressTypeEnum value, $Res Function(ProgressTypeEnum) then) =
      _$ProgressTypeEnumCopyWithImpl<$Res, ProgressTypeEnum>;
  @useResult
  $Res call({int field0});
}

/// @nodoc
class _$ProgressTypeEnumCopyWithImpl<$Res, $Val extends ProgressTypeEnum>
    implements $ProgressTypeEnumCopyWith<$Res> {
  _$ProgressTypeEnumCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_value.copyWith(
      field0: null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProgressTypeEnum_UploadImplCopyWith<$Res>
    implements $ProgressTypeEnumCopyWith<$Res> {
  factory _$$ProgressTypeEnum_UploadImplCopyWith(
          _$ProgressTypeEnum_UploadImpl value,
          $Res Function(_$ProgressTypeEnum_UploadImpl) then) =
      __$$ProgressTypeEnum_UploadImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int field0});
}

/// @nodoc
class __$$ProgressTypeEnum_UploadImplCopyWithImpl<$Res>
    extends _$ProgressTypeEnumCopyWithImpl<$Res, _$ProgressTypeEnum_UploadImpl>
    implements _$$ProgressTypeEnum_UploadImplCopyWith<$Res> {
  __$$ProgressTypeEnum_UploadImplCopyWithImpl(
      _$ProgressTypeEnum_UploadImpl _value,
      $Res Function(_$ProgressTypeEnum_UploadImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$ProgressTypeEnum_UploadImpl(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$ProgressTypeEnum_UploadImpl implements ProgressTypeEnum_Upload {
  const _$ProgressTypeEnum_UploadImpl(this.field0);

  @override
  final int field0;

  @override
  String toString() {
    return 'ProgressTypeEnum.upload(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProgressTypeEnum_UploadImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProgressTypeEnum_UploadImplCopyWith<_$ProgressTypeEnum_UploadImpl>
      get copyWith => __$$ProgressTypeEnum_UploadImplCopyWithImpl<
          _$ProgressTypeEnum_UploadImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int field0) upload,
    required TResult Function(int field0) download,
  }) {
    return upload(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int field0)? upload,
    TResult? Function(int field0)? download,
  }) {
    return upload?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int field0)? upload,
    TResult Function(int field0)? download,
    required TResult orElse(),
  }) {
    if (upload != null) {
      return upload(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ProgressTypeEnum_Upload value) upload,
    required TResult Function(ProgressTypeEnum_Download value) download,
  }) {
    return upload(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ProgressTypeEnum_Upload value)? upload,
    TResult? Function(ProgressTypeEnum_Download value)? download,
  }) {
    return upload?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ProgressTypeEnum_Upload value)? upload,
    TResult Function(ProgressTypeEnum_Download value)? download,
    required TResult orElse(),
  }) {
    if (upload != null) {
      return upload(this);
    }
    return orElse();
  }
}

abstract class ProgressTypeEnum_Upload implements ProgressTypeEnum {
  const factory ProgressTypeEnum_Upload(final int field0) =
      _$ProgressTypeEnum_UploadImpl;

  @override
  int get field0;
  @override
  @JsonKey(ignore: true)
  _$$ProgressTypeEnum_UploadImplCopyWith<_$ProgressTypeEnum_UploadImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ProgressTypeEnum_DownloadImplCopyWith<$Res>
    implements $ProgressTypeEnumCopyWith<$Res> {
  factory _$$ProgressTypeEnum_DownloadImplCopyWith(
          _$ProgressTypeEnum_DownloadImpl value,
          $Res Function(_$ProgressTypeEnum_DownloadImpl) then) =
      __$$ProgressTypeEnum_DownloadImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int field0});
}

/// @nodoc
class __$$ProgressTypeEnum_DownloadImplCopyWithImpl<$Res>
    extends _$ProgressTypeEnumCopyWithImpl<$Res,
        _$ProgressTypeEnum_DownloadImpl>
    implements _$$ProgressTypeEnum_DownloadImplCopyWith<$Res> {
  __$$ProgressTypeEnum_DownloadImplCopyWithImpl(
      _$ProgressTypeEnum_DownloadImpl _value,
      $Res Function(_$ProgressTypeEnum_DownloadImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$ProgressTypeEnum_DownloadImpl(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$ProgressTypeEnum_DownloadImpl implements ProgressTypeEnum_Download {
  const _$ProgressTypeEnum_DownloadImpl(this.field0);

  @override
  final int field0;

  @override
  String toString() {
    return 'ProgressTypeEnum.download(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProgressTypeEnum_DownloadImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProgressTypeEnum_DownloadImplCopyWith<_$ProgressTypeEnum_DownloadImpl>
      get copyWith => __$$ProgressTypeEnum_DownloadImplCopyWithImpl<
          _$ProgressTypeEnum_DownloadImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int field0) upload,
    required TResult Function(int field0) download,
  }) {
    return download(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int field0)? upload,
    TResult? Function(int field0)? download,
  }) {
    return download?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int field0)? upload,
    TResult Function(int field0)? download,
    required TResult orElse(),
  }) {
    if (download != null) {
      return download(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ProgressTypeEnum_Upload value) upload,
    required TResult Function(ProgressTypeEnum_Download value) download,
  }) {
    return download(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ProgressTypeEnum_Upload value)? upload,
    TResult? Function(ProgressTypeEnum_Download value)? download,
  }) {
    return download?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ProgressTypeEnum_Upload value)? upload,
    TResult Function(ProgressTypeEnum_Download value)? download,
    required TResult orElse(),
  }) {
    if (download != null) {
      return download(this);
    }
    return orElse();
  }
}

abstract class ProgressTypeEnum_Download implements ProgressTypeEnum {
  const factory ProgressTypeEnum_Download(final int field0) =
      _$ProgressTypeEnum_DownloadImpl;

  @override
  int get field0;
  @override
  @JsonKey(ignore: true)
  _$$ProgressTypeEnum_DownloadImplCopyWith<_$ProgressTypeEnum_DownloadImpl>
      get copyWith => throw _privateConstructorUsedError;
}
