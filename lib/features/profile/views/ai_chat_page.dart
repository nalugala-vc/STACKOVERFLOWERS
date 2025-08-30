import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:kenic/core/utils/fonts/inter.dart';
import 'package:kenic/core/utils/theme/app_pallete.dart';
import 'package:kenic/features/profile/services/chat_gpt_service.dart';

class AIChatPage extends StatefulWidget {
  const AIChatPage({super.key});

  @override
  State<AIChatPage> createState() => _AIChatPageState();
}

class _AIChatPageState extends State<AIChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatGPTService _chatGPTService = ChatGPTService();
  bool _isLoading = false;

  final List<ChatMessage> _messages = [
    ChatMessage(
      text:
          'Hello! I\'m Kenic Helper, your AI assistant. How can I help you today?',
      isUser: false,
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _chatGPTService.dispose();
    super.dispose();
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
      final conversationHistory =
          _messages
              .where((msg) => msg.text.isNotEmpty)
              .map(
                (msg) => {
                  'role': msg.isUser ? 'user' : 'assistant',
                  'content': msg.text,
                },
              )
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
              text:
                  'Sorry, there was an error processing your request. Please try again.',
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
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppPallete.kenicRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Image.asset('assets/ai.png'),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color:
                    message.isUser
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
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isUser ? Colors.white : AppPallete.kenicBlack,
                  fontSize: 14,
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
    return Scaffold(
      backgroundColor: AppPallete.scaffoldBg,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: AppPallete.kenicWhite,
            elevation: 0,
            leading: IconButton(
              icon: HeroIcon(
                HeroIcons.chevronLeft,
                color: AppPallete.kenicBlack,
              ),
              onPressed: () => Get.back(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Inter(
                text: 'Kenic Helper',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                textColor: AppPallete.kenicBlack,
              ),
              background: Container(
                decoration: BoxDecoration(
                  color: AppPallete.kenicWhite,
                  image: const DecorationImage(
                    image: AssetImage('assets/ai.png'),
                    fit: BoxFit.contain,
                    scale: 2,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(0.2),

                        Colors.red.withOpacity(0.5),
                        Colors.red.withOpacity(0.3),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 16,
              decoration: const BoxDecoration(
                color: AppPallete.kenicWhite,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildMessage(_messages[index]),
              childCount: _messages.length,
            ),
          ),
          if (_isLoading)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppPallete.kenicRed.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Image.asset('assets/ai.png'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppPallete.kenicWhite,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
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
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
        ],
      ),
      bottomSheet: Container(
        color: AppPallete.scaffoldBg,
        child: Container(
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            16 + MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: BoxDecoration(
            color: AppPallete.kenicWhite,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
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
                        hintText:
                            _isLoading
                                ? 'AI is processing...'
                                : 'Type your message...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: AppPallete.greyColor),
                      ),
                      style: TextStyle(
                        color:
                            _isLoading
                                ? AppPallete.greyColor
                                : AppPallete.kenicBlack,
                        fontSize: 14,
                      ),
                      maxLines: 4,
                      minLines: 1,
                      onSubmitted: _isLoading ? null : _handleSubmitted,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color:
                        _isLoading ? AppPallete.greyColor : AppPallete.kenicRed,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: (_isLoading
                                ? AppPallete.greyColor
                                : AppPallete.kenicRed)
                            .withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap:
                          _isLoading
                              ? null
                              : () => _handleSubmitted(_messageController.text),
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        child: HeroIcon(
                          _isLoading
                              ? HeroIcons.clock
                              : HeroIcons.paperAirplane,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}
