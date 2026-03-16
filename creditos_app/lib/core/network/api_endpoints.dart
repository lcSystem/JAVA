/// Centralized API endpoint constants.
class ApiEndpoints {
  // Auth
  static const String login = '/api/client/auth/login';
  static const String refresh = '/api/client/auth/refresh';
  static const String logout = '/api/client/auth/logout';
  static const String changePassword = '/api/client/auth/change-password';

  // Profile
  static const String profile = '/api/client/perfil';

  // Credits
  static const String creditTypes = '/api/credit-types';
  static const String creditRequests = '/api/credit-requests';
  static const String submitCredit = '/api/credit-requests/submit';
  static String myCredits(int userId) => '/api/credit-requests/user/$userId';
  static String creditDetail(int id) => '/api/credit-requests/$id';
  static String amortization(int requestId) =>
      '/api/amortization/request/$requestId';

  // Simulator
  static const String simulate = '/api/creditos/simular';

  // Config
  static const String configCreditos = '/api/config-creditos';
}
