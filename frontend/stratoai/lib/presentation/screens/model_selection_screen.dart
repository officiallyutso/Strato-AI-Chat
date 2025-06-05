import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth/auth_cubit.dart';
import '../bloc/models/models_cubit.dart';
import '../bloc/models/models_state.dart';
import '../../core/di/injection.dart' as di;
import 'new_chat_screen.dart';
import '../widgets/model_card.dart';

class ModelSelectionScreen extends StatefulWidget {
  const ModelSelectionScreen({Key? key}) : super(key: key);

  @override
  _ModelSelectionScreenState createState() => _ModelSelectionScreenState();
}

class _ModelSelectionScreenState extends State<ModelSelectionScreen> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Models'),
        actions: [
          BlocProvider<ModelsCubit>(
            create: (context) => _modelsCubit,
            child: BlocBuilder<ModelsCubit, ModelsState>(
              builder: (context, state) {
                if (state is ModelsLoaded && state.selectedModels.isNotEmpty) {
                  return TextButton(
                    onPressed: () {
                      final userId = context.read<AuthCubit>().currentUserId;
                      if (userId != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewChatScreen(
                              selectedModels: state.selectedModels,
                              userId: userId,
                            ),
                          ),
                        );
                      }
                    },
                    child: Text('Continue (${state.selectedModels.length})'),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      body: BlocProvider<ModelsCubit>(
        create: (context) => _modelsCubit,
        child: BlocBuilder<ModelsCubit, ModelsState>(
          builder: (context, state) {
            if (state is ModelsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ModelsLoaded) {
              return _buildModelsList(state);
            } else if (state is ModelsError) {
              return _buildErrorState(state.message);
            }
            return const Center(child: Text('Select AI models to chat with'));
          },
        ),
      ),
    );
  }

  Widget _buildModelsList(ModelsLoaded state) {
    return Column(
      children: [
        if (state.selectedModels.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${state.selectedModels.length} model(s) selected',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TextButton(
                  onPressed: () => _modelsCubit.clearSelection(),
                  child: const Text('Clear All'),
                ),
              ],
            ),
          ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: state.models.length,
            itemBuilder: (context, index) {
              final model = state.models[index];
              final isSelected = state.selectedModels.contains(model);
              
              return ModelCard(
                model: model,
                isSelected: isSelected,
                onTap: () => _modelsCubit.toggleModelSelection(model),
              );
            },
          ),
        ),
      ],
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
            'Error loading models',
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
            onPressed: () => _modelsCubit.loadModels(),
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
