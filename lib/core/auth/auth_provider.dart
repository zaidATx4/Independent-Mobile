import 'package:flutter_riverpod/flutter_riverpod.dart';

// Simple authentication state
class AuthState {
  final bool isAuthenticated;
  final bool hasCompletedOnboarding;
  final String? userId;

  const AuthState({
    this.isAuthenticated = false,
    this.hasCompletedOnboarding = false,
    this.userId,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? hasCompletedOnboarding,
    String? userId,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      hasCompletedOnboarding: hasCompletedOnboarding ?? this.hasCompletedOnboarding,
      userId: userId ?? this.userId,
    );
  }
}

// Auth notifier
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  void completeOnboarding() {
    state = state.copyWith(hasCompletedOnboarding: true);
  }

  void login(String userId) {
    state = state.copyWith(
      isAuthenticated: true,
      userId: userId,
    );
  }

  void logout() {
    state = const AuthState();
  }
}

// Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});