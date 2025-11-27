import 'package:flutter_application_1/core/constants/network_config.dart';

class ApiConstants {
  // Base URL - Automatically selects correct URL based on platform
  // Uses NetworkConfig to handle emulator vs real device
  static String get baseUrl => NetworkConfig.baseUrl;
  
  // Authentication endpoints
  static const String loginEndpoint = '/auth/login';
  static const String registerEmployerEndpoint = '/auth/register/employer';
  static const String registerJobSeekerEndpoint = '/job-seekers/register';
  
  // Job endpoints
  static const String jobsEndpoint = '/jobs';
  static const String jobSearchEndpoint = '/jobs/search';
  static const String jobFilterEndpoint = '/jobs/filter';
  static const String jobQuickSearchEndpoint = '/jobs/quick-search';
  
  // Job Seeker endpoints
  static const String jobSeekerProfileEndpoint = '/job-seekers/profile/me';
  static const String jobSeekerApplicationsEndpoint = '/job-seekers/applications';
  static const String jobSeekerSavedJobsEndpoint = '/job-seekers/saved-jobs';
  static const String applicationsEndpoint = '/applications';
  static const String savedJobsEndpoint = '/job-seekers/saved-jobs';
  
  // Application endpoints
  static const String applyJobEndpoint = '/applications';
  static const String myApplicationsEndpoint = '/applications/seeker';
  static const String applicationDetailEndpoint = '/applications';
  
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
