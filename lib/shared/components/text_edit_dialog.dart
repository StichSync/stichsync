import 'package:flutter/material.dart';
import 'package:stichsync/shared/services/router/router.dart';

class TextEditDialog extends StatelessWidget {
  final String placeholder;
  final String title;
  final int limit;
  final TextEditingController _textController = TextEditingController();

  TextEditDialog({
    super.key,
    required this.placeholder,
    required this.title,
    required this.limit,
  });

  Future<String?> show(BuildContext context) {
    _textController.text = placeholder;
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          maxLength: limit,
          controller: _textController,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _clearText,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => router.pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => router.pop(_textController.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _clearText() {
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
