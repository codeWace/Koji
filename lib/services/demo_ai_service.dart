// Koji Demo Build
// Demo-only AI service (no real model)
// Shared for academic review only
// lib/services/demo_ai_service.dart


import 'ai_service.dart';

class DemoAIService implements AIService {
  @override
  Future<String> sendMessage(String userMessage, List<Map<String, dynamic>> history) async {
    await Future.delayed(const Duration(seconds: 1));
    return "Koji (demo): I'm thinking about that 🌱";
  }

  @override
  Future<String> detectMood(String message) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return "Neutral"; // simple demo label
  }
}
