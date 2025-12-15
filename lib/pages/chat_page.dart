
// OLD
// final ChatService _chatService = ChatService();  // REMOVE this

// Now, anywhere you had
// _chatService.sendMessage(text, history);
// you replace with
// aiService.sendMessage(text, history);  // NEW



import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:convert';
// NEW import
import '../services/ai_service.dart';  // NEW
// OLD import
// import '../services/chat_service.dart';  // REMOVED
import 'pinned_messages_page.dart';
import 'flashcards_page.dart'; 

class ChatPage extends StatefulWidget {
  final AIService aiService; // added
  
  const ChatPage({Key? key, required this.aiService}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final Map<String, List<Map<String, dynamic>>> allConversations = {};
  final Map<String, String> conversationTitles = {};
  String currentConversationId = '';
  bool isTyping = false;
  String currentTypingReply = '';

  // NEW: getter to access AI service from the widget
  AIService get aiService => widget.aiService;

  late stt.SpeechToText _speech;
  bool _isListening = false;

  late FocusNode _inputFocusNode;

  final List<String> quickPrompts = [
    "Explain this concept simply",
    "Summarize this text",
    "Give me a motivational quote",
    "Translate this to English",
    "Generate a creative idea"
  ];

  late AnimationController _promptController;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initSpeech();
    _loadConversations();

    _inputFocusNode = FocusNode();
    _inputFocusNode.addListener(() {
      if (_inputFocusNode.hasFocus) {
        _promptController.forward();
      } else {
        _promptController.reverse();
      }
    });

    _promptController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _promptController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  Future<void> _initSpeech() async {
    await _speech.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          setState(() => _isListening = false);
        }
      },
      onError: (error) {
        setState(() => _isListening = false);
        debugPrint("Speech recognition error: $error");
      },
    );
  }

  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (val) {
          setState(() {
            _controller.text = val.recognizedWords;
          });
        },
      );
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  void _toggleListening() {
    _isListening ? _stopListening() : _startListening();
  }

  void sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || currentConversationId.isEmpty) return;

    final timestamp = DateTime.now().toIso8601String();

    setState(() {
      allConversations[currentConversationId]!.add({
        'text': text,
        'isUser': true,
        'timestamp': timestamp,
        'isPinned': false,
      });
      isTyping = true;
      currentTypingReply = '';
    });
    await _saveConversations();

    _controller.clear();

    final history = allConversations[currentConversationId] ?? [];
    final reply = await aiService.sendMessage(text, history);

    setState(() {
      isTyping = false;
      allConversations[currentConversationId]!.add({
        'text': reply,
        'isUser': false,
        'timestamp': DateTime.now().toIso8601String(),
        'isPinned': false,
      });
    });
    await _saveConversations();
  }

  Future<void> _saveConversations() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = jsonEncode(allConversations);
    final titleData = jsonEncode(conversationTitles);
    await prefs.setString('all_chats', jsonData);
    await prefs.setString('chat_titles', titleData);
  }

  Future<void> _loadConversations() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('all_chats');
    final titlesString = prefs.getString('chat_titles');
    if (jsonString != null) {
      final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
      decoded.forEach((key, value) {
        allConversations[key] = List<Map<String, dynamic>>.from(
            (value as List).map((e) => Map<String, dynamic>.from(e)));
      });
    }
    if (titlesString != null) {
      final titleDecoded = jsonDecode(titlesString) as Map<String, dynamic>;
      conversationTitles.addAll(titleDecoded.map((k, v) => MapEntry(k, v.toString())));
    }
    if (allConversations.isNotEmpty) {
      currentConversationId = allConversations.keys.last;
    } else {
      _startNewConversation();
    }
    setState(() {});
  }

  void _startNewConversation() {
    final newId = DateTime.now().millisecondsSinceEpoch.toString();
    allConversations[newId] = [];
    conversationTitles[newId] = 'Untitled Chat';
    currentConversationId = newId;
    _saveConversations();
    setState(() {});
  }

  void _renameConversation(String id, String newTitle) {
    setState(() {
      conversationTitles[id] = newTitle;
    });
    _saveConversations();
  }

  void _deleteConversation(String id) {
    setState(() {
      allConversations.remove(id);
      conversationTitles.remove(id);
      if (currentConversationId == id && allConversations.isNotEmpty) {
        currentConversationId = allConversations.keys.first;
      }
    });
    _saveConversations();
  }

  @override
  Widget build(BuildContext context) {
    final messages = allConversations[currentConversationId] ?? [];

    messages.sort((a, b) {
      final pinnedA = a['isPinned'] ?? false;
      final pinnedB = b['isPinned'] ?? false;
      
      if (pinnedA && !pinnedB) return -1; // pinned on top
      if (!pinnedA && pinnedB) return 1;  // pinned on top

      // If both pinned or both unpinned, sort by timestamp
      final timeA = DateTime.tryParse(a['timestamp'] ?? '') ?? DateTime.now();
      final timeB = DateTime.tryParse(b['timestamp'] ?? '') ?? DateTime.now();
      return timeA.compareTo(timeB);  // older messages first
    });

    return Scaffold(
      backgroundColor: const Color(0xFF0A0B1F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0B1F),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            dropdownColor: const Color(0xFF1A1B2F),
            value: currentConversationId,
            items: allConversations.keys.map((id) {
              return DropdownMenuItem(
                value: id,
                child: Row(
                  children: [
                    Text(conversationTitles[id] ?? 'Untitled', style: const TextStyle(color: Colors.white)),
                    const SizedBox(width: 8),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      onSelected: (value) {
                        if (value == 'rename') {
                          showDialog(
                            context: context,
                            builder: (context) {
                              final renameController = TextEditingController(text: conversationTitles[id]);
                              return AlertDialog(
                                title: const Text('Rename Chat'),
                                content: TextField(controller: renameController),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _renameConversation(id, renameController.text);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Rename'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else if (value == 'delete') {
                          _deleteConversation(id);
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(value: 'rename', child: Text('Rename')),
                        PopupMenuItem(value: 'delete', child: Text('Delete')),
                      ],
                    )
                  ],
                ),
              );
            }).toList(),
            onChanged: (id) => setState(() => currentConversationId = id!),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.push_pin, color: Colors.white),
            onPressed: () {
              final pinnedMessages = (allConversations[currentConversationId] ?? [])
                  .where((m) => m['isPinned'] == true)
                  .toList();

              if (pinnedMessages.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No pinned messages yet')),
                );
                return;
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PinnedMessagesPage(messages: pinnedMessages),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: _startNewConversation,
          )
        ],
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length + (isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (isTyping && index == messages.length) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Opacity(
                            opacity: value,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFCC5500),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  AnimateDot(),
                                  SizedBox(width: 4),
                                  AnimateDot(delay: 200),
                                  SizedBox(width: 4),
                                  AnimateDot(delay: 400),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }

                final message = messages[index];
                final isUser = message['isUser'] ?? false;
                final timestamp = message['timestamp'] ?? '';

                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onLongPress: () {
                          setState(() {
                            message['isPinned'] = !(message['isPinned'] ?? false);
                          });
                          _saveConversations();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                message['isPinned']! ? "Pinned!" : "Unpinned!"
                              ),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.9,
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isUser ? Colors.blueAccent : const Color(0xFFCC5500),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: MarkdownBody(
                                  data: message['text'],
                                  styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                                      .copyWith(p: const TextStyle(color: Colors.white)),
                                ),
                              ),
                              if (message['isPinned'] == true)
                                const Icon(Icons.push_pin, size: 16, color: Colors.orange),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (timestamp.isNotEmpty)
                              Text(
                                _formatTimestamp(timestamp),
                                style: const TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            const SizedBox(width: 6),
                            IconButton(
                              icon: const Icon(Icons.copy, size: 16, color: Colors.white54),
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: message['text']));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Copied to clipboard'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.share, size: 16, color: Colors.white54),
                              onPressed: () {
                                Share.share(message['text']);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // QUICK PROMPTS
          SizeTransition(
            sizeFactor: _promptController,
            axisAlignment: -1.0,
            child: SizedBox(
              height: 50,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: quickPrompts.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final prompt = quickPrompts[index];
                  return GestureDetector(
                    onTap: () {
                      _controller.text = prompt;
                      _controller.selection = TextSelection.fromPosition(
                        TextPosition(offset: _controller.text.length),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade700),
                      ),
                      child: Center(
                        child: Text(
                          prompt,
                          style: TextStyle(color: Colors.grey[400], fontSize: 14),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Chat input field
          Container(
            color: Colors.black.withOpacity(0.6),
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: Row(
              children: [
                // Voice input
                GestureDetector(
                  onTap: _toggleListening,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isListening ? const Color(0xFFCC5500) : Colors.white10,
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                      _isListening ? Icons.mic : Icons.mic_none,
                      color: Colors.white,
                    ),
                  ),
                ),

                // Flashcards button
                IconButton(
                  icon: const Icon(Icons.menu_book, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FlashcardsPage(
                          subject: 'Math',
                          topic: 'Algebra',
                          difficulty: 'Medium', 
                          numQuestions: 5,
                          includeHints: true,
                        ),
                      ),
                    );
                  },
                ),


                // Text input
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _inputFocusNode,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                      hintStyle: TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => sendMessage(),
                  ),
                ),

                // Send button
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blueAccent),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(String iso) {
    final dt = DateTime.tryParse(iso)?.toLocal();
    if (dt == null) return '';
    return DateFormat('MMMM d, y – h:mm a').format(dt);
  }
}

class AnimateDot extends StatelessWidget {
  final int delay;
  const AnimateDot({this.delay = 0, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
    ).animate(delay: delay.ms).scale(duration: 500.ms).then().scaleXY(end: 0.7, duration: 500.ms);
  }
}
