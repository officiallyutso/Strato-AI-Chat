import 'package:flutter/material.dart';
import '../../domain/entities/llm_provider.dart';

class ModelChip extends StatelessWidget {
  final LlmProvider model;

  const ModelChip({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(
        Icons.smart_toy,
        size: 18,
        color: Theme.of(context).colorScheme.onSecondaryContainer,
      ),
      label: Text(
        model.name,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSecondaryContainer,
          fontSize: 12,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
    );
  }
}