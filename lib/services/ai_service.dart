// Koji Demo Build
// Author: Wajiha Tasaduq
// Shared for academic review only


abstract class AIService {
  Future<String> sendMessage(String userMessage, List<Map<String, dynamic>> history);
  Future<String> detectMood(String message);
}
