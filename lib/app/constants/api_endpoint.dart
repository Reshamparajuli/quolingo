class ApiEndpoints {
  ApiEndpoints._();

  static const Duration connectionTimeout = Duration(seconds: 1000);
  static const Duration receiveTimeout = Duration(seconds: 1000);
  static const String baseUrl = "http://192.168.0.105:3000/api/v1/";

  // ====================== Auth Routes ======================
  static const String login = "auth/login";
  static const String register = "auth/register";
  static const String getAllStudent = "auth/getAllStudents";
  static const String currentUser = "auth/getMe";

  // ====================== Practice Task Routes ======================
  static const String getAllPracticeTasks = "practiceTasks";
  // static const String createPracticeTask = "practiceTasks";
  // static const String deletePracticeTask = "practiceTasks";
}
