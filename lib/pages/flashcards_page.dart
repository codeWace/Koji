import 'package:flutter/material.dart';

class FlashcardsPage extends StatefulWidget {
  final String subject;
  final String topic;
  final String difficulty;
  final int numQuestions;
  final bool includeHints;

  FlashcardsPage({
    super.key,
    required this.subject,
    required this.topic,
    required this.difficulty,
    required this.numQuestions,
    required this.includeHints,
  });

  @override
  State<FlashcardsPage> createState() => _FlashcardsPageState();
}

class _FlashcardsPageState extends State<FlashcardsPage> {
  String? selectedSubject;
  String? selectedTopic;

  final Map<String, List<String>> subjects = {
    'Math': ['Algebra', 'Calculus', 'Geometry'],
    'Physics': ['Mechanics', 'Optics', 'Electromagnetism'],
    'Biology': ['Genetics', 'Cell Biology', 'Human Anatomy'],
  };

  List<String> topics = [];

  void _onSubjectChanged(String? subject) {
    setState(() {
      selectedSubject = subject;
      selectedTopic = null;
      topics = subject != null ? subjects[subject]! : [];
    });
  }

  void _startFlashcards() {
    if (selectedSubject == null || selectedTopic == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a subject and topic')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FlashcardsReviewPage(
          subject: selectedSubject!,
          topic: selectedTopic!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0B1F),
      appBar: AppBar(
        title: const Text('Flashcards'),
        backgroundColor: const Color(0xFF0A0B1F),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButtonFormField<String>(
                value: selectedSubject,
                dropdownColor: const Color(0xFF1A1B2F),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                hint: const Text('Select Subject', style: TextStyle(color: Colors.white70)),
                items: subjects.keys
                    .map((s) => DropdownMenuItem(
                          value: s,
                          child: Text(s, style: const TextStyle(color: Colors.white)),
                        ))
                    .toList(),
                onChanged: _onSubjectChanged,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedTopic,
                dropdownColor: const Color(0xFF1A1B2F),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                hint: const Text('Select Topic', style: TextStyle(color: Colors.white70)),
                items: topics
                    .map((t) => DropdownMenuItem(
                          value: t,
                          child: Text(t, style: const TextStyle(color: Colors.white)),
                        ))
                    .toList(),
                onChanged: (t) => setState(() => selectedTopic = t),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFCC5500),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: _startFlashcards,
                child: const Text(
                  'Start Flashcards',
                  style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --------------------------------------------------------------------------
// NEW FLASHCARDS REVIEW PAGE – Subject + Topic Based + Version B
// --------------------------------------------------------------------------

class FlashcardsReviewPage extends StatefulWidget {
  final String subject;
  final String topic;

  const FlashcardsReviewPage({
    required this.subject,
    required this.topic,
    super.key,
  });

  @override
  State<FlashcardsReviewPage> createState() => _FlashcardsReviewPageState();
}

class _FlashcardsReviewPageState extends State<FlashcardsReviewPage> {

  // DEMO FLASHCARDS FOR ALL SUBJECTS & TOPICS
  final Map<String, Map<String, List<Map<String, String>>>> demoFlashcards = {
    "Math": {
      "Algebra": [
        {"question": "Solve 2x + 3 = 11", "answer": "x = 4"},
        {"question": "Factorise x² - 5x + 6", "answer": "(x - 2)(x - 3)"},
        {"question": "What is |−8|?", "answer": "8"},
      ],
      "Calculus": [
        {"question": "Derivative of x²?", "answer": "2x"},
        {"question": "Integral of 3x?", "answer": "1.5x² + C"},
      ],
      "Geometry": [
        {"question": "Sum of angles in a triangle?", "answer": "180°"},
        {"question": "Area of a circle?", "answer": "πr²"},
      ],
    },

    "Physics": {
      "Mechanics": [
        {"question": "Unit of Force?", "answer": "Newton (N)"},
        {"question": "Formula for Work?", "answer": "W = F × d"},
      ],
      "Optics": [
        {"question": "Speed of light?", "answer": "3 × 10⁸ m/s"},
        {"question": "Mirror that converges light?", "answer": "Concave mirror"},
      ],
      "Electromagnetism": [
        {"question": "Charge of electron?", "answer": "-1.6 × 10⁻¹⁹ C"},
        {"question": "Unit of resistance?", "answer": "Ohm (Ω)"},
      ],
    },

    "Biology": {
      "Genetics": [
        {"question": "What carries genetic info?", "answer": "DNA"},
        {"question": "Chromosomes in humans?", "answer": "46"},
      ],
      "Cell Biology": [
        {"question": "Powerhouse of the cell?", "answer": "Mitochondria"},
        {"question": "Basic unit of life?", "answer": "Cell"},
      ],
      "Human Anatomy": [
        {"question": "Largest organ?", "answer": "Skin"},
        {"question": "Bones in adult human body?", "answer": "206"},
      ],
    },
  };

  int currentIndex = 0;
  bool showAnswer = false;

  void _nextCard() {
    final flashcards =
        demoFlashcards[widget.subject]![widget.topic]!;

    setState(() {
      showAnswer = false;
      if (currentIndex < flashcards.length - 1) {
        currentIndex++;
      } else {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("All Flashcards Completed!"),
            content: const Text("Demo deck is finished."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              )
            ],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final flashcards =
        demoFlashcards[widget.subject]![widget.topic]!;
    final card = flashcards[currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF0A0B1F),
      appBar: AppBar(
        title: Text("${widget.subject} - ${widget.topic} Flashcards"),
        backgroundColor: const Color(0xFF0A0B1F),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Flashcard box
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
              child: Container(
                key: ValueKey(showAnswer),
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFCC5500),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  showAnswer ? card['answer']! : card['question']!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            if (!showAnswer)
              ElevatedButton(
                onPressed: () => setState(() => showAnswer = true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  "Show Answer",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _nextCard,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding:
                          const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      "Unknown",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  ElevatedButton(
                    onPressed: _nextCard,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                      padding:
                          const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      "Known",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
