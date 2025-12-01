import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_application_1/core/models/company_model.dart';

part 'saved_company_model.g.dart';

@JsonSerializable()
class SavedCompany {
  final int id;
  final Company company;
  final DateTime savedAt;

  SavedCompany({
    required this.id,
    required this.company,
    required this.savedAt,
  });

  factory SavedCompany.fromJson(Map<String, dynamic> json) => _$SavedCompanyFromJson(json);
  Map<String, dynamic> toJson() => _$SavedCompanyToJson(this);
}
