// import 'package:hive/hive.dart';
// import 'package:yalla_r7la2/features/chat/data/models/message.dart';

// class ChatSession {
//   static final ChatSession _instance = ChatSession._internal();
//   final Box<Message> _messageBox = Hive.box<Message>('messages');

//   factory ChatSession() => _instance;

//   ChatSession._internal();

//   Future<bool> saveInteraction(
//     String sessionId,
//     String userMessage,
//     String botResponse, {
//     String? context,
//   }) async {
//     try {
//       final userMsg = Message(
//         sessionId: sessionId,
//         content: userMessage,
//         role: 'user',
//         context: null,
//       );
//       final botMsg = Message(
//         sessionId: sessionId,
//         content: botResponse,
//         role: 'system',
//         context: context,
//       );
//       await _messageBox.add(userMsg);
//       await _messageBox.add(botMsg);
//       return true;
//     } catch (e) {
//       print('Error saving interaction: $e');
//       return false;
//     }
//   }

//   List<Message> getSessionMessages(String sessionId) {
//     return _messageBox.values
//         .where((msg) => msg.sessionId == sessionId)
//         .toList();
//   }
// }
