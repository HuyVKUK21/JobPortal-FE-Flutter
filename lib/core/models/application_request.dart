
/// Request model for applying to a job
class ApplyJobRequest {
  final int jobId;
  final String coverLetter;
  final String? resume; // URL to resume file
  final int? resumeId; // ID of saved resume (optional)

  const ApplyJobRequest({
    required this.jobId,
    required this.coverLetter,
    this.resume,
    this.resumeId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'jobId': jobId,
      'coverLetter': coverLetter,
    };
    
    if (resume != null) {
      data['resume'] = resume;
    }
    
    if (resumeId != null) {
      data['resumeId'] = resumeId;
    }
    
    return data;
  }

  factory ApplyJobRequest.fromJson(Map<String, dynamic> json) {
    return ApplyJobRequest(
      jobId: json['jobId'] as int,
      coverLetter: json['coverLetter'] as String,
      resume: json['resume'] as String?,
      resumeId: json['resumeId'] as int?,
    );
  }

  @override
  String toString() {
    return 'ApplyJobRequest(jobId: $jobId, coverLetter: $coverLetter, resume: $resume, resumeId: $resumeId)';
  }
}

