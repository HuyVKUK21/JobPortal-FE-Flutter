class ProfileResponse {
  final int seekerId;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final String? portfolioLink;
  final String? summary;
  final String? address;
  final String? avatarUrl;
  final String? currentPosition;
  final int? expectedSalaryMin;
  final int? expectedSalaryMax;
  final String? expectedSalaryFrequency;
  final List<EducationDTO> educations;
  final List<WorkExperienceDTO> workExperiences;
  final List<SkillDTO> skills;

  ProfileResponse({
    required this.seekerId,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    this.portfolioLink,
    this.summary,
    this.address,
    this.avatarUrl,
    this.currentPosition,
    this.expectedSalaryMin,
    this.expectedSalaryMax,
    this.expectedSalaryFrequency,
    this.educations = const [],
    this.workExperiences = const [],
    this.skills = const [],
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      seekerId: json['seekerId'] ?? 0,
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      portfolioLink: json['portfolioLink'],
      summary: json['summary'],
      address: json['address'],
      avatarUrl: json['avatarUrl'],
      currentPosition: json['currentPosition'],
      expectedSalaryMin: json['expectedSalaryMin'],
      expectedSalaryMax: json['expectedSalaryMax'],
      expectedSalaryFrequency: json['expectedSalaryFrequency'],
      educations: json['educations'] != null
          ? (json['educations'] as List)
              .map((e) => EducationDTO.fromJson(e))
              .toList()
          : [],
      workExperiences: json['workExperiences'] != null
          ? (json['workExperiences'] as List)
              .map((e) => WorkExperienceDTO.fromJson(e))
              .toList()
          : [],
      skills: json['skills'] != null
          ? (json['skills'] as List).map((e) => SkillDTO.fromJson(e)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'seekerId': seekerId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'portfolioLink': portfolioLink,
      'summary': summary,
      'address': address,
      'avatarUrl': avatarUrl,
      'currentPosition': currentPosition,
      'expectedSalaryMin': expectedSalaryMin,
      'expectedSalaryMax': expectedSalaryMax,
      'expectedSalaryFrequency': expectedSalaryFrequency,
      'educations': educations.map((e) => e.toJson()).toList(),
      'workExperiences': workExperiences.map((e) => e.toJson()).toList(),
      'skills': skills.map((e) => e.toJson()).toList(),
    };
  }
}

class UpdateProfileRequest {
  final String? portfolioLink;
  final String? summary;
  final String? address;
  final String? avatarUrl;
  final String? currentPosition;
  final int? expectedSalaryMin;
  final int? expectedSalaryMax;
  final String? expectedSalaryFrequency;
  final List<int>? skillIds;
  final List<EducationDTO>? educations;
  final List<WorkExperienceDTO>? workExperiences;

  UpdateProfileRequest({
    this.portfolioLink,
    this.summary,
    this.address,
    this.avatarUrl,
    this.currentPosition,
    this.expectedSalaryMin,
    this.expectedSalaryMax,
    this.expectedSalaryFrequency,
    this.skillIds,
    this.educations,
    this.workExperiences,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    
    if (portfolioLink != null) data['portfolioLink'] = portfolioLink;
    if (summary != null) data['summary'] = summary;
    if (address != null) data['address'] = address;
    if (avatarUrl != null) data['avatarUrl'] = avatarUrl;
    if (currentPosition != null) data['currentPosition'] = currentPosition;
    if (expectedSalaryMin != null) data['expectedSalaryMin'] = expectedSalaryMin;
    if (expectedSalaryMax != null) data['expectedSalaryMax'] = expectedSalaryMax;
    if (expectedSalaryFrequency != null) data['expectedSalaryFrequency'] = expectedSalaryFrequency;
    if (skillIds != null) data['skillIds'] = skillIds;
    if (educations != null) data['educations'] = educations!.map((e) => e.toJson()).toList();
    if (workExperiences != null) data['workExperiences'] = workExperiences!.map((e) => e.toJson()).toList();
    
    return data;
  }
}

class EducationDTO {
  final String institution;
  final String degree;
  final String fieldOfStudy;
  final String startDate;
  final String? endDate;

  EducationDTO({
    required this.institution,
    required this.degree,
    required this.fieldOfStudy,
    required this.startDate,
    this.endDate,
  });

  factory EducationDTO.fromJson(Map<String, dynamic> json) {
    return EducationDTO(
      institution: json['institution'] ?? '',
      degree: json['degree'] ?? '',
      fieldOfStudy: json['fieldOfStudy'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'institution': institution,
      'degree': degree,
      'fieldOfStudy': fieldOfStudy,
      'startDate': startDate,
      'endDate': endDate,
    };
  }
}

class WorkExperienceDTO {
  final String company;
  final String position;
  final String startDate;
  final String? endDate;
  final String description;

  WorkExperienceDTO({
    required this.company,
    required this.position,
    required this.startDate,
    this.endDate,
    required this.description,
  });

  factory WorkExperienceDTO.fromJson(Map<String, dynamic> json) {
    return WorkExperienceDTO(
      company: json['company'] ?? '',
      position: json['position'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'],
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company': company,
      'position': position,
      'startDate': startDate,
      'endDate': endDate,
      'description': description,
    };
  }
}

class SkillDTO {
  final int skillId;
  final String skillName;

  SkillDTO({
    required this.skillId,
    required this.skillName,
  });

  factory SkillDTO.fromJson(Map<String, dynamic> json) {
    return SkillDTO(
      skillId: json['skillId'] ?? 0,
      skillName: json['skillName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'skillId': skillId,
      'skillName': skillName,
    };
  }
}
