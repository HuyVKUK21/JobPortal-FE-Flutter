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
  final String? workTime;
  final ExperienceRequired? experienceRequired;
  final JobInformation? jobInformation;
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
    this.workTime,
    this.experienceRequired,
    this.jobInformation,
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
      workTime: json['workTime'],
      experienceRequired: json['experience'] != null
          ? ExperienceRequired.fromJson(json['experience'])
          : null,
      jobInformation: json['information'] != null
          ? JobInformation.fromJson(json['information'])
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
      if (jobInformation != null) 'jobInformation': jobInformation!.toJson(),
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
  final String? jobType;
  final String? workLocation;
  final String? location;
  final int? categoryId;
  final int? skillId;
  final int? page;
  final int? size;
  final String? sortBy;
  final String? sortOrder;

  JobFilterRequest({
    this.jobType,
    this.workLocation,
    this.location,
    this.categoryId,
    this.skillId,
    this.page,
    this.size,
    this.sortBy,
    this.sortOrder,
  });

  Map<String, dynamic> toJson() {
    return {
      if (jobType != null) 'jobType': jobType,
      if (workLocation != null) 'workLocation': workLocation,
      if (location != null) 'location': location,
      if (categoryId != null) 'categoryId': categoryId,
      if (skillId != null) 'skillId': skillId,
      if (page != null) 'page': page,
      if (size != null) 'size': size,
      if (sortBy != null) 'sortBy': sortBy,
      if (sortOrder != null) 'sortOrder': sortOrder,
    };
  }
}
