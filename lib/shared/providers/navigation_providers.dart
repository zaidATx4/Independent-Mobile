import 'package:flutter_riverpod/flutter_riverpod.dart';

// Navigation provider for bottom tab selection
final selectedTabProvider = StateProvider<int>((ref) => 0);

// User data providers
final userNameProvider = StateProvider<String>((ref) => 'John Doe');
final userLoyaltyPointsProvider = StateProvider<int>((ref) => 2500);
final userMembershipProvider = StateProvider<String>((ref) => 'Gold Member');
final loyaltyProgressProvider = StateProvider<double>(
  (ref) => 0.5,
); // 2500/5000