class NotificationModel {
  final int id;
  final String title;
  final String message;
  final String type; // 'general' or 'application'
  final bool isRead;
  final DateTime createdAt;
  final int? jobId; // Optional, for navigation to job detail
  final int? applicationId; // Optional, for navigation to application detail
  final String? companyName;
  final String? companyLogo;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
    this.jobId,
    this.applicationId,
    this.companyName,
    this.companyLogo,
  });

  // From JSON
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as int,
      title: json['title'] as String,
      message: json['message'] as String,
      type: json['type'] as String,
      isRead: json['isRead'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      jobId: json['jobId'] as int?,
      applicationId: json['applicationId'] as int?,
      companyName: json['companyName'] as String?,
      companyLogo: json['companyLogo'] as String?,
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
      'jobId': jobId,
      'applicationId': applicationId,
      'companyName': companyName,
      'companyLogo': companyLogo,
    };
  }

  // Copy with
  NotificationModel copyWith({
    int? id,
    String? title,
    String? message,
    String? type,
    bool? isRead,
    DateTime? createdAt,
    int? jobId,
    int? applicationId,
    String? companyName,
    String? companyLogo,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      jobId: jobId ?? this.jobId,
      applicationId: applicationId ?? this.applicationId,
      companyName: companyName ?? this.companyName,
      companyLogo: companyLogo ?? this.companyLogo,
    );
  }
}
