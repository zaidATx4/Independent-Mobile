import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/wallet_card.dart';
import '../../domain/entities/wallet_entities.dart';

/// My Wallets List Screen - Shows all user wallets
/// Entry point for wallet management, displays multiple wallet cards
class MyWalletsListScreen extends ConsumerStatefulWidget {
  const MyWalletsListScreen({super.key});

  @override
  ConsumerState<MyWalletsListScreen> createState() => _MyWalletsListScreenState();
}

class _MyWalletsListScreenState extends ConsumerState<MyWalletsListScreen> {
  // Mock wallet data matching Figma design
  final List<WalletEntity> mockWallets = [
    WalletEntity(
      id: 'team-lunch-1',
      userId: 'user-1',
      displayName: 'Team Lunch',
      balance: 4250.0,
      currency: 'SAR',
      lastUpdated: DateTime.now(),
      isActive: true,
      type: WalletType.teamLunch,
      resetDate: DateTime(2024, 5, 5),
      backgroundImageUrl: 'assets/images/illustrations/Wallet_1.jpg',
    ),
    WalletEntity(
      id: 'team-lunch-2',
      userId: 'user-1',
      displayName: 'Team Lunch',
      balance: 5050.0,
      currency: 'SAR',
      lastUpdated: DateTime.now(),
      isActive: true,
      type: WalletType.teamLunch,
      resetDate: DateTime(2024, 5, 5),
      backgroundImageUrl: 'assets/images/illustrations/Wallet_2.jpg',
    ),
    WalletEntity(
      id: 'team-lunch-3',
      userId: 'user-1',
      displayName: 'Team Lunch',
      balance: 250.0,
      currency: 'SAR',
      lastUpdated: DateTime.now(),
      isActive: true,
      type: WalletType.teamLunch,
      resetDate: DateTime(2024, 5, 5),
      backgroundImageUrl: 'assets/images/illustrations/Wallet_3.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A), // indpt/neutral
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),
            
            // Wallets List
            Expanded(
              child: _buildWalletsList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Back button
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFFEFEFF), // indpt/text primary
                width: 1,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => context.pop(),
                borderRadius: BorderRadius.circular(20),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Color(0xFFFEFEFF), // indpt/text primary
                  size: 16,
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Title
          const Expanded(
            child: Text(
              'My Wallets',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 24,
                fontWeight: FontWeight.w700, // Bold
                color: Color(0xFFFEFEFF), // indpt/text primary
                height: 32 / 24, // line height
              ),
            ),
          ),
          
          // Add wallet button
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFFFBF1), // indpt/sand
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  context.push('/wallet/add');
                },
                borderRadius: BorderRadius.circular(20),
                child: const Icon(
                  Icons.add,
                  color: Color(0xFF242424), // indpt/accent
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletsList() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate responsive padding (4.3% of screen width as per Figma)
        final horizontalPadding = constraints.maxWidth * 0.043;
        
        return ListView.builder(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            0,
            horizontalPadding,
            100, // Bottom safe area
          ),
          itemCount: mockWallets.length,
          itemBuilder: (context, index) {
            final wallet = mockWallets[index];
            
            return Container(
              margin: EdgeInsets.only(
                bottom: index < mockWallets.length - 1 ? 16 : 0,
              ),
              child: WalletCard(
                wallet: wallet,
                onTap: () {
                  context.push('/wallet/details/${wallet.id}');
                },
              ),
            );
          },
        );
      },
    );
  }
}