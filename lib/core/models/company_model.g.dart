// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Company _$CompanyFromJson(Map<String, dynamic> json) => Company(
  id: (json['companyId'] as num).toInt(),
  name: json['name'] as String,
  industry: json['industry'] as String,
  location: json['location'] as String,
  website: json['website'] as String?,
  email: json['email'] as String?,
  phone: json['phone'] as String?,
  description: json['description'] as String,
  logo: json['logo'] as String?,
  coverImage: json['coverImage'] as String?,
  foundedYear: (json['foundedYear'] as num?)?.toInt(),
  employeeCount: (json['employeeCount'] as num?)?.toInt(),
  totalJobs: (json['totalJobs'] as num).toInt(),
  address: json['address'] as String?,
  socialLinks: json['socialLinks'] == null
      ? null
      : SocialLinks.fromJson(json['socialLinks'] as Map<String, dynamic>),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$CompanyToJson(Company instance) => <String, dynamic>{
  'companyId': instance.id,
  'name': instance.name,
  'industry': instance.industry,
  'location': instance.location,
  'website': instance.website,
  'email': instance.email,
  'phone': instance.phone,
  'description': instance.description,
  'logo': instance.logo,
  'coverImage': instance.coverImage,
  'foundedYear': instance.foundedYear,
  'employeeCount': instance.employeeCount,
  'totalJobs': instance.totalJobs,
  'address': instance.address,
  'socialLinks': instance.socialLinks,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

CompanyDetails _$CompanyDetailsFromJson(Map<String, dynamic> json) =>
    CompanyDetails(
      id: (json['companyId'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
      industry: json['industry'] as String,
      location: json['location'] as String,
      website: json['website'] as String?,
      logoUrl: json['logoUrl'] as String?,
      jobs: (json['jobs'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
    );

Map<String, dynamic> _$CompanyDetailsToJson(CompanyDetails instance) =>
    <String, dynamic>{
      'companyId': instance.id,
      'name': instance.name,
      'description': instance.description,
      'industry': instance.industry,
      'location': instance.location,
      'website': instance.website,
      'logoUrl': instance.logoUrl,
      'jobs': instance.jobs,
    };

SocialLinks _$SocialLinksFromJson(Map<String, dynamic> json) => SocialLinks(
  facebook: json['facebook'] as String?,
  linkedin: json['linkedin'] as String?,
  twitter: json['twitter'] as String?,
);

Map<String, dynamic> _$SocialLinksToJson(SocialLinks instance) =>
    <String, dynamic>{
      'facebook': instance.facebook,
      'linkedin': instance.linkedin,
      'twitter': instance.twitter,
    };

CompanyListResponse _$CompanyListResponseFromJson(Map<String, dynamic> json) =>
    CompanyListResponse(
      companies: (json['companies'] as List<dynamic>)
          .map((e) => Company.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: Pagination.fromJson(
        json['pagination'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$CompanyListResponseToJson(
  CompanyListResponse instance,
) => <String, dynamic>{
  'companies': instance.companies,
  'pagination': instance.pagination,
};

Pagination _$PaginationFromJson(Map<String, dynamic> json) => Pagination(
  page: (json['page'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
  total: (json['total'] as num).toInt(),
  totalPages: (json['totalPages'] as num).toInt(),
);

Map<String, dynamic> _$PaginationToJson(Pagination instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
      'total': instance.total,
      'totalPages': instance.totalPages,
    };
