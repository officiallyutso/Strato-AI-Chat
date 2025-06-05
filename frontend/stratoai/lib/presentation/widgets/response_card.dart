import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/entities/chat.dart';


class MessageResponse {
  final String modelId;
  final String content;
  final DateTime? timestamp;

  MessageResponse({
    required this.modelId,
    required this.content,
    this.timestamp,
  });
}

class ResponseCard extends StatefulWidget {
  final MessageResponse response;
  final VoidCallback onChain;

  const ResponseCard({
    Key? key,
    required this.response,
    required this.onChain,
  }) : super(key: key);

  @override
  _ResponseCardState createState() => _ResponseCardState();
}

class _ResponseCardState extends State<ResponseCard> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with model info
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getModelColor(widget.response.modelId).withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _getModelIcon(widget.response.modelId),
                  color: _getModelColor(widget.response.modelId),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.response.modelId,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: _getModelColor(widget.response.modelId),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                ),
              ],
            ),
          ),
          
          // Response content
          if (_isExpanded) ...[
            Padding(
              padding: const EdgeInsets.all(16),
              child: SelectableText(
                widget.response.content,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            
            // Action buttons
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
              child: Row(
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.copy, size: 16),
                    label: const Text('Copy'),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: widget.response.content));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Response copied to clipboard'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    icon: const Icon(Icons.link, size: 16),
                    label: const Text('Chain'),
                    onPressed: widget.onChain,
                  ),
                  const Spacer(),
                  if (widget.response.timestamp != null)
                    Text(
                      _formatTime(widget.response.timestamp!),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getModelColor(String modelId) {
    if (modelId.toLowerCase().contains('gpt') || modelId.toLowerCase().contains('openai')) {
      return const Color(0xFF00A67E);
    } else if (modelId.toLowerCase().contains('claude') || modelId.toLowerCase().contains('anthropic')) {
      return const Color(0xFFD4A574);
    } else if (modelId.toLowerCase().contains('gemini') || modelId.toLowerCase().contains('google')) {
      return const Color(0xFF4285F4);
    } else if (modelId.toLowerCase().contains('cohere')) {
      return const Color(0xFF39594C);
    } else if (modelId.toLowerCase().contains('mistral')) {
      return const Color(0xFFFF7000);
    }
    return Colors.deepPurple;
  }

  IconData _getModelIcon(String modelId) {
    if (modelId.toLowerCase().contains('gpt') || modelId.toLowerCase().contains('openai')) {
      return Icons.psychology;
    } else if (modelId.toLowerCase().contains('claude') || modelId.toLowerCase().contains('anthropic')) {
      return Icons.smart_toy;
    } else if (modelId.toLowerCase().contains('gemini') || modelId.toLowerCase().contains('google')) {
      return Icons.search;
    } else if (modelId.toLowerCase().contains('cohere')) {
      return Icons.hub;
    } else if (modelId.toLowerCase().contains('mistral')) {
      return Icons.air;
    }
    return Icons.memory;
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}
