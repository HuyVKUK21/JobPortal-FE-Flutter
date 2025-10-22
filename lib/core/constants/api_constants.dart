class ApiConstants {
  // Base URL - Sử dụng IP address thay vì localhost cho Android
  // localhost:8080 - cho web/desktop
  // 10.0.2.2:8080 - cho Android emulator (localhost của host machine)
  // 192.168.x.x:8080 - cho Android device (IP thực của máy host)
  static const String baseUrl = 'http://10.0.2.2:8080/api';
  
  // Authentication endpoints
  static const String loginEndpoint = '/auth/login';
  static const String registerEmployerEndpoint = '/auth/register/employer';
  static const String registerJobSeekerEndpoint = '/job-seekers/register';
  
  // Job endpoints
  static const String jobsEndpoint = '/jobs';
  static const String jobSearchEndpoint = '/jobs/search';
  static const String jobFilterEndpoint = '/jobs/filter';
  
  // Job Seeker endpoints
  static const String jobSeekerProfileEndpoint = '/job-seekers/profile/me';
  static const String jobSeekerApplicationsEndpoint = '/job-seekers/applications';
  static const String jobSeekerSavedJobsEndpoint = '/job-seekers/saved-jobs';
  static const String applicationsEndpoint = '/applications';
  
  // Employer endpoints
  static const String employerApplicationsEndpoint = '/employer';
  static const String employerInterviewsEndpoint = '/employer';
  
  // Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
  };
  
  static Map<String, String> authHeaders(String token) {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
}
