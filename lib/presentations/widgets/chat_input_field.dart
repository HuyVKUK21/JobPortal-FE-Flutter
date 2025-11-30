import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';

class ChatInputField extends StatefulWidget {
  final Function(String) onSendMessage;
  final VoidCallback? onAttachFile;
  final VoidCallback? onAttachImage;
  final VoidCallback? onAttachCamera;

  const ChatInputField({
    super.key,
    required this.onSendMessage,
    this.onAttachFile,
    this.onAttachImage,
    this.onAttachCamera,
  });

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _hasText = _controller.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_hasText) {
      widget.onSendMessage(_controller.text.trim());
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
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
            // Attach buttons
            if (!_hasText) ...[
              IconButton(
                icon: const Icon(Icons.camera_alt_outlined),
                color: AppColors.primary,
                onPressed: widget.onAttachCamera,
                tooltip: 'Camera',
              ),
              IconButton(
                icon: const Icon(Icons.image_outlined),
                color: AppColors.primary,
                onPressed: widget.onAttachImage,
                tooltip: 'Gallery',
              ),
              IconButton(
                icon: const Icon(Icons.attach_file),
                color: AppColors.primary,
                onPressed: widget.onAttachFile,
                tooltip: 'File',
              ),
            ],
            // Text field
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Nhập tin nhắn...',
                    hintStyle: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 15,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                  maxLines: null,
                  textInputAction: TextInputAction.newline,
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Send button
            Container(
              decoration: BoxDecoration(
                color: _hasText ? AppColors.primary : Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.send),
                color: Colors.white,
                onPressed: _hasText ? _sendMessage : null,
                tooltip: 'Send',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
