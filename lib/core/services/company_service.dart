import 'package:flutter_application_1/core/models/company_model.dart';
import 'package:flutter_application_1/core/services/api_service.dart';

/// Service layer for company-related API calls
/// Follows single responsibility principle
class CompanyService {
  final ApiService _apiService;

  CompanyService(this._apiService);

  /// Get list of all companies with optional filters
  /// Used for: Company listing, search, filtering
  Future<CompanyListResponse> getCompanies({
    int page = 1,
    int limit = 10,
    String? search,
    String? industry,
    String? sortBy,
    String? order,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }
      if (industry != null && industry.isNotEmpty) {
        queryParams['industry'] = industry;
      }
      if (sortBy != null) {
        queryParams['sortBy'] = sortBy;
      }
      if (order != null) {
        queryParams['order'] = order;
      }

      final response = await _apiService.get(
        '/companies',
        queryParameters: queryParams,
      );

      return CompanyListResponse.fromJson(response['data']);
    } catch (e) {
      throw Exception('Failed to fetch companies: $e');
    }
  }

  /// Get company details by ID including jobs
  /// Used for: Company detail page
  /// Returns: CompanyDetails with embedded jobs array
  Future<CompanyDetails> getCompanyById(int companyId) async {
    try {
      final response = await _apiService.get('/companies/$companyId');
      return CompanyDetails.fromJson(response['data']);
    } catch (e) {
      throw Exception('Failed to fetch company details: $e');
    }
  }

  /// Get jobs of a specific company (alternative endpoint)
  /// Used for: Paginated job listing for a company
  Future<Map<String, dynamic>> getCompanyJobs({
    required int companyId,
    int page = 1,
    int limit = 10,
    String? status,
    String? sortBy,
    String? order,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (status != null) {
        queryParams['status'] = status;
      }
      if (sortBy != null) {
        queryParams['sortBy'] = sortBy;
      }
      if (order != null) {
        queryParams['order'] = order;
      }

      final response = await _apiService.get(
        '/companies/$companyId/jobs',
        queryParameters: queryParams,
      );

      return response['data'] as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to fetch company jobs: $e');
    }
  }

  /// Get featured companies (top companies with most jobs)
  /// Used for: Home page featured section
  Future<List<Company>> getFeaturedCompanies({int limit = 6}) async {
    try {
      final response = await getCompanies(
        page: 1,
        limit: limit,
        sortBy: 'totalJobs',
        order: 'desc',
      );
      return response.companies;
    } catch (e) {
      throw Exception('Failed to fetch featured companies: $e');
    }
  }
}
