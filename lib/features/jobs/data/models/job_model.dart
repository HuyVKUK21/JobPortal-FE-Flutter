import 'package:flutter_application_1/features/jobs/domain/entities/job_entity.dart';

class JobModel extends JobEntity {
  const JobModel({
    required super.id,
    required super.title,
    required super.companyName,
    required super.companyLogo,
    required super.location,
    required super.workLocation,
    required super.workingTime,
    required super.salary,
    required super.description,
    required super.requirements,
    required super.skills,
    super.isSaved,
    required super.createdAt,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id'] as String,
      title: json['title'] as String,
      companyName: json['company_name'] as String,
      companyLogo: json['company_logo'] as String,
      location: json['location'] as String,
      workLocation: json['work_location'] as String,
      workingTime: json['working_time'] as String,
      salary: json['salary'] as String,
      description: json['description'] as String,
      requirements: List<String>.from(json['requirements'] as List),
      skills: List<String>.from(json['skills'] as List),
      isSaved: json['is_saved'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'company_name': companyName,
      'company_logo': companyLogo,
      'location': location,
      'work_location': workLocation,
      'working_time': workingTime,
      'salary': salary,
      'description': description,
      'requirements': requirements,
      'skills': skills,
      'is_saved': isSaved,
      'created_at': createdAt.toIso8601String(),
    };
  }

  JobEntity toEntity() {
    return JobEntity(
      id: id,
      title: title,
      companyName: companyName,
      companyLogo: companyLogo,
      location: location,
      workLocation: workLocation,
      workingTime: workingTime,
      salary: salary,
      description: description,
      requirements: requirements,
      skills: skills,
      isSaved: isSaved,
      createdAt: createdAt,
    );
  }
}


