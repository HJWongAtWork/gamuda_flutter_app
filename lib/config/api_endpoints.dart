class ApiEndpoints {
  // This will be your only changing variable between dev/prod
  static const String baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://localhost:8000', // Default for local development
  );

  // All endpoints using the base URL
  static final auth = _AuthEndpoints();
  static final users = _UserEndpoints();
  static final analytics = _AnalyticsEndpoints();
}

class _AuthEndpoints {
  final String login = '${ApiEndpoints.baseUrl}/login';
  final String register = '${ApiEndpoints.baseUrl}/register';
  final String accountDetails = '${ApiEndpoints.baseUrl}/account/details';
  final String updateAccount = '${ApiEndpoints.baseUrl}/account/update';
  final String deleteAccount = '${ApiEndpoints.baseUrl}/account/delete';
}

class _UserEndpoints {
  final String allUsers = '${ApiEndpoints.baseUrl}/users/all';
}

class _AnalyticsEndpoints {
  final String byCity = '${ApiEndpoints.baseUrl}/analytics/by_city';
  final String byAgeRange = '${ApiEndpoints.baseUrl}/analytics/by_age_range';
  final String salaryHistogram =
      '${ApiEndpoints.baseUrl}/analytics/salary_histogram';
}
