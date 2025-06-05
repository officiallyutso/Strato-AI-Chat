import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stratoai/presentation/bloc/models/models_state.dart';
import '../bloc/auth/auth_cubit.dart';
import '../bloc/chat/chat_cubit.dart';
import '../bloc/chat/chat_state.dart';
import '../bloc/models/models_cubit.dart';
import '../../core/di/injection.dart' as di;
import '../../domain/entities/chat.dart';
import '../../domain/entities/llm_provider.dart';
import '../widgets/message_bubble.dart';
import '../widgets/response_card.dart';
import 'model_selection_screen.dart';

class ChatScreen extends StatefulWidget {
  final String? chatId;
  
  const ChatScreen({Key? key, this.chatId}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late ChatCubit _chatCubit;
  Chat? currentChat;

  @override
  void initState() {
    super.initState();
    _chatCubit = di.sl<ChatCubit>();
    if (widget.chatId != null) {
      // Load existing chat
      _loadChat();
    }
  }

  void _loadChat() {
    // Implementation depends on your backend API
    // For now, we'll load from the chats list
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _chatCubit.close();
    super.dispose();
  }

  void _sendMessage({List<String>? additionalModelIds}) {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    final userId = context.read<AuthCubit>().currentUserId;
    if (userId == null) return;

    List<String> modelIds = additionalModelIds ?? [];
    
    if (widget.chatId != null) {
      _chatCubit.continueChat(widget.chatId!, message, modelIds, userId);
    } else {
      _chatCubit.sendMessage(message, modelIds, userId);
    }
    
    _messageController.clear();
    _scrollToBottom();
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

  void _chainResponse(String responseContent) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                'Chain Response to Other Models',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ModelSelectionForChaining(
                  originalResponse: responseContent,
                  onModelsSelected: (selectedModels) {
                    Navigator.pop(context);
                    final modelIds = selectedModels.map((m) => m.id).toList();
                    _sendMessage(additionalModelIds: modelIds);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentChat?.title ?? 'Chat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Show chat options
            },
          ),
        ],
      ),
      body: BlocProvider<ChatCubit>(
        create: (context) => _chatCubit,
        child: BlocListener<ChatCubit, ChatState>(
          listener: (context, state) {
            if (state is MessageSent || state is ChatLoaded) {
              if (state is MessageSent) {
                currentChat = state.updatedChat;
              } else if (state is ChatLoaded) {
                currentChat = state.chat;
              }
              _scrollToBottom();
            } else if (state is ChatError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${state.message}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<ChatCubit, ChatState>(
                  builder: (context, state) {
                    if (currentChat == null) {
                      return const Center(
                        child: Text('Start a conversation'),
                      );
                    }
                    
                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: currentChat!.messages.length,
                      itemBuilder: (context, index) {
                        final message = currentChat!.messages[index];
                        
                        if (message.role == 'user') {
                          return MessageBubble(
                            content: message.content,
                            isUser: true,
                            timestamp: message.timestamp,
                          );
                        } else {
                          return Column(
                            children: message.responses?.map((response) {
                              return ResponseCard(
                                response: response,
                                onChain: () => _chainResponse(response.content),
                              );
                            }).toList() ?? [],
                          );
                        }
                      },
                    );
                  },
                ),
              ),
              
              // Message input
              BlocBuilder<ChatCubit, ChatState>(
                builder: (context, state) {
                  final isLoading = state is MessageSending;
                  
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            enabled: !isLoading,
                            maxLines: null,
                            decoration: InputDecoration(
                              hintText: 'Type your message...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            onSubmitted: (_) => _sendMessage(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        FloatingActionButton(
                          onPressed: isLoading ? null : () => _sendMessage(),
                          mini: true,
                          child: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Icon(Icons.send),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ModelSelectionForChaining extends StatefulWidget {
  final String originalResponse;
  final Function(List<LlmProvider>) onModelsSelected;

  const ModelSelectionForChaining({
    Key? key,
    required this.originalResponse,
    required this.onModelsSelected,
  }) : super(key: key);

  @override
  _ModelSelectionForChainingState createState() => _ModelSelectionForChainingState();
}

class _ModelSelectionForChainingState extends State<ModelSelectionForChaining> {
  late ModelsCubit _modelsCubit;

  @override
  void initState() {
    super.initState();
    _modelsCubit = di.sl<ModelsCubit>();
    _modelsCubit.loadModels();
  }

  @override
  void dispose() {
    _modelsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ModelsCubit>(
      create: (context) => _modelsCubit,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Original Response:',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.originalResponse.length > 100
                      ? '${widget.originalResponse.substring(0, 100)}...'
                      : widget.originalResponse,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: BlocBuilder<ModelsCubit, ModelsState>(
              builder: (context, state) {
                if (state is ModelsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ModelsLoaded) {
                  return Column(
                    children: [
                      if (state.selectedModels.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${state.selectedModels.length} selected'),
                              ElevatedButton(
                                onPressed: () {
                                  widget.onModelsSelected(state.selectedModels);
                                },
                                child: const Text('Chain Response'),
                              ),
                            ],
                          ),
                        ),
                      Expanded(
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: state.models.length,
                          itemBuilder: (context, index) {
                            final model = state.models[index];
                            final isSelected = state.selectedModels.contains(model);
                            
                            return InkWell(
                              onTap: () => _modelsCubit.toggleModelSelection(model),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: isSelected
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.grey[300]!,
                                    width: isSelected ? 2 : 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.smart_toy,
                                      color: isSelected
                                          ? Theme.of(context).colorScheme.primary
                                          : Colors.grey,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      model.name,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
                return const Center(child: Text('Error loading models'));
              },
            ),
          ),
        ],
      ),
    );
  }
}