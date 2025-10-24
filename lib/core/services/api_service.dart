import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../models/api_response.dart';
import '../models/user.dart';
import '../models/job.dart';
import '../models/application.dart';
import '../models/application_request.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String? _token;

  String? get token => _token;

  void setToken(String token) {
    _token = token;
  }

  void clearToken() {
    _token = null;
  }

  // Check if response indicates token expiry
  bool _isTokenExpiredResponse(http.Response response) {
    return response.statusCode == 401;
  }

  // Handle token expiry
  Future<void> _handleTokenExpiry() async {
    clearToken();
    // You might want to emit an event or call a callback here
    // to notify the app that the user needs to login again
  }

  Map<String, String> get _headers {
    if (_token != null) {
      return ApiConstants.authHeaders(_token!);
    }
    return ApiConstants.defaultHeaders;
  }

  // Authentication APIs
  Future<ApiResponse<LoginResponse>> login(LoginRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.loginEndpoint}'),
        headers: ApiConstants.defaultHeaders,
        body: jsonEncode(request.toJson()),
      );

      final jsonResponse = jsonDecode(response.body);
      final apiResponse = ApiResponse<LoginResponse>.fromJson(
        jsonResponse,
        (data) => LoginResponse.fromJson(data),
      );

      if (apiResponse.isSuccess && apiResponse.data != null) {
        setToken(apiResponse.data!.token);
      }

      return apiResponse;
    } catch (e) {
      return ApiResponse<LoginResponse>(
        status: 500,
        message: 'Network error: $e',
        error: e.toString(),
      );
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> registerEmployer(
      RegisterEmployerRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.registerEmployerEndpoint}'),
        headers: ApiConstants.defaultHeaders,
        body: jsonEncode(request.toJson()),
      );

      final jsonResponse = jsonDecode(response.body);
      return ApiResponse<Map<String, dynamic>>.fromJson(
        jsonResponse,
        (data) => data,
      );
    } catch (e) {
      return ApiResponse<Map<String, dynamic>>(
        status: 500,
        message: 'Network error: $e',
        error: e.toString(),
      );
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> registerJobSeeker(
      RegisterJobSeekerRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.registerJobSeekerEndpoint}'),
        headers: ApiConstants.defaultHeaders,
        body: jsonEncode(request.toJson()),
      );

      final jsonResponse = jsonDecode(response.body);
      return ApiResponse<Map<String, dynamic>>.fromJson(
        jsonResponse,
        (data) => data,
      );
    } catch (e) {
      return ApiResponse<Map<String, dynamic>>(
        status: 500,
        message: 'Network error: $e',
        error: e.toString(),
      );
    }
  }

  // Job Search APIs
  Future<ApiResponse<List<Job>>> searchJobs(JobSearchRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.jobSearchEndpoint}'),
        headers: ApiConstants.defaultHeaders,
        body: jsonEncode(request.toJson()),
      );

      final jsonResponse = jsonDecode(response.body);
      
      // Handle case where data is directly a List
      if (jsonResponse is List) {
        return ApiResponse<List<Job>>(
          status: response.statusCode,
          message: 'Success',
          data: jsonResponse
              .map((job) => Job.fromJson(job))
              .toList(),
        );
      }
      
      // Handle case where data is wrapped in ApiResponse format
      if (jsonResponse is Map<String, dynamic>) {
        try {
          final status = jsonResponse['status'] ?? response.statusCode;
          final message = jsonResponse['message'] ?? 'Success';
          final data = jsonResponse['data'];
          
          // Handle Page format (Spring Boot pagination)
          if (data is Map<String, dynamic> && data.containsKey('content')) {
            final content = data['content'] as List;
            return ApiResponse<List<Job>>(
              status: status,
              message: message,
              data: content
                  .map((job) => Job.fromJson(job))
                  .toList(),
            );
          }
          // Handle direct List format
          else if (data is List) {
            return ApiResponse<List<Job>>(
              status: status,
              message: message,
              data: data
                  .map((job) => Job.fromJson(job))
                  .toList(),
            );
          } else {
            return ApiResponse<List<Job>>(
              status: status,
              message: message,
              data: [],
            );
          }
        } catch (parseError) {
          return ApiResponse<List<Job>>(
            status: 500,
            message: 'Parse error: $parseError',
            error: parseError.toString(),
          );
        }
      }
      
      // Fallback - return empty list instead of error
      if (kDebugMode) print('⚠️ Unexpected response format, returning empty list');
      return ApiResponse<List<Job>>(
        status: response.statusCode,
        message: 'No results found',
        data: [],
      );
    } catch (e) {
      return ApiResponse<List<Job>>(
        status: 500,
        message: 'Network error: $e',
        error: e.toString(),
      );
    }
  }

  Future<ApiResponse<List<Job>>> quickSearch(String keyword) async {
    try {
      // Test with simple keyword if empty
      final searchKeyword = keyword.isEmpty ? 'java' : keyword;
      final url = '${ApiConstants.baseUrl}${ApiConstants.jobQuickSearchEndpoint}?keyword=$searchKeyword';
      if (kDebugMode) print('🔍 Quick Search API: $url');
      
      final response = await http.get(
        Uri.parse(url),
        headers: ApiConstants.defaultHeaders,
      );

      if (kDebugMode) {
        print('📡 Quick Search Response Status: ${response.statusCode}');
        print('📄 Quick Search Response Body: ${response.body}');
      }

      final jsonResponse = jsonDecode(response.body);
      
      // Handle case where data is directly a List
      if (jsonResponse is List) {
        return ApiResponse<List<Job>>(
          status: response.statusCode,
          message: 'Success',
          data: jsonResponse
              .map((job) => Job.fromJson(job))
              .toList(),
        );
      }
      
      // Handle case where data is wrapped in ApiResponse format
      if (jsonResponse is Map<String, dynamic>) {
        try {
          final status = jsonResponse['status'] ?? response.statusCode;
          final message = jsonResponse['message'] ?? 'Success';
          final data = jsonResponse['data'];
          
          // Handle Page format (Spring Boot pagination)
          if (data is Map<String, dynamic> && data.containsKey('content')) {
            final content = data['content'] as List;
            return ApiResponse<List<Job>>(
              status: status,
              message: message,
              data: content
                  .map((job) => Job.fromJson(job))
                  .toList(),
            );
          }
          // Handle direct List format
          else if (data is List) {
            return ApiResponse<List<Job>>(
              status: status,
              message: message,
              data: data
                  .map((job) => Job.fromJson(job))
                  .toList(),
            );
          } else {
            return ApiResponse<List<Job>>(
              status: status,
              message: message,
              data: [],
            );
          }
        } catch (parseError) {
          return ApiResponse<List<Job>>(
            status: 500,
            message: 'Parse error: $parseError',
            error: parseError.toString(),
          );
        }
      }
      
      // Fallback - return empty list instead of error
      if (kDebugMode) print('⚠️ Unexpected response format, returning empty list');
      return ApiResponse<List<Job>>(
        status: response.statusCode,
        message: 'No results found',
        data: [],
      );
    } catch (e) {
      return ApiResponse<List<Job>>(
        status: 500,
        message: 'Network error: $e',
        error: e.toString(),
      );
    }
  }

  Future<ApiResponse<List<Job>>> filterJobs(JobFilterRequest request) async {
    try {
      final url = '${ApiConstants.baseUrl}${ApiConstants.jobFilterEndpoint}';
      if (kDebugMode) {
        print('🔍 Filter Jobs API: $url');
        print('📋 Filter Request: ${jsonEncode(request.toJson())}');
      }
      
      final response = await http.post(
        Uri.parse(url),
        headers: ApiConstants.defaultHeaders,
        body: jsonEncode(request.toJson()),
      );

      if (kDebugMode) {
        print('📡 Filter Response Status: ${response.statusCode}');
        print('📄 Filter Response Body: ${response.body}');
      }

      final jsonResponse = jsonDecode(response.body);
      
      // Handle case where data is directly a List
      if (jsonResponse is List) {
        return ApiResponse<List<Job>>(
          status: response.statusCode,
          message: 'Success',
          data: jsonResponse
              .map((job) => Job.fromJson(job))
              .toList(),
        );
      }
      
      // Handle case where data is wrapped in ApiResponse format
      if (jsonResponse is Map<String, dynamic>) {
        try {
          final status = jsonResponse['status'] ?? response.statusCode;
          final message = jsonResponse['message'] ?? 'Success';
          final data = jsonResponse['data'];
          
          // Handle Page format (Spring Boot pagination)
          if (data is Map<String, dynamic> && data.containsKey('content')) {
            final content = data['content'] as List;
            return ApiResponse<List<Job>>(
              status: status,
              message: message,
              data: content
                  .map((job) => Job.fromJson(job))
                  .toList(),
            );
          }
          // Handle direct List format
          else if (data is List) {
            return ApiResponse<List<Job>>(
              status: status,
              message: message,
              data: data
                  .map((job) => Job.fromJson(job))
                  .toList(),
            );
          } else {
            return ApiResponse<List<Job>>(
              status: status,
              message: message,
              data: [],
            );
          }
        } catch (parseError) {
          return ApiResponse<List<Job>>(
            status: 500,
            message: 'Parse error: $parseError',
            error: parseError.toString(),
          );
        }
      }
      
      // Fallback - return empty list instead of error
      if (kDebugMode) print('⚠️ Unexpected response format, returning empty list');
      return ApiResponse<List<Job>>(
        status: response.statusCode,
        message: 'No results found',
        data: [],
      );
    } catch (e) {
      return ApiResponse<List<Job>>(
        status: 500,
        message: 'Network error: $e',
        error: e.toString(),
      );
    }
  }

  // Future<ApiResponse<Job>> getJobDetail(int jobId) async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse('${ApiConstants.baseUrl}${ApiConstants.jobsEndpoint}/$jobId'),
  //       headers: ApiConstants.defaultHeaders,
  //     );
  //
  //     final jsonResponse = jsonDecode(response.body);
  //     return ApiResponse<Job>.fromJson(
  //       jsonResponse,
  //       (data) => Job.fromJson(data),
  //     );
  //   } catch (e) {
  //     return ApiResponse<Job>(
  //       status: 500,
  //       message: 'Network error: $e',
  //       error: e.toString(),
  //     );
  //   }
  // }

  Future<ApiResponse<List<Job>>> getAllJobs() async {
    try {
      final url = '${ApiConstants.baseUrl}${ApiConstants.jobsEndpoint}';
      if (kDebugMode) print('🚀 API Request: GET $url');
      
      final response = await http.get(
        Uri.parse(url),
        headers: ApiConstants.defaultHeaders,
      );

      if (kDebugMode) {
        print('📡 API Response Status: ${response.statusCode}');
        print('📄 API Response Body: ${response.body}');
      }

      final jsonResponse = jsonDecode(response.body);
      
      // Handle the case where response is a List directly
      if (jsonResponse is List) {
        final jobs = jsonResponse
            .map((job) => Job.fromJson(job))
            .toList();
        return ApiResponse<List<Job>>(
          status: 200,
          message: 'Success',
          data: jobs,
        );
      }
      
      // Handle the case where data is a List
      if (jsonResponse['data'] is List) {
        final jobs = (jsonResponse['data'] as List)
            .map((job) => Job.fromJson(job))
            .toList();
        return ApiResponse<List<Job>>(
          status: jsonResponse['status'] ?? 0,
          message: jsonResponse['message'] ?? '',
          data: jobs,
        );
      }
      
      return ApiResponse<List<Job>>.fromJson(
        jsonResponse,
        (data) => (data as List)
            .map((job) => Job.fromJson(job))
            .toList(),
      );
    } catch (e) {
      if (kDebugMode) print('❌ API Error: $e');
      return ApiResponse<List<Job>>(
        status: 500,
        message: 'Network error: $e',
        error: e.toString(),
      );
    }
  }

  Future<ApiResponse<Job>> getJobDetail(int jobId) async {
    try {
      final url = '${ApiConstants.baseUrl}${ApiConstants.jobsEndpoint}/$jobId';
      if (kDebugMode) print('🚀 API Request: GET $url');
      
      final response = await http.get(
        Uri.parse(url),
        headers: ApiConstants.defaultHeaders,
      );

      if (kDebugMode) {
        print('📡 API Response Status: ${response.statusCode}');
        print('📄 API Response Body: ${response.body}');
      }

      final jsonResponse = jsonDecode(response.body);
      
      // Handle the case where data is a single Job object
      if (jsonResponse['data'] is Map<String, dynamic>) {
        final job = Job.fromJson(jsonResponse['data']);
        return ApiResponse<Job>(
          status: jsonResponse['status'] ?? 0,
          message: jsonResponse['message'] ?? '',
          data: job,
        );
      }
      
      return ApiResponse<Job>.fromJson(
        jsonResponse,
        (data) => Job.fromJson(data),
      );
    } catch (e) {
      if (kDebugMode) print('❌ API Error: $e');
      return ApiResponse<Job>(
        status: 500,
        message: 'Network error: $e',
        error: e.toString(),
      );
    }
  }


  // Saved Jobs APIs
  Future<ApiResponse<SavedJob>> saveJob(int seekerId, int jobId) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.savedJobsEndpoint}/$jobId'),
        headers: _headers,
      );

      final jsonResponse = jsonDecode(response.body);
      return ApiResponse<SavedJob>.fromJson(
        jsonResponse,
        (data) => SavedJob.fromJson(data),
      );
    } catch (e) {
      return ApiResponse<SavedJob>(
        status: 500,
        message: 'Network error: $e',
        error: e.toString(),
      );
    }
  }

  Future<ApiResponse<List<SavedJob>>> getSavedJobs(int seekerId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.savedJobsEndpoint}'),
        headers: _headers,
      );

      // Check for token expiry
      if (_isTokenExpiredResponse(response)) {
        await _handleTokenExpiry();
        return ApiResponse<List<SavedJob>>(
          status: 401,
          message: 'Token expired. Please login again.',
          data: null,
        );
      }

      final jsonResponse = jsonDecode(response.body);
      
      // Debug logging removed to prevent console spam
      
      // Handle case where data is directly a List
      if (jsonResponse is List) {
        // Processing as direct List
        return ApiResponse<List<SavedJob>>(
          status: response.statusCode,
          message: 'Success',
          data: jsonResponse
              .map((savedJob) => SavedJob.fromJson(savedJob))
              .toList(),
        );
      }
      
      // Handle case where data is wrapped in ApiResponse format
      if (jsonResponse is Map<String, dynamic>) {
        // Processing as wrapped response
        try {
          // Parse the response manually since data is a List, not Map
          final status = jsonResponse['status'] ?? 0;
          final message = jsonResponse['message'] ?? '';
          final data = jsonResponse['data'] as List?;
          
          if (data != null) {
            final savedJobs = data
                .map((savedJob) => SavedJob.fromJson(savedJob))
                .toList();
            
            return ApiResponse<List<SavedJob>>(
              status: status,
              message: message,
              data: savedJobs,
            );
          } else {
            return ApiResponse<List<SavedJob>>(
              status: status,
              message: message,
              data: [],
            );
          }
        } catch (e) {
          if (kDebugMode) print('❌ Error parsing wrapped response: $e');
          return ApiResponse<List<SavedJob>>(
            status: 500,
            message: 'Error parsing saved jobs: $e',
            error: e.toString(),
          );
        }
      }
      
      // Fallback - return empty list
      // Unknown response format, returning empty list
      return ApiResponse<List<SavedJob>>(
        status: response.statusCode,
        message: 'Unknown response format',
        data: [],
      );
    } catch (e) {
      return ApiResponse<List<SavedJob>>(
        status: 500,
        message: 'Network error: $e',
        error: e.toString(),
      );
    }
  }

  Future<ApiResponse<void>> unsaveJob(int seekerId, int jobId) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.savedJobsEndpoint}/$jobId'),
        headers: _headers,
      );

      final jsonResponse = jsonDecode(response.body);
      return ApiResponse<void>.fromJson(
        jsonResponse,
        (data) => null,
      );
    } catch (e) {
      return ApiResponse<void>(
        status: 500,
        message: 'Network error: $e',
        error: e.toString(),
      );
    }
  }

  // Employer APIs
  Future<ApiResponse<List<Application>>> getEmployerApplications(int employerId, {String? status}) async {
    try {
      String url = '${ApiConstants.baseUrl}${ApiConstants.employerApplicationsEndpoint}/$employerId/applications';
      if (status != null) {
        url += '?status=$status';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: _headers,
      );

      final jsonResponse = jsonDecode(response.body);
      return ApiResponse<List<Application>>.fromJson(
        jsonResponse,
        (data) => (data as List)
            .map((app) => Application.fromJson(app))
            .toList(),
      );
    } catch (e) {
      return ApiResponse<List<Application>>(
        status: 500,
        message: 'Network error: $e',
        error: e.toString(),
      );
    }
  }

  Future<ApiResponse<List<Application>>> getJobApplications(int jobId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.employerApplicationsEndpoint}/jobs/$jobId/applications'),
        headers: _headers,
      );

      final jsonResponse = jsonDecode(response.body);
      return ApiResponse<List<Application>>.fromJson(
        jsonResponse,
        (data) => (data as List)
            .map((app) => Application.fromJson(app))
            .toList(),
      );
    } catch (e) {
      return ApiResponse<List<Application>>(
        status: 500,
        message: 'Network error: $e',
        error: e.toString(),
      );
    }
  }

  Future<ApiResponse<Application>> getEmployerApplicationDetail(int applicationId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.employerApplicationsEndpoint}/applications/$applicationId'),
        headers: _headers,
      );

      final jsonResponse = jsonDecode(response.body);
      return ApiResponse<Application>.fromJson(
        jsonResponse,
        (data) => Application.fromJson(data),
      );
    } catch (e) {
      return ApiResponse<Application>(
        status: 500,
        message: 'Network error: $e',
        error: e.toString(),
      );
    }
  }

  Future<ApiResponse<Application>> updateApplicationStatus(
      int applicationId, ApplicationStatusUpdate request) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.employerApplicationsEndpoint}/applications/$applicationId/status'),
        headers: _headers,
        body: jsonEncode(request.toJson()),
      );

      final jsonResponse = jsonDecode(response.body);
      return ApiResponse<Application>.fromJson(
        jsonResponse,
        (data) => Application.fromJson(data),
      );
    } catch (e) {
      return ApiResponse<Application>(
        status: 500,
        message: 'Network error: $e',
        error: e.toString(),
      );
    }
  }

  // Interview APIs
  Future<ApiResponse<Interview>> scheduleInterview(
      int applicationId, InterviewRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.employerApplicationsEndpoint}/applications/$applicationId/interview'),
        headers: _headers,
        body: jsonEncode(request.toJson()),
      );

      final jsonResponse = jsonDecode(response.body);
      return ApiResponse<Interview>.fromJson(
        jsonResponse,
        (data) => Interview.fromJson(data),
      );
    } catch (e) {
      return ApiResponse<Interview>(
        status: 500,
        message: 'Network error: $e',
        error: e.toString(),
      );
    }
  }

  Future<ApiResponse<List<Interview>>> getEmployerInterviews(int employerId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.employerInterviewsEndpoint}/$employerId/interviews'),
        headers: _headers,
      );

      final jsonResponse = jsonDecode(response.body);
      return ApiResponse<List<Interview>>.fromJson(
        jsonResponse,
        (data) => (data as List)
            .map((interview) => Interview.fromJson(interview))
            .toList(),
      );
    } catch (e) {
      return ApiResponse<List<Interview>>(
        status: 500,
        message: 'Network error: $e',
        error: e.toString(),
      );
    }
  }

  Future<ApiResponse<Interview>> getInterviewDetail(int interviewId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.employerInterviewsEndpoint}/interviews/$interviewId'),
        headers: _headers,
      );

      final jsonResponse = jsonDecode(response.body);
      return ApiResponse<Interview>.fromJson(
        jsonResponse,
        (data) => Interview.fromJson(data),
      );
    } catch (e) {
      return ApiResponse<Interview>(
        status: 500,
        message: 'Network error: $e',
        error: e.toString(),
      );
    }
  }

  Future<ApiResponse<Interview>> updateInterviewStatus(int interviewId, String status) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.employerInterviewsEndpoint}/interviews/$interviewId/status?status=$status'),
        headers: _headers,
      );

      final jsonResponse = jsonDecode(response.body);
      return ApiResponse<Interview>.fromJson(
        jsonResponse,
        (data) => Interview.fromJson(data),
      );
    } catch (e) {
      return ApiResponse<Interview>(
        status: 500,
        message: 'Network error: $e',
        error: e.toString(),
      );
    }
  }

  // ==================== APPLICATION METHODS ====================

  /// Apply for a job
  Future<ApiResponse<ApplicationResponse>> applyForJob(ApplyJobRequest request) async {
    try {
      final url = '${ApiConstants.baseUrl}${ApiConstants.applyJobEndpoint}';
      if (kDebugMode) {
        print('🚀 Apply Job API: $url');
        print('📋 Apply Request: ${jsonEncode(request.toJson())}');
        print('🔑 Using token: ${_token != null ? "Yes" : "No"}');
      }
      
      final response = await http.post(
        Uri.parse(url),
        headers: _headers,
        body: jsonEncode(request.toJson()),
      );

      if (kDebugMode) {
        print('📡 Apply Response Status: ${response.statusCode}');
        print('📄 Apply Response Body: ${response.body}');
      }

      final jsonResponse = jsonDecode(response.body);
      
      return ApiResponse<ApplicationResponse>.fromJson(
        jsonResponse,
        (data) => ApplicationResponse.fromJson(data),
      );
    } catch (e) {
      if (kDebugMode) print('❌ Apply Job Error: $e');
      return ApiResponse<ApplicationResponse>(
        status: 500,
        message: 'Network error: $e',
        error: e.toString(),
      );
    }
  }

  /// Get my applications
  Future<ApiResponse<List<ApplicationResponse>>> getMyApplications(int seekerId) async {
    try {
      final url = '${ApiConstants.baseUrl}${ApiConstants.myApplicationsEndpoint}/$seekerId';
      if (kDebugMode) print('🚀 My Applications API: $url');
      
      final response = await http.get(
        Uri.parse(url),
        headers: ApiConstants.defaultHeaders,
      );

      if (kDebugMode) {
        print('📡 My Applications Response Status: ${response.statusCode}');
        print('📄 My Applications Response Body: ${response.body}');
      }

      final jsonResponse = jsonDecode(response.body);
      
      // Handle the case where data is a List directly
      if (jsonResponse['data'] is List) {
        final applications = (jsonResponse['data'] as List)
            .map((app) => ApplicationResponse.fromJson(app))
            .toList();
        return ApiResponse<List<ApplicationResponse>>(
          status: jsonResponse['status'] ?? 200,
          message: jsonResponse['message'] ?? 'Success',
          data: applications,
        );
      }
      
      return ApiResponse<List<ApplicationResponse>>.fromJson(
        jsonResponse,
        (data) => (data as List)
            .map((app) => ApplicationResponse.fromJson(app))
            .toList(),
      );
    } catch (e) {
      if (kDebugMode) print('❌ My Applications Error: $e');
      return ApiResponse<List<ApplicationResponse>>(
        status: 500,
        message: 'Network error: $e',
        error: e.toString(),
      );
    }
  }

  /// Get application detail
  Future<ApiResponse<ApplicationResponse>> getApplicationDetail(int applicationId) async {
    try {
      final url = '${ApiConstants.baseUrl}${ApiConstants.applicationDetailEndpoint}/$applicationId';
      if (kDebugMode) print('🚀 Application Detail API: $url');
      
      final response = await http.get(
        Uri.parse(url),
        headers: ApiConstants.defaultHeaders,
      );

      if (kDebugMode) {
        print('📡 Application Detail Response Status: ${response.statusCode}');
        print('📄 Application Detail Response Body: ${response.body}');
      }

      final jsonResponse = jsonDecode(response.body);
      
      return ApiResponse<ApplicationResponse>.fromJson(
        jsonResponse,
        (data) => ApplicationResponse.fromJson(data),
      );
    } catch (e) {
      if (kDebugMode) print('❌ Application Detail Error: $e');
      return ApiResponse<ApplicationResponse>(
        status: 500,
        message: 'Network error: $e',
        error: e.toString(),
      );
    }
  }

  /// Cancel application
  Future<ApiResponse<void>> cancelApplication(int applicationId) async {
    try {
      final url = '${ApiConstants.baseUrl}${ApiConstants.applicationDetailEndpoint}/$applicationId';
      if (kDebugMode) print('🚀 Cancel Application API: $url');
      
      final response = await http.delete(
        Uri.parse(url),
        headers: ApiConstants.defaultHeaders,
      );

      if (kDebugMode) {
        print('📡 Cancel Application Response Status: ${response.statusCode}');
        print('📄 Cancel Application Response Body: ${response.body}');
      }

      final jsonResponse = jsonDecode(response.body);
      
      return ApiResponse<void>.fromJson(
        jsonResponse,
        (data) => null,
      );
    } catch (e) {
      if (kDebugMode) print('❌ Cancel Application Error: $e');
      return ApiResponse<void>(
        status: 500,
        message: 'Network error: $e',
        error: e.toString(),
      );
    }
  }
}
