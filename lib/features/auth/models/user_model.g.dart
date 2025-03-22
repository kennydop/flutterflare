// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  uid: json['uid'] as String,
  email: json['email'] as String,
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  photoURL: json['photoURL'] as String?,
  emailVerified: json['emailVerified'] as bool? ?? false,
  phoneNumber: json['phoneNumber'] as String?,
  bio: json['bio'] as String?,
  roles:
      (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  preferences: json['preferences'] as Map<String, dynamic>?,
  provider: json['provider'] as String?,
  createdAt:
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
  updatedAt:
      json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
  lastLoginAt:
      json['lastLoginAt'] == null
          ? null
          : DateTime.parse(json['lastLoginAt'] as String),
  isOnline: json['isOnline'] as bool? ?? false,
  fcmTokens:
      (json['fcmTokens'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'photoURL': instance.photoURL,
      'emailVerified': instance.emailVerified,
      'phoneNumber': instance.phoneNumber,
      'bio': instance.bio,
      'roles': instance.roles,
      'preferences': instance.preferences,
      'provider': instance.provider,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'lastLoginAt': instance.lastLoginAt?.toIso8601String(),
      'isOnline': instance.isOnline,
      'fcmTokens': instance.fcmTokens,
    };
