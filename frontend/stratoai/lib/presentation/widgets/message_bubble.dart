import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String content;
  final bool isUser;
  final DateTime timestamp;

  const MessageBubble({
    Key? key,
    required this.content,
    required this.isUser,
    required this.timestamp,
  }) : super()