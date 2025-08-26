import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

enum OrderStatus { active, past }

class OrderItem {
  final String brandName;
  final String brandIcon;
  final String location;
  final double price;
  final String date;
  final OrderStatus status;

  const OrderItem({
    required this.brandName,
    required this.brandIcon,
    required this.location,
    required this.price,
    required this.date,
    required this.status,
  });
}

final orderHistoryProvider = StateProvider<List<OrderItem>>((ref) => [
  const OrderItem(
    brandName: 'Salt',
    brandIcon: 'assets/images/logos/brands/Salt.png',
    location: 'Somewhere Dubai Mall, Dubai.',
    price: 125.2,
    date: 'April 11, 2025',
    status: OrderStatus.active,
  ),
  const OrderItem(
    brandName: 'Somewhere',
    brandIcon: 'assets/images/logos/brands/Somewhere.png',
    location: 'Somewhere Dubai Mall, Dubai.',
    price: 125.2,
    date: 'April 11, 2025',
    status: OrderStatus.active,
  ),
  const OrderItem(
    brandName: 'Joe and Juice',
    brandIcon: 'assets/images/logos/brands/Joe_and _juice.png',
    location: 'Somewhere Dubai Mall, Dubai.',
    price: 125.2,
    date: 'April 11, 2025',
    status: OrderStatus.active,
  ),
  const OrderItem(
    brandName: 'Parkers',
    brandIcon: 'assets/images/logos/brands/Parkers.png',
    location: 'Somewhere Dubai Mall, Dubai.',
    price: 125.2,
    date: 'April 11, 2025',
    status: OrderStatus.past,
  ),
  const OrderItem(
    brandName: 'Salt',
    brandIcon: 'assets/images/logos/brands/Salt.png',
    location: 'Somewhere Dubai Mall, Dubai.',
    price: 125.2,
    date: 'April 11, 2025',
    status: OrderStatus.past,
  ),
  const OrderItem(
    brandName: 'Somewhere',
    brandIcon: 'assets/images/logos/brands/Somewhere.png',
    location: 'Somewhere Dubai Mall, Dubai.',
    price: 125.2,
    date: 'April 11, 2025',
    status: OrderStatus.past,
  ),
]);

class OrderHistoryScreen extends ConsumerWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(orderHistoryProvider);
    final activeOrders = orders.where((order) => order.status == OrderStatus.active).toList();
    final pastOrders = orders.where((order) => order.status == OrderStatus.past).toList();
    final theme = Theme.of(context);
    final isLightTheme = theme.brightness == Brightness.light;

    return Scaffold(
      backgroundColor: isLightTheme ? const Color(0xFFFFFCF5) : const Color(0xFF1A1A1A),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(context, isLightTheme),
              
              const SizedBox(height: 24),
              
              // Active Orders Section
              if (activeOrders.isNotEmpty) ...[
                _buildSectionHeader('Active Orders', isLightTheme),
                const SizedBox(height: 8),
                _buildOrdersList(activeOrders, isLightTheme),
                const SizedBox(height: 32),
              ],
              
              // Past Orders Section
              if (pastOrders.isNotEmpty) ...[
                _buildSectionHeader('Past Orders', isLightTheme),
                const SizedBox(height: 8),
                _buildOrdersList(pastOrders, isLightTheme),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isLightTheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isLightTheme 
                    ? const Color(0xFF1A1A1A)
                    : const Color(0xFFFEFEFF),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(44),
              ),
              child: Icon(
                Icons.arrow_back,
                color: isLightTheme 
                  ? const Color(0xFF1A1A1A)
                  : const Color(0xFFFEFEFF),
                size: 16,
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // Title
          Expanded(
            child: Text(
              'Order History',
              style: TextStyle(
                color: isLightTheme 
                  ? const Color(0xCC1A1A1A)
                  : const Color(0xCCFEFEFF),
                fontSize: 24,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                height: 32 / 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isLightTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: TextStyle(
          color: isLightTheme 
            ? const Color(0xCC1A1A1A)
            : const Color(0xCCFEFEFF),
          fontSize: 14,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.normal,
          height: 21 / 14,
        ),
      ),
    );
  }

  Widget _buildOrdersList(List<OrderItem> orders, bool isLightTheme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: orders.map((order) => _buildOrderItem(order, isLightTheme)).toList(),
      ),
    );
  }

  Widget _buildOrderItem(OrderItem order, bool isLightTheme) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: isLightTheme 
              ? const Color(0xFFD9D9D9)
              : const Color(0xFF4D4E52),
            width: 1,
          ),
          bottom: BorderSide(
            color: isLightTheme 
              ? const Color(0xFFD9D9D9)
              : const Color(0xFF4D4E52),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Brand icon
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: AssetImage(order.brandIcon),
                fit: BoxFit.cover,
                onError: (error, stackTrace) {
                  debugPrint('Error loading brand icon: $error');
                },
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.transparent,
              ),
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Order details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Restaurant name and location
                Text(
                  order.location,
                  style: TextStyle(
                    color: isLightTheme 
                      ? const Color(0xFF1A1A1A)
                      : const Color(0xFFFEFEFF),
                    fontSize: 14,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.normal,
                    height: 21 / 14,
                  ),
                ),
                
                const SizedBox(height: 2),
                
                // Price with SAR symbol
                Row(
                  children: [
                    Text(
                      order.price.toString(),
                      style: TextStyle(
                        color: isLightTheme 
                          ? const Color(0xCC1A1A1A)
                          : const Color(0xCCFEFEFF),
                        fontSize: 14,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.normal,
                        height: 21 / 14,
                      ),
                    ),
                    const SizedBox(width: 2),
                    SizedBox(
                      width: 10,
                      height: 11.429,
                      child: SvgPicture.asset(
                        'assets/images/icons/SVGs/Loyalty/SAR.svg',
                        width: 10,
                        height: 11.429,
                        colorFilter: ColorFilter.mode(
                          isLightTheme 
                            ? const Color(0xCC1A1A1A)
                            : const Color(0xCCFEFEFF),
                          BlendMode.srcIn,
                        ),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 2),
                
                // Date
                Text(
                  order.date,
                  style: TextStyle(
                    color: isLightTheme 
                      ? const Color(0xFF878787)
                      : const Color(0xFF9C9C9D),
                    fontSize: 12,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.normal,
                    height: 18 / 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
