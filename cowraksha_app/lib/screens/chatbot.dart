import 'package:flutter/material.dart';
import 'dart:async';
import 'vets.dart'; // Ensure this file exists in your project

// --- Data Model ---
class Message {
  final String text;
  final bool isBot;
  final DateTime time;

  Message({required this.text, required this.isBot, required this.time});
}

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<Message> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isTyping = false;
  int _step = 0;
  String _lang = "en";
  String _userName = "";

  @override
  void initState() {
    super.initState();
    _botWelcome();
  }

  // --- Logic Functions ---

  void _botWelcome() {
    _addBotMessage("🌿 Welcome to GauRaksha AI");
    _addBotMessage("Please select your preferred language / कृपया अपनी भाषा चुनें:");
  }

  void _addBotMessage(String text) {
    setState(() => _isTyping = true);

    // Simulate thinking time for realism
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() {
          _messages.add(Message(text: text, isBot: true, time: DateTime.now()));
          _isTyping = false;
        });
        _scrollToBottom();
      }
    });
  }

  void _addUserMessage(String text) {
    setState(() {
      _messages.add(Message(text: text, isBot: false, time: DateTime.now()));
    });
    _scrollToBottom();
    _handleLogic(text);
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutQuad,
        );
      }
    });
  }

  void _handleLogic(String input) {
    // STEP 0: Language Selection
    if (_step == 0) {
      _lang = (input.toLowerCase().contains("hi") || input == "Hindi") ? "hi" : "en";
      _step = 1;
      _addBotMessage(_lang == "hi" ? "🙏 नमस्ते! आपका शुभ नाम क्या है?" : "👋 Hello! What is your name?");
    }
    // STEP 1: Name Handling
    else if (_step == 1) {
      _userName = input;
      _step = 2;
      _addBotMessage(_lang == "hi"
          ? "स्वागत है $_userName! मैं आपकी गौमाता की सेवा के लिए यहाँ हूँ।"
          : "Welcome $_userName! I am here to help you care for your cattle.");
      _addBotMessage(_lang == "hi"
          ? "कृपया एक विकल्प चुनें:\n1️⃣ बीमारी की जाँच\n2️⃣ डॉक्टर खोजें\n3️⃣ सामान्य सलाह"
          : "Please choose an option:\n1️⃣ Check Disease\n2️⃣ Find Local Vet\n3️⃣ General Advice");
    }
    // STEP 2: Menu Options
    else if (_step == 2) {
      if (input == "1" || input.contains("Check")) {
        _step = 3;
        _addBotMessage(_lang == "hi"
            ? "कृपया लक्षण बताएं (जैसे: बुखार, मुँह में छाले, या कम दूध देना)"
            : "Please describe symptoms (e.g., Fever, mouth ulcers, or low milk yield)");
      } else if (input == "2" || input.contains("Doctor")) {
        _addBotMessage(_lang == "hi" ? "📍 आपके पास के पशु चिकित्सकों की सूची लोड हो रही है..." : "📍 Fetching nearest veterinary experts...");
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const VetsScreen()));
        });
      } else if (input == "3" || input.contains("Advice")) {
        _step = 4;
        _addBotMessage(_lang == "hi" ? "आप किस बारे में सलाह चाहते हैं?" : "What would you like advice on?");
      }
    }
    // STEP 3: Symptoms Analysis (Fake AI)
    else if (_step == 3) {
      String reply;
      String lower = input.toLowerCase();
      if (lower.contains("fever") || lower.contains("बुखार")) {
        reply = _lang == "hi"
            ? "⚠️ यह गंभीर हो सकता है। कृपया तापमान मापें और ठंडे पानी की पट्टी रखें। डॉक्टर को तुरंत बुलाएं।"
            : "⚠️ High fever detected. Keep the cow in a cool shade and call a vet immediately.";
      } else if (lower.contains("mouth") || lower.contains("छाले")) {
        reply = _lang == "hi"
            ? "👄 यह FMD (खुरपका-मुँहपका) हो सकता है। संक्रमित पशु को अलग करें।"
            : "👄 This could be FMD. Isolate the animal immediately to prevent spread.";
      } else {
        reply = _lang == "hi"
            ? "मेने आपकी बात नोट कर ली है। पशु चिकित्सक से परामर्श करना सबसे सुरक्षित है।"
            : "I've noted the symptoms. Consulting a vet is the safest course of action.";
      }
      _addBotMessage(reply);
      _step = 2; // Back to menu
    }
  }

  // --- UI Components ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.green[700],
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("GauRaksha AI", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text("Online • Expert Cattle Care", style: TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.pets, color: Colors.green),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildChatBubble(_messages[index]);
              },
            ),
          ),

          if (_isTyping)
            const Padding(
              padding: EdgeInsets.only(left: 15, bottom: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("AI is thinking...", style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
              ),
            ),

          _buildQuickActions(),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildChatBubble(Message message) {
    bool isBot = message.isBot;
    return Align(
      alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isBot ? Colors.white : Colors.green[600],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(15),
            topRight: const Radius.circular(15),
            bottomLeft: Radius.circular(isBot ? 0 : 15),
            bottomRight: Radius.circular(isBot ? 15 : 0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              spreadRadius: 1,
            )
          ],
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: isBot ? Colors.black87 : Colors.white,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    if (_step == 0) {
      return Container(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _actionBtn("English", () => _addUserMessage("English")),
            _actionBtn("हिंदी", () => _addUserMessage("Hindi")),
          ],
        ),
      );
    }
    if (_step == 2) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            const SizedBox(width: 10),
            _actionBtn("🔍 Check Disease", () => _addUserMessage("1")),
            _actionBtn("👨‍⚕️ Find Doctor", () => _addUserMessage("2")),
            _actionBtn("💡 Advice", () => _addUserMessage("3")),
            const SizedBox(width: 10),
          ],
        ),
      );
    }
    return const SizedBox();
  }

  Widget _actionBtn(String label, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.green[800],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.green.shade800),
          ),
        ),
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Ask GauRaksha...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: Colors.grey[200],
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Colors.green[700],
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: () {
                  if (_controller.text.trim().isNotEmpty) {
                    _addUserMessage(_controller.text);
                    _controller.clear();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}