import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth/auth_cubit.dart';
import '../bloc/chat/chat_cubit.dart';
import '../bloc/chat/chat_state.dart';
import '../../core/di/injection.dart' as di;
import 'model_selection_screen.dart';
import 'chat_screen.dart';
import '../widgets/chat_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ChatCubit _chatCubit;

  @override
  void initState() {
    super.initState();
    _chatCubit = di.sl<ChatCubit>();
    final authCubit = context.read<AuthCubit>();
    if (authCubit.currentUserId != null) {
      _chatCubit.loadChats(authCubit.currentUserId!);
    }
  }

  @override
  void dispose() {
    _chatCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StratoAI'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthCubit>().signOut();
            },
          ),
        ],
      ),
      body: BlocProvider<ChatCubit>(
        create: (context) => _chatCubit,
        child: BlocBuilder<ChatCubit, ChatState>(
          builder: (context, state) {
            if (state is ChatLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ChatsLoaded) {
              if (state.chats.isEmpty) {
                return _buildEmptyState();
              }
              return _buildChatsList(state.chats);
            } else if (state is ChatError) {
              return _buildErrorState(state.message);
            }
            return _buildEmptyState();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ModelSelectionScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('New Chat'),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No chats yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start a conversation with AI models',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ModelSelectionScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Start New Chat'),
          ),
        ],
      ),
    );
  }

  Widget _buildChatsList(List<dynamic> chats) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final chat = chats[index];
        return ChatTile(
          chat: chat,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(chatId: chat.id),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading chats',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.red[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              final authCubit = context.read<AuthCubit>();
              if (authCubit.currentUserId != null) {
                _chatCubit.loadChats(authCubit.currentUserId!);
              }
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}