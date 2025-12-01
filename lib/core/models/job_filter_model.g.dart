// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_filter_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

import 'package:flutter_application_1/core/models/job.dart';

import ''; 'package:flutter_application_1/core/models/job.dart';

JobFilterRequest _$JobFilterRequestFromJson(Map<String, dynamic> json) =>
    JobFilterRequest(
      title: json['title'] as String?,
      location: json['location'] as String?,
      categoryIds: (json['categoryIds'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      skillIds: (json['skillIds'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      salaryMin: (json['salaryMin'] as num?)?.toDouble(),
      salaryMax: (json['salaryMax'] as num?)?.toDouble(),
      experienceRequiredId: (json['experienceRequiredId'] as num?)?.toInt(),
      companyName: json['companyName'] as String?,
      jobType: json['jobType'] as String?,
      workLocation: json['workLocation'] as String?,
      page: (json['page'] as num?)?.toInt() ?? 0,
      size: (json['size'] as num?)?.toInt() ?? 20,
      sortBy: json['sortBy'] as String? ?? 'postedAt',
      sortOrder: json['sortOrder'] as String? ?? 'DESC',
    );

Map<String, dynamic> _$JobFilterRequestToJson(JobFilterRequest instance) =>
    <String, dynamic>{
      'title': instance.title,
      'location': instance.location,
      'categoryIds': instance.categoryIds,
      'skillIds': instance.skillIds,
      'salaryMin': instance.salaryMin,
      'salaryMax': instance.salaryMax,
      'experienceRequiredId': instance.experienceRequiredId,
      'companyName': instance.companyName,
      'jobType': instance.jobType,
      'workLocation': instance.workLocation,
      'page': instance.page,
      'size': instance.size,
      'sortBy': instance.sortBy,
      'sortOrder': instance.sortOrder,
    };
