import 'dart:io';

import 'package:flutter/material.dart';
import 'package:yalla_r7la2/features/chat/data/models/chat_models.dart';
import 'package:yalla_r7la2/features/chat/services/chat_bot_service.dart';
import 'package:yalla_r7la2/features/chat/services/image_picker_service.dart';
import 'package:yalla_r7la2/features/chat/utils/chat_utils.dart';

import '../../../../core/routes/routes.dart';
import '../../../../core/utils/extensions.dart';
import '../widgets/chat_widgets.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  ChatBotScreenState createState() => ChatBotScreenState();
}

class ChatBotScreenState extends State<ChatBotScreen>
    with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();

  // Animation Controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isTyping = false;
  final bool _isOnline = true;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _addWelcomeMessage();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.elasticOut),
    );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _addWelcomeMessage() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _messages.add(ChatBotService.getWelcomeMessage());
        });
        ChatUtils.scrollToBottom(_scrollController);
      }
    });
  }

  void _sendMessage() {
    if (_controller.text.trim().isNotEmpty) {
      final messageText = _controller.text.trim();
      setState(() {
        _messages.add(
          ChatMessage(
            type: "user",
            message: messageText,
            timestamp: DateTime.now(),
          ),
        );
        _isTyping = true;
      });
      _controller.clear();
      ChatUtils.scrollToBottom(_scrollController);
      _getBotResponse(messageText);
    }
  }

  void _getBotResponse(String userMessage) async {
    try {
      final response = await ChatBotService.getBotResponse(userMessage);
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add(response);
        });
        ChatUtils.scrollToBottom(_scrollController);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isTyping = false;
        });
        _showErrorSnackbar("حدث خطأ في الحصول على الرد");
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final image = await ImagePickerService.pickImageFromCamera();
      if (image != null) {
        setState(() {
          _messages.add(
            ChatMessage(
              type: "user",
              message: "تم إرسال صورة 📷",
              timestamp: DateTime.now(),
              image: image,
            ),
          );
          _isTyping = true;
        });
        ChatUtils.scrollToBottom(_scrollController);
        _sendImageToAI(image);
      }
    } catch (e) {
      _showErrorSnackbar(e.toString());
    }
  }

  void _sendImageToAI(File image) async {
    try {
      final response = await ChatBotService.getImageResponse(image);
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add(response);
        });
        ChatUtils.scrollToBottom(_scrollController);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isTyping = false;
        });
        _showErrorSnackbar("حدث خطأ في معالجة الصورة");
      }
    }
  }

  void _sendSuggestion(String suggestion) {
    _controller.text = suggestion;
    _sendMessage();
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            children: [
              ChatWidgets.buildStatusBar(context,_isOnline, _messages.length),
              Expanded(child: _buildMessagesList()),
              if (_isTyping) ChatWidgets.buildTypingIndicator(),
              _buildInputArea(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      scrolledUnderElevation: 0,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black87,
            size: 20,
          ),
          onPressed:
              () => context.pushNamedAndRemoveUntil(
                Routes.host,
                predicate: (route) => false,
              ),
        ),
      ),
      title: Row(
        children: [
          ChatWidgets.buildBotAvatar(size: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "مساعد السفر الذكي",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  _isOnline ? "متصل الآن" : "غير متصل",
                  style: TextStyle(
                    fontSize: 12,
                    color: _isOnline ? Colors.green[600] : Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        return ChatWidgets.buildMessageBubble(
          _messages[index],
          _sendSuggestion,
          context,
        );
      },
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Camera Button
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2FB0C6).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.camera_alt,
                  color: Color(0xFF2FB0C6),
                  size: 22,
                ),
                onPressed: _pickImage,
              ),
            ),

            const SizedBox(width: 12),

            // Text Input
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey[300]!, width: 1),
                ),
                child: TextField(
                  controller: _controller,
                  textDirection: TextDirection.rtl,
                  decoration: const InputDecoration(
                    hintText: "اكتب رسالتك هنا...",
                    hintTextDirection: TextDirection.rtl,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                  maxLines: null,
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Send Button
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [const Color(0xFF2FB0C6), Colors.blue[600]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2FB0C6).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white, size: 20),
                onPressed: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
