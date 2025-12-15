import 'package:flutter/material.dart';
import 'flashcards_page.dart';

class FlashcardsSetupPage extends StatefulWidget {
  @override
  _FlashcardsSetupPageState createState() => _FlashcardsSetupPageState();
}

class _FlashcardsSetupPageState extends State<FlashcardsSetupPage> {
  String selectedSubject = 'Math';
  String selectedTopic = 'Algebra';
  String selectedDifficulty = 'Easy';
  int numQuestions = 5;
  bool includeHints = true;

  final subjects = ['Math', 'Science', 'History', 'English'];
  final topics = ['Algebra', 'Geometry', 'Physics', 'Chemistry'];
  final difficulties = ['Easy', 'Medium', 'Hard'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A192F), // Koji dark blue
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Flashcards Setup', style: TextStyle(color: Colors.white, fontSize: 24)),
              const SizedBox(height: 20),
              // Subject
              DropdownButton<String>(
                value: selectedSubject,
                dropdownColor: const Color(0xFF0A192F),
                style: const TextStyle(color: Colors.white),
                items: subjects.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => selectedSubject = val);
                },
              ),
              // Topic
              DropdownButton<String>(
                value: selectedTopic,
                dropdownColor: const Color(0xFF0A192F),
                style: const TextStyle(color: Colors.white),
                items: topics.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => selectedTopic = val);
                },
              ),
              // Difficulty
              DropdownButton<String>(
                value: selectedDifficulty,
                dropdownColor: const Color(0xFF0A192F),
                style: const TextStyle(color: Colors.white),
                items: difficulties.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => selectedDifficulty = val);
                },
              ),
              // Number of questions
              Slider(
                value: numQuestions.toDouble(),
                min: 1,
                max: 20,
                divisions: 19,
                label: numQuestions.toString(),
                activeColor: Color(0xFFFFA500),
                onChanged: (val) => setState(() => numQuestions = val.toInt()),
              ),
              // Include hints
              SwitchListTile(
                title: const Text('Include hints', style: TextStyle(color: Colors.white)),
                value: includeHints,
                onChanged: (val) => setState(() => includeHints = val),
              ),
              const SizedBox(height: 20),
              // Start Flashcards Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFCC5500), // AI Orange
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FlashcardsPage(
                        subject: selectedSubject,
                        topic: selectedTopic,
                        difficulty: selectedDifficulty,
                        numQuestions: numQuestions,
                        includeHints: includeHints,
                      ),
                    ),
                  );
                },
                child: const Text('Start Flashcards', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

