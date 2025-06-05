import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stratoai/presentation/bloc/auth/auth_state.dart';
import 'presentation/bloc/auth/auth_cubit.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/chat_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: MaterialApp(
        title: 'StratoAI',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            // No additional navigation needed here as screens handle their own navigation
          },
          builder: (context, state) {
            if (state is Authenticated) {
              return const ChatScreen();
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
