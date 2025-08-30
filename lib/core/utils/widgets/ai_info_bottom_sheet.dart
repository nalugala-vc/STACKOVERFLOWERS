import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:kenic/core/utils/fonts/inter.dart';
import 'package:kenic/core/utils/theme/app_pallete.dart';
import 'package:kenic/features/profile/services/chat_gpt_service.dart';

class AIInfoBottomSheet extends StatefulWidget {
  final String title;
  final String initialQuestion;
  final String domainContext;

  const AIInfoBottomSheet({
    super.key,
    required this.title,
    required this.initialQuestion,
    required this.domainContext,
  });

  @override
  State<AIInfoBottomSheet> createState() => _AIInfoBottomSheetState();
}

class _AIInfoBottomSheetState extends State<AIInfoBottomSheet> {
  final TextEditingController _messageController = TextEditingController();
  final ChatGPTService _chatGPTService = ChatGPTService();
  bool _isLoading = false;
  
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    // Send initial question automatically
    _sendInitialQuestion();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendInitialQuestion() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Add context about the domain
      final contextMessage = 'Context: This is about domain management. ${widget.domainContext}';
      
      final response = await _chatGPTService.sendMessage(
        '${widget.initialQuestion} $contextMessage',
        [],
      );

      if (mounted) {
        setState(() {
          _messages.add(ChatMessage(text: widget.initialQuestion, isUser: true));
          _messages.add(ChatMessage(text: response, isUser: false));
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add(ChatMessage(text: widget.initialQuestion, isUser: true));
          _messages.add(ChatMessage(
            text: 'Sorry, there was an error processing your request. Please try again.',
            isUser: false,
          ));
          _isLoading = false;
        });
      }
    }
  }

  void _handleSubmitted(String text) async {
    if (text.trim().isEmpty) return;

    final userMessage = text.trim();
    _messageController.clear();
    
    setState(() {
      _messages.add(ChatMessage(text: userMessage, isUser: true));
      _isLoading = true;
    });

    try {
      // Prepare conversation history for context
      final conversationHistory = _messages
          .where((msg) => msg.text.isNotEmpty)
          .map((msg) => {
                'role': msg.isUser ? 'user' : 'assistant',
                'content': msg.text,
              })
          .toList();

      // Get AI response
      final aiResponse = await _chatGPTService.sendMessage(
        userMessage,
        conversationHistory,
      );

      if (mounted) {
        setState(() {
          _messages.add(ChatMessage(text: aiResponse, isUser: false));
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add(
            ChatMessage(
              text: 'Sorry, there was an error processing your request. Please try again.',
              isUser: false,
            ),
          );
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildMessage(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppPallete.kenicRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Image.asset('assets/ai.png'),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: message.isUser
                    ? AppPallete.kenicRed
                    : AppPallete.kenicWhite,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(message.isUser ? 16 : 4),
                  bottomRight: Radius.circular(message.isUser ? 4 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isUser ? Colors.white : AppPallete.kenicBlack,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ),
          ),
          if (message.isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: AppPallete.scaffoldBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppPallete.kenicWhite,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppPallete.greyColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                // Title
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppPallete.kenicRed.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const HeroIcon(
                        HeroIcons.informationCircle,
                        size: 20,
                        color: AppPallete.kenicRed,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Inter(
                        text: widget.title,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        textColor: AppPallete.kenicBlack,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const HeroIcon(
                        HeroIcons.xMark,
                        size: 24,
                        color: AppPallete.kenicBlack,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Chat messages
          Expanded(
            child: _messages.isEmpty && _isLoading
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppPallete.kenicRed,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'AI is preparing your answer...',
                          style: TextStyle(
                            color: AppPallete.greyColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 100),
                    itemCount: _messages.length + (_isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _messages.length && _isLoading) {
                        return _buildLoadingMessage();
                      }
                      return _buildMessage(_messages[index]);
                    },
                  ),
          ),
          // Input area
          Container(
            padding: EdgeInsets.fromLTRB(
              16,
              16,
              16,
              16 + MediaQuery.of(context).viewInsets.bottom,
            ),
            decoration: const BoxDecoration(
              color: AppPallete.kenicWhite,
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppPallete.scaffoldBg,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _messageController,
                        enabled: !_isLoading,
                        decoration: InputDecoration(
                          hintText: _isLoading ? 'AI is processing...' : 'Ask a follow-up question...',
                          border: InputBorder.none,
                          hintStyle: const TextStyle(color: AppPallete.greyColor),
                        ),
                        style: TextStyle(
                          color: _isLoading ? AppPallete.greyColor : AppPallete.kenicBlack,
                          fontSize: 14,
                        ),
                        maxLines: 3,
                        minLines: 1,
                        onSubmitted: _isLoading ? null : _handleSubmitted,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: _isLoading ? AppPallete.greyColor : AppPallete.kenicRed,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: (_isLoading ? AppPallete.greyColor : AppPallete.kenicRed).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _isLoading ? null : () => _handleSubmitted(_messageController.text),
                        borderRadius: BorderRadius.circular(24),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          child: HeroIcon(
                            _isLoading ? HeroIcons.clock : HeroIcons.paperAirplane,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppPallete.kenicRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Image.asset('assets/ai.png'),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppPallete.kenicWhite,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppPallete.kenicRed,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'AI is thinking...',
                  style: TextStyle(
                    color: AppPallete.kenicBlack,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}
