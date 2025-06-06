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

class ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  File? _image;
  final ImagePicker _picker =
      ImagePicker(); // استخدام الكائن بدلاً من الكود المباشر

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _messages.add({"user": _controller.text});
      });
      _controller.clear();
      _getBotResponse();
    }
  }

  void _getBotResponse() {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _messages.add({"bot": "I'm here to assist you!"});
      });
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
    ); // استخدام ImagePicker لالتقاط صورة من الكاميرا
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // حفظ الصورة في المتغير _image
        _messages.add({
          "user": "[Image sent]",
        }); // إضافة رسالة تفيد بأن الصورة تم إرسالها
      });
      _sendImageToAI(_image!); // إرسال الصورة إلى AI (أو الخادم) بعد التقاطها
    }
  }

  void _sendImageToAI(File image) {
    // هنا تقدر تبعت الصورة لنموذج الذكاء الاصطناعي
    // مثال: استدعاء API أو تحليل محلي للصورة
    // حالياً بنضيف رد افتراضي من البوت
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _messages.add({
          "bot": "Nice photo! This looks like a great tourist spot.",
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Chat Bot"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed:
              () => context.pushNamedAndRemoveUntil(
                Routes.host,
                predicate: (route) => false,
              ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Align(
                  alignment:
                      message.containsKey("user")
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color:
                          message.containsKey("user")
                              ? Colors.blue[200]
                              : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      message.values.first,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.camera_alt, color: Color(0xFF2FB0C6)),
                  onPressed:
                      _pickImage, // عند الضغط على الأيقونة سيتم التقاط صورة
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Your message here",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Color(0xFF2FB0C6)),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
