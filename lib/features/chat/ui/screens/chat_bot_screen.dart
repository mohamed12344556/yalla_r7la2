import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yalla_r7la2/core/routes/routes.dart';
import 'package:yalla_r7la2/core/utils/extensions.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  ChatBotScreenState createState() => ChatBotScreenState();
}

class ChatBotScreenState extends State<ChatBotScreen>
    with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final ScrollController _scrollController = ScrollController();
  File? _image;
  final ImagePicker _picker = ImagePicker();

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

    // Initialize animation controllers
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

    // Start animations
    _fadeController.forward();
    _slideController.forward();

    // Add welcome message
    _addWelcomeMessage();
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
          _messages.add({
            "type": "bot",
            "message":
                "مرحباً بك! 👋\nأنا مساعدك الذكي للسفر والسياحة. كيف يمكنني مساعدتك اليوم؟",
            "timestamp": DateTime.now(),
            "suggestions": [
              "أماكن سياحية مميزة",
              "نصائح السفر",
              "حجز الرحلات",
              "معلومات عن الفنادق",
            ],
          });
        });
        _scrollToBottom();
      }
    });
  }

  void _sendMessage() {
    if (_controller.text.trim().isNotEmpty) {
      final messageText = _controller.text.trim();
      setState(() {
        _messages.add({
          "type": "user",
          "message": messageText,
          "timestamp": DateTime.now(),
        });
        _isTyping = true;
      });
      _controller.clear();
      _scrollToBottom();
      _getBotResponse(messageText);
    }
  }

  void _getBotResponse(String userMessage) {
    // Simulate different response types based on user input
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isTyping = false;

          String botResponse;
          List<String>? suggestions;

          if (userMessage.contains('أماكن') || userMessage.contains('سياحة')) {
            botResponse =
                "إليك بعض الأماكن السياحية المميزة:\n\n🏖️ شرم الشيخ - للاستجمام والغوص\n🏛️ الأقصر - للتاريخ والآثار\n🏙️ القاهرة - للثقافة والتراث\n\nهل تريد معلومات أكثر عن أي منها؟";
            suggestions = [
              "شرم الشيخ",
              "الأقصر",
              "القاهرة",
              "المزيد من الأماكن",
            ];
          } else if (userMessage.contains('حجز') ||
              userMessage.contains('رحلة')) {
            botResponse =
                "بالطبع! يمكنني مساعدتك في حجز رحلتك 🛫\n\nما نوع الحجز الذي تحتاجه:\n✈️ حجز طيران\n🏨 حجز فنادق\n🚗 تأجير سيارات\n📦 باقات سياحية شاملة";
            suggestions = [
              "حجز طيران",
              "حجز فنادق",
              "باقات شاملة",
              "تأجير سيارات",
            ];
          } else if (userMessage.contains('نصائح') ||
              userMessage.contains('مساعدة')) {
            botResponse =
                "إليك أهم نصائح السفر 💡\n\n📋 احرص على جواز سفر ساري\n💳 اخطر البنك بسفرك\n🧳 احزم الأساسيات فقط\n📱 حمل التطبيقات المفيدة\n💊 لا تنس الأدوية المهمة";
            suggestions = [
              "نصائح الأمان",
              "نصائح التوفير",
              "قائمة السفر",
              "التأمين",
            ];
          } else {
            botResponse =
                "شكراً لسؤالك! 😊\nأنا هنا لمساعدتك في كل ما يخص السفر والسياحة. يمكنني مساعدتك في العثور على أفضل الوجهات، حجز الرحلات، أو تقديم النصائح المفيدة.";
            suggestions = [
              "أماكن سياحية",
              "حجز رحلات",
              "نصائح السفر",
              "عروض خاصة",
            ];
          }

          _messages.add({
            "type": "bot",
            "message": botResponse,
            "timestamp": DateTime.now(),
            "suggestions": suggestions,
          });
        });
        _scrollToBottom();
      }
    });
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          _messages.add({
            "type": "user",
            "message": "تم إرسال صورة 📷",
            "timestamp": DateTime.now(),
            "image": _image,
          });
          _isTyping = true;
        });
        _scrollToBottom();
        _sendImageToAI(_image!);
      }
    } catch (e) {
      _showErrorSnackbar("حدث خطأ في التقاط الصورة");
    }
  }

  void _sendImageToAI(File image) {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add({
            "type": "bot",
            "message":
                "صورة رائعة! 📸✨\n\nيبدو أن هذا مكان سياحي مميز. هل تريد معلومات أكثر عن هذا المكان أو أماكن مشابهة؟",
            "timestamp": DateTime.now(),
            "suggestions": [
              "معلومات عن المكان",
              "أماكن مشابهة",
              "كيفية الوصول",
              "أنشطة قريبة",
            ],
          });
        });
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
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
              // Status Bar
              _buildStatusBar(),

              // Messages List
              Expanded(child: _buildMessagesList()),

              // Typing Indicator
              if (_isTyping) _buildTypingIndicator(),

              // Input Area
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
          // Bot Avatar
          Container(
            width: 40,
            height: 40,
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
            child: const Icon(Icons.smart_toy, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),

          // Bot Info
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

  Widget _buildStatusBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[200]!, width: 1)),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: _isOnline ? Colors.green : Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _isOnline ? "مساعدك الذكي جاهز للمساعدة" : "إعادة الاتصال...",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            "${_messages.length} رسالة",
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
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
        final message = _messages[index];
        return _buildMessageBubble(message, index);
      },
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message, int index) {
    final isUser = message["type"] == "user";
    final hasImage = message["image"] != null;
    final suggestions = message["suggestions"] as List<String>?;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Message Bubble
          Row(
            mainAxisAlignment:
                isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isUser) _buildBotAvatar(),
              if (!isUser) const SizedBox(width: 8),

              Flexible(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient:
                        isUser
                            ? LinearGradient(
                              colors: [
                                const Color(0xFF2FB0C6),
                                Colors.blue[600]!,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                            : null,
                    color: isUser ? null : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: Radius.circular(isUser ? 20 : 8),
                      bottomRight: Radius.circular(isUser ? 8 : 20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image if exists
                      if (hasImage)
                        Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: FileImage(message["image"]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                      // Message Text
                      Text(
                        message["message"],
                        style: TextStyle(
                          fontSize: 15,
                          color: isUser ? Colors.white : Colors.black87,
                          height: 1.4,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (isUser) const SizedBox(width: 8),
              if (isUser) _buildUserAvatar(),
            ],
          ),

          // Timestamp
          Padding(
            padding: EdgeInsets.only(
              top: 4,
              left: isUser ? 0 : 48,
              right: isUser ? 48 : 0,
            ),
            child: Text(
              _formatTimestamp(message["timestamp"]),
              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
            ),
          ),

          // Suggestions
          if (suggestions != null && suggestions.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 12, left: 48),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    suggestions.map((suggestion) {
                      return GestureDetector(
                        onTap: () => _sendSuggestion(suggestion),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFF2FB0C6).withOpacity(0.3),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            suggestion,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF2FB0C6),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBotAvatar() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF2FB0C6), Colors.blue[600]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.smart_toy, color: Colors.white, size: 18),
    );
  }

  Widget _buildUserAvatar() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.person, color: Colors.grey[600], size: 18),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          _buildBotAvatar(),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTypingDot(0),
                const SizedBox(width: 4),
                _buildTypingDot(1),
                const SizedBox(width: 4),
                _buildTypingDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDot(int index) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.5 + (0.5 * value),
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              shape: BoxShape.circle,
            ),
          ),
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

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return "الآن";
    } else if (difference.inHours < 1) {
      return "منذ ${difference.inMinutes} دقيقة";
    } else if (difference.inDays < 1) {
      return "منذ ${difference.inHours} ساعة";
    } else {
      return "${timestamp.day}/${timestamp.month}";
    }
  }
}
