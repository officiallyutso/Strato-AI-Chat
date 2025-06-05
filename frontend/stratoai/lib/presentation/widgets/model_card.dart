import 'package:flutter/material.dart';
import '../../domain/entities/llm_provider.dart';

class ModelCard extends StatelessWidget {
  final LlmProvider model;
  final bool isSelected;
  final VoidCallback onTap;

  const ModelCard({
    Key? key,
    required this.model,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 8 : 2,
      child: InkWell(
        onTap: model.isAvailable ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  )
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getProviderColor(model.provider),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getProviderIcon(model.provider),
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const Spacer(),
                  if (isSelected)
                    Icon(
                      Icons.check_circle,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  if (!model.isAvailable)
                    Icon(
                      Icons.lock,
                      color: Colors.grey[400],
                      size: 16,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                model.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: model.isAvailable ? null : Colors.grey,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                model.provider,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: _getProviderColor(model.provider),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                model.description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: model.isAvailable ? Colors.grey[600] : Colors.grey[400],
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getProviderColor(String provider) {
    switch (provider.toLowerCase()) {
      case 'openai':
        return const Color(0xFF00A67E);
      case 'anthropic':
        return const Color(0xFFD4A574);
      case 'google':
        return const Color(0xFF4285F4);
      case 'cohere':
        return const Color(0xFF39594C);
      case 'mistral':
        return const Color(0xFFFF7000);
      default:
        return Colors.deepPurple;
    }
  }

  IconData _getProviderIcon(String provider) {
    switch (provider.toLowerCase()) {
      case 'openai':
        return Icons.psychology;
      case 'anthropic':
        return Icons.smart_toy;
      case 'google':
        return Icons.search;
      case 'cohere':
        return Icons.hub;
      case 'mistral':
        return Icons.air;
      default:
        return Icons.memory;
    }
  }
}
