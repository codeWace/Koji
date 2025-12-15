import 'package:flutter/material.dart';
import 'pages/chat_page.dart';

// --- NEW: imports for AI services
import 'services/ai_service.dart';
import 'services/demo_ai_service.dart';
// import 'services/real_ai_service.dart'; // LOCAL only 

// --- NEW: global AI service instance
late final AIService aiService;

void main() {
  // --- NEW: choose which AI service to use
  aiService = DemoAIService();  // PUBLIC demo version for GitHub
  // aiService = RealAIService(); // LOCAL only, uncomment to use real API

  runApp(const KojiSplash());
}

class KojiSplash extends StatelessWidget {
  const KojiSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0B1F),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: Tween(begin: 0.7, end: 1.0).animate(_glowController),
              child: Image.asset(
                'assets/fox_only.png',
                width: 220,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Hey, I am Koji!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              "Let's study smarter",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(aiService: aiService),
                  ),
                );
              },
              
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 14, horizontal: 30),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF9800), Color(0xFFFFEB3B)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  'Ask Koji Anything',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


