// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) {
  return _ChatMessage.fromJson(json);
}

/// @nodoc
mixin _$ChatMessage {
  @JsonKey(name: '_id')
  String? get id => throw _privateConstructorUsedError;
  String get sender => throw _privateConstructorUsedError;
  String get receiver => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  String get companyName => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this ChatMessage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatMessageCopyWith<ChatMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatMessageCopyWith<$Res> {
  factory $ChatMessageCopyWith(
    ChatMessage value,
    $Res Function(ChatMessage) then,
  ) = _$ChatMessageCopyWithImpl<$Res, ChatMessage>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String? id,
    String sender,
    String receiver,
    String text,
    String companyName,
    DateTime? createdAt,
  });
}

/// @nodoc
class _$ChatMessageCopyWithImpl<$Res, $Val extends ChatMessage>
    implements $ChatMessageCopyWith<$Res> {
  _$ChatMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? sender = null,
    Object? receiver = null,
    Object? text = null,
    Object? companyName = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            sender: null == sender
                ? _value.sender
                : sender // ignore: cast_nullable_to_non_nullable
                      as String,
            receiver: null == receiver
                ? _value.receiver
                : receiver // ignore: cast_nullable_to_non_nullable
                      as String,
            text: null == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                      as String,
            companyName: null == companyName
                ? _value.companyName
                : companyName // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChatMessageImplCopyWith<$Res>
    implements $ChatMessageCopyWith<$Res> {
  factory _$$ChatMessageImplCopyWith(
    _$ChatMessageImpl value,
    $Res Function(_$ChatMessageImpl) then,
  ) = __$$ChatMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String? id,
    String sender,
    String receiver,
    String text,
    String companyName,
    DateTime? createdAt,
  });
}

/// @nodoc
class __$$ChatMessageImplCopyWithImpl<$Res>
    extends _$ChatMessageCopyWithImpl<$Res, _$ChatMessageImpl>
    implements _$$ChatMessageImplCopyWith<$Res> {
  __$$ChatMessageImplCopyWithImpl(
    _$ChatMessageImpl _value,
    $Res Function(_$ChatMessageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? sender = null,
    Object? receiver = null,
    Object? text = null,
    Object? companyName = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$ChatMessageImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        sender: null == sender
            ? _value.sender
            : sender // ignore: cast_nullable_to_non_nullable
                  as String,
        receiver: null == receiver
            ? _value.receiver
            : receiver // ignore: cast_nullable_to_non_nullable
                  as String,
        text: null == text
            ? _value.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String,
        companyName: null == companyName
            ? _value.companyName
            : companyName // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatMessageImpl implements _ChatMessage {
  const _$ChatMessageImpl({
    @JsonKey(name: '_id') this.id,
    required this.sender,
    required this.receiver,
    required this.text,
    required this.companyName,
    this.createdAt,
  });

  factory _$ChatMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatMessageImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String? id;
  @override
  final String sender;
  @override
  final String receiver;
  @override
  final String text;
  @override
  final String companyName;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'ChatMessage(id: $id, sender: $sender, receiver: $receiver, text: $text, companyName: $companyName, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatMessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sender, sender) || other.sender == sender) &&
            (identical(other.receiver, receiver) ||
                other.receiver == receiver) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    sender,
    receiver,
    text,
    companyName,
    createdAt,
  );

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatMessageImplCopyWith<_$ChatMessageImpl> get copyWith =>
      __$$ChatMessageImplCopyWithImpl<_$ChatMessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatMessageImplToJson(this);
  }
}

abstract class _ChatMessage implements ChatMessage {
  const factory _ChatMessage({
    @JsonKey(name: '_id') final String? id,
    required final String sender,
    required final String receiver,
    required final String text,
    required final String companyName,
    final DateTime? createdAt,
  }) = _$ChatMessageImpl;

  factory _ChatMessage.fromJson(Map<String, dynamic> json) =
      _$ChatMessageImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String? get id;
  @override
  String get sender;
  @override
  String get receiver;
  @override
  String get text;
  @override
  String get companyName;
  @override
  DateTime? get createdAt;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatMessageImplCopyWith<_$ChatMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChatParticipant _$ChatParticipantFromJson(Map<String, dynamic> json) {
  return _ChatParticipant.fromJson(json);
}

/// @nodoc
mixin _$ChatParticipant {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  String get companyName => throw _privateConstructorUsedError;

  /// Serializes this ChatParticipant to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatParticipant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatParticipantCopyWith<ChatParticipant> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatParticipantCopyWith<$Res> {
  factory $ChatParticipantCopyWith(
    ChatParticipant value,
    $Res Function(ChatParticipant) then,
  ) = _$ChatParticipantCopyWithImpl<$Res, ChatParticipant>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String phone,
    String role,
    String companyName,
  });
}

/// @nodoc
class _$ChatParticipantCopyWithImpl<$Res, $Val extends ChatParticipant>
    implements $ChatParticipantCopyWith<$Res> {
  _$ChatParticipantCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatParticipant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? phone = null,
    Object? role = null,
    Object? companyName = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            phone: null == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as String,
            companyName: null == companyName
                ? _value.companyName
                : companyName // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChatParticipantImplCopyWith<$Res>
    implements $ChatParticipantCopyWith<$Res> {
  factory _$$ChatParticipantImplCopyWith(
    _$ChatParticipantImpl value,
    $Res Function(_$ChatParticipantImpl) then,
  ) = __$$ChatParticipantImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String phone,
    String role,
    String companyName,
  });
}

/// @nodoc
class __$$ChatParticipantImplCopyWithImpl<$Res>
    extends _$ChatParticipantCopyWithImpl<$Res, _$ChatParticipantImpl>
    implements _$$ChatParticipantImplCopyWith<$Res> {
  __$$ChatParticipantImplCopyWithImpl(
    _$ChatParticipantImpl _value,
    $Res Function(_$ChatParticipantImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatParticipant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? phone = null,
    Object? role = null,
    Object? companyName = null,
  }) {
    return _then(
      _$ChatParticipantImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        phone: null == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String,
        companyName: null == companyName
            ? _value.companyName
            : companyName // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatParticipantImpl implements _ChatParticipant {
  const _$ChatParticipantImpl({
    @JsonKey(name: '_id') required this.id,
    required this.phone,
    required this.role,
    required this.companyName,
  });

  factory _$ChatParticipantImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatParticipantImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String phone;
  @override
  final String role;
  @override
  final String companyName;

  @override
  String toString() {
    return 'ChatParticipant(id: $id, phone: $phone, role: $role, companyName: $companyName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatParticipantImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, phone, role, companyName);

  /// Create a copy of ChatParticipant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatParticipantImplCopyWith<_$ChatParticipantImpl> get copyWith =>
      __$$ChatParticipantImplCopyWithImpl<_$ChatParticipantImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatParticipantImplToJson(this);
  }
}

abstract class _ChatParticipant implements ChatParticipant {
  const factory _ChatParticipant({
    @JsonKey(name: '_id') required final String id,
    required final String phone,
    required final String role,
    required final String companyName,
  }) = _$ChatParticipantImpl;

  factory _ChatParticipant.fromJson(Map<String, dynamic> json) =
      _$ChatParticipantImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get phone;
  @override
  String get role;
  @override
  String get companyName;

  /// Create a copy of ChatParticipant
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatParticipantImplCopyWith<_$ChatParticipantImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
