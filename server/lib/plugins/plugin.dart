abstract class Plugin {
  String get name;

  Future<Map<String, dynamic>> handleBody(Map<String, dynamic> requestBody);
}
