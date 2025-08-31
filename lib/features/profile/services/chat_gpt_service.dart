import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

class ChatGPTService {
  static const String _apiKey = '';

  late final OpenAI _openAI;

  ChatGPTService() {
    _openAI = OpenAI.instance.build(
      token: _apiKey,
      baseOption: HttpSetup(
        receiveTimeout: const Duration(seconds: 20),
        connectTimeout: const Duration(seconds: 20),
      ),
      enableLog: kDebugMode,
    );
  }

  Future<String> sendMessage(
    String message,
    List<Map<String, String>> conversationHistory,
  ) async {
    try {
      // Convert conversation history to the format expected by the SDK
      final messages =
          conversationHistory.map((msg) {
            return {
              'role': msg['role'] == 'user' ? 'user' : 'assistant',
              'content': msg['content'] ?? '',
            };
          }).toList();

      // Add the current user message
      messages.add({'role': 'user', 'content': message});

      final request = ChatCompleteText(
        messages: messages,
        maxToken: 1000,
        model: GptTurboChatModel(),
        temperature: 0.7,
      );

      final response = await _openAI.onChatCompletion(request: request);

      if (response != null && response.choices.isNotEmpty) {
        final content = response.choices.first.message?.content;
        if (content != null && content.isNotEmpty) {
          return content;
        } else {
          return 'Sorry, I couldn\'t generate a response.';
        }
      } else {
        return 'Sorry, I couldn\'t generate a response.';
      }
    } on TimeoutException {
      return 'Sorry, the request timed out. Please try again.';
    } catch (e) {
      if (kDebugMode) {
        print('ChatGPT API Error: $e');
      }

      // Handle specific error types
      if (e.toString().contains('401')) {
        return 'Authentication error. Please check your API key.';
      } else if (e.toString().contains('429')) {
        return 'Rate limit exceeded. Please try again later.';
      } else if (e.toString().contains('500')) {
        return 'Server error. Please try again later.';
      } else {
        return 'Sorry, there was an error processing your request. Please try again.';
      }
    }
  }

  void dispose() {
    // OpenAI service doesn't have a close method
  }
}
