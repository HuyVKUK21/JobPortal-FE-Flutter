class JobEntity {
  final String id;
  final String title;
  final String companyName;
  final String companyLogo;
  final String location;
  final String workLocation;
  final String workingTime;
  final String salary;
  final String description;
  final List<String> requirements;
  final List<String> skills;
  final bool isSaved;
  final DateTime createdAt;

  const JobEntity({
    required this.id,
    required this.title,
    required this.companyName,
    required this.companyLogo,
    required this.location,
    required this.workLocation,
    required this.workingTime,
    required this.salary,
    required this.description,
    required this.requirements,
    required this.skills,
    this.isSaved = false,
    required this.createdAt,
  });

  JobEntity copyWith({
    String? id,
    String? title,
    String? companyName,
    String? companyLogo,
    String? location,
    String? workLocation,
    String? workingTime,
    String? salary,
    String? description,
    List<String>? requirements,
    List<String>? skills,
    bool? isSaved,
    DateTime? createdAt,
  }) {
    return JobEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      companyName: companyName ?? this.companyName,
      companyLogo: companyLogo ?? this.companyLogo,
      location: location ?? this.location,
      workLocation: workLocation ?? this.workLocation,
      workingTime: workingTime ?? this.workingTime,
      salary: salary ?? this.salary,
      description: description ?? this.description,
      requirements: requirements ?? this.requirements,
      skills: skills ?? this.skills,
      isSaved: isSaved ?? this.isSaved,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}


