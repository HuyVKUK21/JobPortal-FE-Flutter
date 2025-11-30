import 'package:flutter_application_1/core/models/job.dart';

class Application {
  final int applicationId;
  final int jobId;
  final String jobTitle;
  final int seekerId;
  final String seekerFirstName;
  final String seekerLastName;
  final String seekerEmail;
  final String? seekerPhone;
  final String status;
  final String appliedAt;
  final String? coverLetter;
  final String? resume;
  final Company? company;

  Application({
    required this.applicationId,
    required this.jobId,
    required this.jobTitle,
    required this.seekerId,
    required this.seekerFirstName,
    required this.seekerLastName,
    required this.seekerEmail,
    this.seekerPhone,
    required this.status,
    required this.appliedAt,
    this.coverLetter,
    this.resume,
    this.company,
  });

  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      applicationId: json['applicationId'] ?? 0,
      jobId: json['jobId'] ?? 0,
      jobTitle: json['jobTitle'] ?? '',
      seekerId: json['seekerId'] ?? 0,
      seekerFirstName: json['seekerFirstName'] ?? '',
      seekerLastName: json['seekerLastName'] ?? '',
      seekerEmail: json['seekerEmail'] ?? '',
      seekerPhone: json['seekerPhone'],
      status: json['status'] ?? '',
      appliedAt: json['appliedAt'] ?? '',
      coverLetter: json['coverLetter'],
      resume: json['resume'],
      company: json['company'] != null
          ? Company.fromJson(json['company'])
          : null,
    );
  }

  String get seekerFullName => '$seekerFirstName $seekerLastName';
}

class ApplicationRequest {
  final int jobId;
  final int seekerId;
  final String coverLetter;
  final String? resume;

  ApplicationRequest({
    required this.jobId,
    required this.seekerId,
    required this.coverLetter,
    this.resume,
  });

  Map<String, dynamic> toJson() {
    return {
      'jobId': jobId,
      'seekerId': seekerId,
      'coverLetter': coverLetter,
      if (resume != null) 'resume': resume,
    };
  }
}

class ApplicationStatusUpdate {
  final String status;
  final String? notes;

  ApplicationStatusUpdate({
    required this.status,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      if (notes != null) 'notes': notes,
    };
  }
}

class SavedJob {
  final int id;
  final Job? job;
  final String savedAt;

  SavedJob({
    required this.id,
    this.job,
    required this.savedAt,
  });

  // Getter for jobId for easier access
  int? get jobId => job?.jobId;

  factory SavedJob.fromJson(Map<String, dynamic> json) {
    return SavedJob(
      id: json['id'] ?? 0,
      job: json['job'] != null ? Job.fromJson(json['job']) : null,
      savedAt: json['savedAt'] ?? '',
    );
  }
}

class Interview {
  final int interviewId;
  final int applicationId;
  final int jobId;
  final String jobTitle;
  final int seekerId;
  final String seekerFirstName;
  final String seekerLastName;
  final String seekerEmail;
  final String scheduleTime;
  final String mode;
  final String status;
  final String? location;
  final String? notes;

  Interview({
    required this.interviewId,
    required this.applicationId,
    required this.jobId,
    required this.jobTitle,
    required this.seekerId,
    required this.seekerFirstName,
    required this.seekerLastName,
    required this.seekerEmail,
    required this.scheduleTime,
    required this.mode,
    required this.status,
    this.location,
    this.notes,
  });

  factory Interview.fromJson(Map<String, dynamic> json) {
    return Interview(
      interviewId: json['interviewId'] ?? 0,
      applicationId: json['applicationId'] ?? 0,
      jobId: json['jobId'] ?? 0,
      jobTitle: json['jobTitle'] ?? '',
      seekerId: json['seekerId'] ?? 0,
      seekerFirstName: json['seekerFirstName'] ?? '',
      seekerLastName: json['seekerLastName'] ?? '',
      seekerEmail: json['seekerEmail'] ?? '',
      scheduleTime: json['scheduleTime'] ?? '',
      mode: json['mode'] ?? '',
      status: json['status'] ?? '',
      location: json['location'],
      notes: json['notes'],
    );
  }

  String get seekerFullName => '$seekerFirstName $seekerLastName';
}

class InterviewRequest {
  final String scheduleTime;
  final String mode;
  final String? location;
  final String? notes;

  InterviewRequest({
    required this.scheduleTime,
    required this.mode,
    this.location,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'scheduleTime': scheduleTime,
      'mode': mode,
      if (location != null) 'location': location,
      if (notes != null) 'notes': notes,
    };
  }
}

class ApplicationResponse {
  final int applicationId;
  final int jobId;
  final String? jobTitle;
  final int seekerId;
  final String? seekerFirstName;
  final String? seekerLastName;
  final String? seekerEmail;
  final String? seekerPhone;
  final String status;
  final String appliedAt;
  final String? coverLetter;
  final String? resume;
  final Job? job;
  final Company? company;

  ApplicationResponse({
    required this.applicationId,
    required this.jobId,
    this.jobTitle,
    required this.seekerId,
    this.seekerFirstName,
    this.seekerLastName,
    this.seekerEmail,
    this.seekerPhone,
    required this.status,
    required this.appliedAt,
    this.coverLetter,
    this.resume,
    this.job,
    this.company,
  });

  factory ApplicationResponse.fromJson(Map<String, dynamic> json) {
    return ApplicationResponse(
      applicationId: json['applicationId'] ?? 0,
      jobId: json['jobId'] ?? 0,
      jobTitle: json['jobTitle'],
      seekerId: json['seekerId'] ?? 0,
      seekerFirstName: json['seekerFirstName'],
      seekerLastName: json['seekerLastName'],
      seekerEmail: json['seekerEmail'],
      seekerPhone: json['seekerPhone'],
      status: json['status'] ?? '',
      appliedAt: json['appliedAt'] ?? '',
      coverLetter: json['coverLetter'],
      resume: json['resume'],
      job: json['job'] != null ? Job.fromJson(json['job']) : null,
      company: json['company'] != null ? Company.fromJson(json['company']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'applicationId': applicationId,
      'jobId': jobId,
      if (jobTitle != null) 'jobTitle': jobTitle,
      'seekerId': seekerId,
      if (seekerFirstName != null) 'seekerFirstName': seekerFirstName,
      if (seekerLastName != null) 'seekerLastName': seekerLastName,
      if (seekerEmail != null) 'seekerEmail': seekerEmail,
      if (seekerPhone != null) 'seekerPhone': seekerPhone,
      'status': status,
      'appliedAt': appliedAt,
      if (coverLetter != null) 'coverLetter': coverLetter,
      if (resume != null) 'resume': resume,
      if (job != null) 'job': job!.toJson(),
      if (company != null) 'company': company!.toJson(),
    };
  }
}





