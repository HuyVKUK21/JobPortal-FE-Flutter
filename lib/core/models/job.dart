import 'package:flutter/foundation.dart';

class Job {
  final int jobId;
  final String title;
  final String description;
  final String? candidateRequirement;
  final String location;
  final String? jobType;
  final String? workLocation;
  final String? salaryRange;
  final int? salaryMin;
  final int? salaryMax;
  final String? salaryType; // RANGE, NEGOTIABLE, UP_TO, FROM, FIXED
  final String? workTime;
  final ExperienceRequired? experienceRequired;
  // Note: jobInformation is no longer returned in Job API response
  // It's now a separate table with job_id reference
  final Company? company;
  final List<Skill> skills;
  final List<Category> categories;
  final String? postedAt;
  final String? expiresAt;

  Job({
    required this.jobId,
    required this.title,
    required this.description,
    this.candidateRequirement,
    required this.location,
    this.jobType,
    this.workLocation,
    this.salaryRange,
    this.salaryMin,
    this.salaryMax,
    this.salaryType,
    this.workTime,
    this.experienceRequired,
    this.company,
    this.skills = const [],
    this.categories = const [],
    this.postedAt,
    this.expiresAt,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    // Debug logging - remove in production
    if (kDebugMode) print('🔍 Parsing Job: ${json['title']}');
    return Job(
      jobId: json['jobId'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      candidateRequirement: json['candidateRequirement'],
      location: json['location'] ?? '',
      jobType: json['jobType'],
      workLocation: json['workLocation'],
      salaryRange: json['salaryRange'],
      salaryMin: json['salaryMin'],
      salaryMax: json['salaryMax'],
      salaryType: json['salaryType'],
      workTime: json['workTime'],
      experienceRequired: json['experience'] != null
          ? ExperienceRequired.fromJson(json['experience'])
          : null,
      company: json['company'] != null
          ? Company.fromJson(json['company'])
          : null,
      skills: json['skills'] != null
          ? (json['skills'] as List)
              .map((skill) => Skill.fromJson(skill))
              .toList()
          : [],
      categories: json['categories'] != null
          ? (json['categories'] as List)
              .map((category) => Category.fromJson(category))
              .toList()
          : [],
      postedAt: json['postedAt'],
      expiresAt: json['expiresAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'jobId': jobId,
      'title': title,
      'description': description,
      if (candidateRequirement != null) 'candidateRequirement': candidateRequirement,
      'location': location,
      if (jobType != null) 'jobType': jobType,
      if (workLocation != null) 'workLocation': workLocation,
      if (salaryRange != null) 'salaryRange': salaryRange,
      if (workTime != null) 'workTime': workTime,
      if (experienceRequired != null) 'experienceRequired': experienceRequired!.toJson(),
      if (company != null) 'company': company!.toJson(),
      'skills': skills.map((skill) => skill.toJson()).toList(),
      'categories': categories.map((category) => category.toJson()).toList(),
      if (postedAt != null) 'postedAt': postedAt,
      if (expiresAt != null) 'expiresAt': expiresAt,
    };
  }
}

class ExperienceRequired {
  final int id;
  final String experiences;

  ExperienceRequired({
    required this.id,
    required this.experiences,
  });

  factory ExperienceRequired.fromJson(Map<String, dynamic> json) {
    return ExperienceRequired(
      id: json['id'] ?? 0,
      experiences: json['experiences'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'experiences': experiences,
    };
  }
}

class JobInformation {
  final String jobLevel;
  final String education;
  final int numberOfApplicants;
  final String workingForm;
  final String gender;

  JobInformation({
    required this.jobLevel,
    required this.education,
    required this.numberOfApplicants,
    required this.workingForm,
    required this.gender,
  });

  factory JobInformation.fromJson(Map<String, dynamic> json) {
    return JobInformation(
      jobLevel: json['jobLevel'] ?? '',
      education: json['education'] ?? '',
      numberOfApplicants: json['numberOfApplicants'] ?? 0,
      workingForm: json['workingForm'] ?? '',
      gender: json['gender'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'jobLevel': jobLevel,
      'education': education,
      'numberOfApplicants': numberOfApplicants,
      'workingForm': workingForm,
      'gender': gender,
    };
  }
}

class Company {
  final int companyId;
  final String name;
  final String? industry;
  final String? location;
  final String? website;

  Company({
    required this.companyId,
    required this.name,
    this.industry,
    this.location,
    this.website,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      companyId: json['companyId'] ?? 0,
      name: json['name'] ?? '',
      industry: json['industry'],
      location: json['location'],
      website: json['website'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'companyId': companyId,
      'name': name,
      if (industry != null) 'industry': industry,
      if (location != null) 'location': location,
      if (website != null) 'website': website,
    };
  }
}

class Skill {
  final int skillId;
  final String name;

  Skill({
    required this.skillId,
    required this.name,
  });

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      skillId: json['skillId'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'skillId': skillId,
      'name': name,
    };
  }
}

class Category {
  final int categoryId;
  final String name;

  Category({
    required this.categoryId,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['categoryId'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'name': name,
    };
  }
}

class JobSearchRequest {
  final String? keyword;
  final String? location;
  final List<int>? categoryIds;
  final List<int>? skillIds;
  final String? experienceLevel;
  final int? minSalary;
  final int? maxSalary;

  JobSearchRequest({
    this.keyword,
    this.location,
    this.categoryIds,
    this.skillIds,
    this.experienceLevel,
    this.minSalary,
    this.maxSalary,
  });

  Map<String, dynamic> toJson() {
    return {
      if (keyword != null) 'keyword': keyword,
      if (location != null) 'location': location,
      if (categoryIds != null) 'categoryIds': categoryIds,
      if (skillIds != null) 'skillIds': skillIds,
      if (experienceLevel != null) 'experienceLevel': experienceLevel,
      if (minSalary != null) 'minSalary': minSalary,
      if (maxSalary != null) 'maxSalary': maxSalary,
    };
  }
}

class JobFilterRequest {
  final String? title;
  final String? jobType;
  final String? workLocation;
  final String? location;
  final int? categoryId;
  final List<int>? categoryIds;
  final int? skillId;
  final List<int>? skillIds;
  final double? salaryMin;
  final double? salaryMax;
  final int? experienceRequiredId;
  final String? companyName;
  final int page;
  final int size;
  final String sortBy;
  final String sortOrder;

  JobFilterRequest({
    this.title,
    this.jobType,
    this.workLocation,
    this.location,
    this.categoryId,
    this.categoryIds,
    this.skillId,
    this.skillIds,
    this.salaryMin,
    this.salaryMax,
    this.experienceRequiredId,
    this.companyName,
    this.page = 0,
    this.size = 20,
    this.sortBy = 'postedAt',
    this.sortOrder = 'DESC',
  });

  Map<String, dynamic> toJson() {
    return {
      if (title != null) 'title': title,
      if (jobType != null) 'jobType': jobType,
      if (workLocation != null) 'workLocation': workLocation,
      if (location != null) 'location': location,
      if (categoryId != null) 'categoryId': categoryId,
      if (categoryIds != null) 'categoryIds': categoryIds,
      if (skillId != null) 'skillId': skillId,
      if (skillIds != null) 'skillIds': skillIds,
      if (salaryMin != null) 'salaryMin': salaryMin,
      if (salaryMax != null) 'salaryMax': salaryMax,
      if (experienceRequiredId != null) 'experienceRequiredId': experienceRequiredId,
      if (companyName != null) 'companyName': companyName,
      'page': page,
      'size': size,
      'sortBy': sortBy,
      'sortOrder': sortOrder,
    };
  }

  // Helper method to convert to query parameters for GET requests
  Map<String, dynamic> toQueryParams() {
    final params = <String, dynamic>{};
    
    if (title != null) params['title'] = title;
    if (location != null) params['location'] = location;
    if (categoryIds != null && categoryIds!.isNotEmpty) {
      params['categoryIds'] = categoryIds;
    }
    if (skillIds != null && skillIds!.isNotEmpty) {
      params['skillIds'] = skillIds;
    }
    if (salaryMin != null) params['salaryMin'] = salaryMin;
    if (salaryMax != null) params['salaryMax'] = salaryMax;
    if (experienceRequiredId != null) {
      params['experienceRequiredId'] = experienceRequiredId;
    }
    if (companyName != null) params['companyName'] = companyName;
    if (jobType != null) params['jobType'] = jobType;
    if (workLocation != null) params['workLocation'] = workLocation;
    
    return params;
  }

  // Helper method to check if any filters are active
  bool get hasActiveFilters {
    return title != null ||
        location != null ||
        (categoryIds != null && categoryIds!.isNotEmpty) ||
        (skillIds != null && skillIds!.isNotEmpty) ||
        salaryMin != null ||
        salaryMax != null ||
        experienceRequiredId != null ||
        companyName != null ||
        jobType != null ||
        workLocation != null;
  }

  // Count active filters
  int get activeFilterCount {
    int count = 0;
    if (title != null) count++;
    if (location != null) count++;
    if (categoryIds != null && categoryIds!.isNotEmpty) count++;
    if (skillIds != null && skillIds!.isNotEmpty) count++;
    if (salaryMin != null || salaryMax != null) count++;
    if (experienceRequiredId != null) count++;
    if (companyName != null) count++;
    if (jobType != null) count++;
    if (workLocation != null) count++;
    return count;
  }

  // Create a copy with updated fields
  JobFilterRequest copyWith({
    String? title,
    String? jobType,
    String? workLocation,
    String? location,
    int? categoryId,
    List<int>? categoryIds,
    int? skillId,
    List<int>? skillIds,
    double? salaryMin,
    double? salaryMax,
    int? experienceRequiredId,
    String? companyName,
    int? page,
    int? size,
    String? sortBy,
    String? sortOrder,
  }) {
    return JobFilterRequest(
      title: title ?? this.title,
      jobType: jobType ?? this.jobType,
      workLocation: workLocation ?? this.workLocation,
      location: location ?? this.location,
      categoryId: categoryId ?? this.categoryId,
      categoryIds: categoryIds ?? this.categoryIds,
      skillId: skillId ?? this.skillId,
      skillIds: skillIds ?? this.skillIds,
      salaryMin: salaryMin ?? this.salaryMin,
      salaryMax: salaryMax ?? this.salaryMax,
      experienceRequiredId: experienceRequiredId ?? this.experienceRequiredId,
      companyName: companyName ?? this.companyName,
      page: page ?? this.page,
      size: size ?? this.size,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  // Clear all filters
  JobFilterRequest clearFilters() {
    return JobFilterRequest(
      page: page,
      size: size,
      sortBy: sortBy,
      sortOrder: sortOrder,
    );
  }
}
