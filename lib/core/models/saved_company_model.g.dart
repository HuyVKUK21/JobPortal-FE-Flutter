// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_company_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SavedCompany _$SavedCompanyFromJson(Map<String, dynamic> json) => SavedCompany(
  id: (json['id'] as num).toInt(),
  company: Company.fromJson(json['company'] as Map<String, dynamic>),
  savedAt: DateTime.parse(json['savedAt'] as String),
);

Map<String, dynamic> _$SavedCompanyToJson(SavedCompany instance) =>
    <String, dynamic>{
      'id': instance.id,
      'company': instance.company,
      'savedAt': instance.savedAt.toIso8601String(),
    };
