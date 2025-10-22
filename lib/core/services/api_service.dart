import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../models/api_response.dart';
import '../models/user.dart';
import '../models/job.dart';
import '../models/application.dart';
import 'token_storage_service.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String? _token;

  String? get token => _token;

  void setToken(String token) {
    _token = token;
    TokenStorageService.saveToken(token);
  }

  void clearToken() {
    _token = null;
    TokenStorageService.clearAll();
  }

  // Initialize token from storage
  Future<void> initializeToken() async {
    _token = await TokenStorageService.getToken();
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
  Future<ApiResponse<List<Job>>> searchJobs({
    String? title,
    String? location,
    List<int>? categoryIds,
    List<int>? skillIds,
    int? salaryMin,
    int? salaryMax,
    int? experienceRequiredId,
    String? companyName,
    String? jobType,
  }) async {
    try {
      final queryParams = <String, String>{};
      
      if (title != null) queryParams['title'] = title;
      if (location != null) queryParams['location'] = location;
      if (categoryIds != null) {
        for (int i = 0; i < categoryIds.length; i++) {
          queryParams['categoryIds'] = categoryIds[i].toString();
        }
      }
      if (skillIds != null) {
        for (int i = 0; i < skillIds.length; i++) {
          queryParams['skillIds'] = skillIds[i].toString();
        }
      }
      if (salaryMin != null) queryParams['salaryMin'] = salaryMin.toString();
      if (salaryMax != null) queryParams['salaryMax'] = salaryMax.toString();
      if (experienceRequiredId != null) queryParams['experienceRequiredId'] = experienceRequiredId.toString();
      if (companyName != null) queryParams['companyName'] = companyName;
      if (jobType != null) queryParams['jobType'] = jobType;

      final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.jobSearchEndpoint}').replace(
        queryParameters: queryParams,
      );

      final response = await http.get(uri, headers: ApiConstants.defaultHeaders);

      final jsonResponse = jsonDecode(response.body);
      return ApiResponse<List<Job>>.fromJson(
        jsonResponse,
        (data) => (data as List)
            .map((job) => Job.fromJson(job))
            .toList(),
      );
    } catch (e) {
      return ApiResponse<List<Job>>(
        status: 500,
        message: 'Network error: $e',
        error: e.toString(),
      );
    }
  }

  Future<ApiResponse<List<Job>>> filterJobs({
    String? jobType,
    String? workLocation,
    String? location,
    int? categoryId,
    int? skillId,
    int page = 0,
    int size = 20,
    String? sortBy,
    String? sortOrder,
  }) async {
    try {
      final queryParams = <String, String>{};
      
      if (jobType != null) queryParams['jobType'] = jobType;
      if (workLocation != null) queryParams['workLocation'] = workLocation;
      if (location != null) queryParams['location'] = location;
      if (categoryId != null) queryParams['categoryId'] = categoryId.toString();
      if (skillId != null) queryParams['skillId'] = skillId.toString();
      queryParams['page'] = page.toString();
      queryParams['size'] = size.toString();
      if (sortBy != null) queryParams['sortBy'] = sortBy;
      if (sortOrder != null) queryParams['sortOrder'] = sortOrder;

      final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.jobFilterEndpoint}').replace(
        queryParameters: queryParams,
      );

      final response = await http.get(uri, headers: ApiConstants.defaultHeaders);

      final jsonResponse = jsonDecode(response.body);
      return ApiResponse<List<Job>>.fromJson(
        jsonResponse,
        (data) => (data as List)
            .map((job) => Job.fromJson(job))
            .toList(),
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
      print('🚀 API Request: GET $url');
      
      final response = await http.get(
        Uri.parse(url),
        headers: ApiConstants.defaultHeaders,
      );

      print('📡 API Response Status: ${response.statusCode}');
      print('📄 API Response Body: ${response.body}');

      final jsonResponse = jsonDecode(response.body);
      
      // Handle the case where data is a List directly
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
      print('❌ API Error: $e');
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
      print('🚀 API Request: GET $url');
      
      final response = await http.get(
        Uri.parse(url),
        headers: ApiConstants.defaultHeaders,
      );

      print('📡 API Response Status: ${response.statusCode}');
      print('📄 API Response Body: ${response.body}');

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
      print('❌ API Error: $e');
      return ApiResponse<Job>(
        status: 500,
        message: 'Network error: $e',
        error: e.toString(),
      );
    }
  }

  // Application APIs
  Future<ApiResponse<Application>> applyForJob(ApplicationRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.applicationsEndpoint}'),
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

  Future<ApiResponse<List<Application>>> getMyApplications() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.jobSeekerApplicationsEndpoint}'),
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

  Future<ApiResponse<Application>> getApplicationDetail(int applicationId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.applicationsEndpoint}/$applicationId'),
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

  Future<ApiResponse<void>> cancelApplication(int applicationId) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.applicationsEndpoint}/$applicationId'),
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

  // Saved Jobs APIs
  Future<ApiResponse<SavedJob>> saveJob(int jobId) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.jobSeekerSavedJobsEndpoint}/$jobId'),
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

  Future<ApiResponse<List<SavedJob>>> getSavedJobs() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.jobSeekerSavedJobsEndpoint}'),
        headers: _headers,
      );

      print('📡 Saved Jobs API Response Status: ${response.statusCode}');
      print('📄 Saved Jobs API Response Body: ${response.body}');

      final jsonResponse = jsonDecode(response.body);
      
      // Handle the case where data is a List directly
      if (jsonResponse['data'] is List) {
        final savedJobs = (jsonResponse['data'] as List)
            .map((savedJob) => SavedJob.fromJson(savedJob))
            .toList();
        return ApiResponse<List<SavedJob>>(
          status: jsonResponse['status'] ?? 0,
          message: jsonResponse['message'] ?? '',
          data: savedJobs,
        );
      }
      
      return ApiResponse<List<SavedJob>>.fromJson(
        jsonResponse,
        (data) => (data as List)
            .map((savedJob) => SavedJob.fromJson(savedJob))
            .toList(),
      );
    } catch (e) {
      print('❌ Saved Jobs API Error: $e');
      return ApiResponse<List<SavedJob>>(
        status: 500,
        message: 'Network error: $e',
        error: e.toString(),
      );
    }
  }

  Future<ApiResponse<void>> unsaveJob(int jobId) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.jobSeekerSavedJobsEndpoint}/$jobId'),
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
}
