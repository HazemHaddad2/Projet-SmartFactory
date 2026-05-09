class ApiConfig {
  // Gateway API - Point d'entrée unique
  static const String baseUrl = 'http://localhost:8000';

  // Routes du Gateway
  static const String authRegister = '$baseUrl/auth/register';
  static const String authLogin = '$baseUrl/auth/login';
  static const String users = '$baseUrl/users';
  static const String machines = '$baseUrl/machines';
  static const String events = '$baseUrl/events';
  static const String alerts = '$baseUrl/alerts';
  static const String dashboard = '$baseUrl/dashboard';

  // WebSocket pour temps réel
  static const String wsUrl = 'ws://localhost:8000/ws';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
