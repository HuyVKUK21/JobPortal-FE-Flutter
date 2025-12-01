class SalaryFormatter {
  /// Format salary for display based on salary type
  /// 
  /// Salary Types:
  /// - RANGE: Display as "25 - 40 triệu"
  /// - NEGOTIABLE: Display as "Thỏa thuận"
  /// - UP_TO: Display as "Lên đến 30 triệu"
  /// - FROM: Display as "Từ 20 triệu"
  /// - FIXED: Display as "15 triệu"
  static String formatSalary({
    int? salaryMin,
    int? salaryMax,
    String? salaryType,
  }) {
    // Helper to convert VND to millions
    String toMillions(int? amount) {
      if (amount == null) return '';
      return (amount / 1000000).toStringAsFixed(0);
    }

    // Handle null or empty salary type
    if (salaryType == null || salaryType.isEmpty) {
      // Fallback: try to infer from min/max values
      if (salaryMin != null && salaryMax != null) {
        return '${toMillions(salaryMin)} - ${toMillions(salaryMax)} triệu';
      } else if (salaryMin != null) {
        return 'Từ ${toMillions(salaryMin)} triệu';
      } else if (salaryMax != null) {
        return 'Lên đến ${toMillions(salaryMax)} triệu';
      }
      return 'Thỏa thuận';
    }

    switch (salaryType.toUpperCase()) {
      case 'RANGE':
        if (salaryMin != null && salaryMax != null) {
          return '${toMillions(salaryMin)} - ${toMillions(salaryMax)} triệu';
        }
        return 'Thỏa thuận';

      case 'NEGOTIABLE':
        return 'Thỏa thuận';

      case 'UP_TO':
        if (salaryMax != null) {
          return 'Lên đến ${toMillions(salaryMax)} triệu';
        }
        return 'Thỏa thuận';

      case 'FROM':
        if (salaryMin != null) {
          return 'Từ ${toMillions(salaryMin)} triệu';
        }
        return 'Thỏa thuận';

      case 'FIXED':
        if (salaryMin != null) {
          return '${toMillions(salaryMin)} triệu';
        }
        return 'Thỏa thuận';

      default:
        return 'Liên hệ';
    }
  }

  /// Format salary with "/tháng" suffix
  static String formatSalaryWithPeriod({
    int? salaryMin,
    int? salaryMax,
    String? salaryType,
  }) {
    final formatted = formatSalary(
      salaryMin: salaryMin,
      salaryMax: salaryMax,
      salaryType: salaryType,
    );
    
    // Don't add "/tháng" for negotiable or contact
    if (formatted == 'Thỏa thuận' || formatted == 'Liên hệ') {
      return formatted;
    }
    
    return '$formatted /tháng';
  }
}
