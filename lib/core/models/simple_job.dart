class SimpleJob {
  final int jobId;
  final String title;
  final String description;
  final String location;
  final String? salaryRange;

  SimpleJob({
    required this.jobId,
    required this.title,
    required this.description,
    required this.location,
    this.salaryRange,
  });

  factory SimpleJob.fromJson(Map<String, dynamic> json) {
    return SimpleJob(
      jobId: json['jobId'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      salaryRange: json['salaryRange'],
    );
  }
}





