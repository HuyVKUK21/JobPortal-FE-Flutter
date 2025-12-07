class Resume {
  final int? resumeId;
  final int? seekerId;
  final String? resumeFile;  // Changed from downloadUrl
  final String? originalFilename;  // Changed from fileName
  final int? fileSize;
  final String? contentType;  // Added
  final DateTime? uploadedAt;
  final bool? isDefault;

  Resume({
    this.resumeId,
    this.seekerId,
    this.resumeFile,
    this.originalFilename,
    this.fileSize,
    this.contentType,
    this.uploadedAt,
    this.isDefault,
  });

  factory Resume.fromJson(Map<String, dynamic> json) {
    return Resume(
      resumeId: json['resumeId'] as int?,
      seekerId: json['seekerId'] as int?,
      resumeFile: json['resumeFile'] as String?,
      originalFilename: json['originalFilename'] as String?,
      fileSize: json['fileSize'] as int?,
      contentType: json['contentType'] as String?,
      uploadedAt: json['uploadedAt'] != null
          ? DateTime.tryParse(json['uploadedAt'] as String)
          : null,
      isDefault: json['isDefault'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'resumeId': resumeId,
      'seekerId': seekerId,
      'resumeFile': resumeFile,
      'originalFilename': originalFilename,
      'fileSize': fileSize,
      'contentType': contentType,
      'uploadedAt': uploadedAt?.toIso8601String(),
      'isDefault': isDefault,
    };
  }

  // Helper to format file size
  String get formattedFileSize {
    if (fileSize == null) return 'N/A';
    if (fileSize! < 1024) return '$fileSize B';
    if (fileSize! < 1048576) return '${(fileSize! / 1024).toStringAsFixed(1)} KB';
    return '${(fileSize! / 1048576).toStringAsFixed(1)} MB';
  }
}
