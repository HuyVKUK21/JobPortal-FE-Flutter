import 'package:json_annotation/json_annotation.dart';

part 'company_model.g.dart';

/// Company model for list view (GET /api/companies)
@JsonSerializable()
class Company {
  @JsonKey(name: 'companyId')
  final int id;
  
  final String name;
  final String industry;
  final String location;
  final String? website;
  final String? email;
  final String? phone;
  final String description;
  final String? logo;
  final String? coverImage;
  final int? foundedYear;
  final int? employeeCount;
  final int totalJobs;
  final String? address;
  final SocialLinks? socialLinks;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Company({
    required this.id,
    required this.name,
    required this.industry,
    required this.location,
    this.website,
    this.email,
    this.phone,
    required this.description,
    this.logo,
    this.coverImage,
    this.foundedYear,
    this.employeeCount,
    required this.totalJobs,
    this.address,
    this.socialLinks,
    this.createdAt,
    this.updatedAt,
  });

  factory Company.fromJson(Map<String, dynamic> json) => _$CompanyFromJson(json);
  Map<String, dynamic> toJson() => _$CompanyToJson(this);
}

/// Company details with jobs (GET /api/companies/{id})
@JsonSerializable()
class CompanyDetails {
  @JsonKey(name: 'companyId')
  final int id;
  
  final String name;
  final String? description;
  final String industry;
  final String location;
  final String? website;
  final String? logoUrl;
  
  /// Raw job data - will be parsed to Job model in UI layer
  final List<Map<String, dynamic>> jobs;

  CompanyDetails({
    required this.id,
    required this.name,
    this.description,
    required this.industry,
    required this.location,
    this.website,
    this.logoUrl,
    required this.jobs,
  });

  factory CompanyDetails.fromJson(Map<String, dynamic> json) => _$CompanyDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$CompanyDetailsToJson(this);
}

@JsonSerializable()
class SocialLinks {
  final String? facebook;
  final String? linkedin;
  final String? twitter;

  SocialLinks({
    this.facebook,
    this.linkedin,
    this.twitter,
  });

  factory SocialLinks.fromJson(Map<String, dynamic> json) => _$SocialLinksFromJson(json);
  Map<String, dynamic> toJson() => _$SocialLinksToJson(this);
}

@JsonSerializable()
class CompanyListResponse {
  final List<Company> companies;
  final Pagination pagination;

  CompanyListResponse({
    required this.companies,
    required this.pagination,
  });

  factory CompanyListResponse.fromJson(Map<String, dynamic> json) => _$CompanyListResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CompanyListResponseToJson(this);
}

@JsonSerializable()
class Pagination {
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  Pagination({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => _$PaginationFromJson(json);
  Map<String, dynamic> toJson() => _$PaginationToJson(this);
}
