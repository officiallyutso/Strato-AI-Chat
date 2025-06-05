import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthCubit() : super(AuthInitial()) {
    // Check if user is already signed in
    _firebaseAuth.authStateChanges().listen((User? user) {
      if (user != null) {
        emit(Authenticated(user.uid));
      } else {
        emit(Unauthenticated());
      }
    });
  }

  Future<void> signIn(String email, String password) async {
    emit(AuthLoading());
    try {
      final UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(Authenticated(userCredential.user!.uid));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? 'An error occurred'));
    }
  }

  Future<void> signUp(String email, String password) async {
    emit(AuthLoading());
    try {
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(Authenticated(userCredential.user!.uid));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? 'An error occurred'));
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    emit(Unauthenticated());
  }

  String? get currentUserId => _firebaseAuth.currentUser?.uid;
}