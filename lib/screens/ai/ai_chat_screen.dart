import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../models/chat_message_model.dart';
import '../../services/ai_service.dart';
import '../../widgets/custom_app_bar.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final List<ChatMessageModel> _messages = [
    ChatMessageModel(
      role: 'assistant',
      content:
          'Namaste! I am Khushi Care AI, your healthcare assistant.\n\nI can help explain medical terms, provide wellness advice, and guide you to appropriate care. Please note: I do not replace a licensed medical doctor. For emergencies, dial 108 or 112 immediately.',
    ),
  ];

  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  String _selectedLang = 'en';

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage([String? quickText]) async {
    final text = quickText ?? _textController.text.trim();
    if (text.isEmpty || _isLoading) return;

    final userMsg = ChatMessageModel(role: 'user', content: text);
    setState(() {
      _messages.add(userMsg);
      if (quickText == null) _textController.clear();
      _isLoading = true;
    });
    _scrollToBottom();

    final reply = await AiService.getChatResponse(
      messages: _messages,
      language: _selectedLang,
    );

    if (!mounted) return;

    setState(() {
      _messages.add(ChatMessageModel(role: 'assistant', content: reply));
      _isLoading = false;
    });
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Khushi Care AI',
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.translate, size: 20, color: AppColors.primary),
            tooltip: 'Select Language',
            onSelected: (val) {
              setState(() => _selectedLang = val);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'AI language changed to ${AppConstants.languages[val]}'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(value: 'en', child: Text('English')),
              const PopupMenuItem(value: 'hi', child: Text('हिंदी (Hindi)')),
              const PopupMenuItem(value: 'te', child: Text('తెలుగు (Telugu)')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Safety Emergency Warning Ribbon
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            color: const Color(0xFFFEF3C7),
            child: const Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: Color(0xFFB45309)),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'For immediate life-threatening symptoms, call 108 or visit nearest ER.',
                    style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFFB45309),
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),

          // Message Bubbles
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (ctx, i) {
                if (i == _messages.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: AppColors.primaryLight,
                          child: Icon(Icons.auto_awesome,
                              size: 14, color: AppColors.primary),
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Khushi AI is thinking...',
                          style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textMuted,
                              fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  );
                }

                final msg = _messages[i];
                return _ChatBubble(message: msg);
              },
            ),
          ),

          // Quick Prompt suggestions
          if (_messages.length <= 2)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                children: [
                  _QuickPromptChip(
                    text: 'What should I do for high fever?',
                    onTap: () => _sendMessage('What should I do for high fever?'),
                  ),
                  _QuickPromptChip(
                    text: 'Tips for managing blood sugar',
                    onTap: () =>
                        _sendMessage('Tips for managing blood sugar'),
                  ),
                  _QuickPromptChip(
                    text: 'When to visit emergency?',
                    onTap: () => _sendMessage('When to visit emergency?'),
                  ),
                ],
              ),
            ),

          // Input Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        hintText: 'Type your health question...',
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: _isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Icon(Icons.send_rounded,
                              color: Colors.white, size: 20),
                      onPressed: _isLoading ? null : () => _sendMessage(),
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
}

class _ChatBubble extends StatelessWidget {
  final ChatMessageModel message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            const CircleAvatar(
              radius: 14,
              backgroundColor: AppColors.primaryLight,
              child: Icon(Icons.auto_awesome, size: 14, color: AppColors.primary),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isUser ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(14),
                  topRight: const Radius.circular(14),
                  bottomLeft: Radius.circular(isUser ? 14 : 2),
                  bottomRight: Radius.circular(isUser ? 2 : 14),
                ),
                border: isUser ? null : Border.all(color: AppColors.border),
              ),
              child: Text(
                message.content,
                style: TextStyle(
                  color: isUser ? Colors.white : AppColors.textDark,
                  fontSize: 14,
                  height: 1.45,
                ),
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            const CircleAvatar(
              radius: 14,
              backgroundColor: AppColors.surface,
              child: Icon(Icons.person, size: 16, color: AppColors.textMuted),
            ),
          ],
        ],
      ),
    );
  }
}

class _QuickPromptChip extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _QuickPromptChip({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Text(text, style: const TextStyle(fontSize: 12)),
        backgroundColor: Colors.white,
        side: const BorderSide(color: AppColors.border),
        onPressed: onTap,
      ),
    );
  }
}
