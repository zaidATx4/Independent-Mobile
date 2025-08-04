import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_typography.dart';
import 'theme_extensions.dart';
import '../../shared/widgets/theme/theme_switcher.dart';

/// Example usage of the theming system for the restaurant management app
/// This file demonstrates best practices for using the custom theme system
class ThemeUsageExamples extends ConsumerWidget {
  const ThemeUsageExamples({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Usage Examples'),
        actions: const [
          ThemeToggleButton(),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBasicColorsSection(context),
            const SizedBox(height: 32),
            _buildCustomColorsSection(context),
            const SizedBox(height: 32),
            _buildTypographySection(context),
            const SizedBox(height: 32),
            _buildRestaurantSpecificSection(context),
            const SizedBox(height: 32),
            _buildComponentsSection(context),
            const SizedBox(height: 32),
            _buildThemeSwitcherExamples(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicColorsSection(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Material Design 3 Colors',
          style: AppTypography.headlineSmall,
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _ColorSample('Primary', theme.colorScheme.primary),
            _ColorSample('On Primary', theme.colorScheme.onPrimary),
            _ColorSample('Secondary', theme.colorScheme.secondary),
            _ColorSample('Surface', theme.colorScheme.surface),
            _ColorSample('On Surface', theme.colorScheme.onSurface),
            _ColorSample('Error', theme.colorScheme.error),
          ],
        ),
      ],
    );
  }

  Widget _buildCustomColorsSection(BuildContext context) {
    final customColors = context.customColors;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Custom Restaurant Colors',
          style: AppTypography.headlineSmall,
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _ColorSample('Success', customColors.success),
            _ColorSample('Warning', customColors.warning),
            _ColorSample('Info', customColors.info),
            _ColorSample('Gold Accent', customColors.goldAccent),
            _ColorSample('Table Available', customColors.tableAvailable),
            _ColorSample('Table Occupied', customColors.tableOccupied),
          ],
        ),
      ],
    );
  }

  Widget _buildTypographySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Typography Scale',
          style: AppTypography.headlineSmall,
        ),
        const SizedBox(height: 16),
        const Text('Display Large', style: AppTypography.displayLarge),
        const Text('Headline Large', style: AppTypography.headlineLarge),
        const Text('Title Large', style: AppTypography.titleLarge),
        const Text('Body Large', style: AppTypography.bodyLarge),
        const Text('Label Large', style: AppTypography.labelLarge),
        const SizedBox(height: 16),
        Text(
          'Restaurant-Specific Typography',
          style: AppTypography.titleMedium,
        ),
        const SizedBox(height: 8),
        const Text('Margherita Pizza', style: AppTypography.menuTitle),
        const Text('\$18.99', style: AppTypography.menuPrice),
        const Text('Fresh tomatoes, mozzarella, basil', style: AppTypography.menuDescription),
        const Text('Table 12', style: AppTypography.tableNumber),
        const Text('7:30 PM', style: AppTypography.reservationTime),
      ],
    );
  }

  Widget _buildRestaurantSpecificSection(BuildContext context) {
    final customColors = context.customColors;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Restaurant Components',
          style: AppTypography.headlineSmall,
        ),
        const SizedBox(height: 16),
        
        // Table status indicators
        Row(
          children: [
            _TableStatusChip('Available', customColors.tableAvailable),
            const SizedBox(width: 8),
            _TableStatusChip('Occupied', customColors.tableOccupied),
            const SizedBox(width: 8),
            _TableStatusChip('Reserved', customColors.tableReserved),
            const SizedBox(width: 8),
            _TableStatusChip('Cleaning', customColors.tableCleaning),
          ],
        ),
        const SizedBox(height: 16),
        
        // Order status cards
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Order #1234', style: AppTypography.titleMedium),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: customColors.warning,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'PREPARING',
                        style: AppTypography.labelSmall.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Table 8 • 2 items', style: AppTypography.bodyMedium),
                Text('Estimated: 15 min', style: AppTypography.bodySmall),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildComponentsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Themed Components',
          style: AppTypography.headlineSmall,
        ),
        const SizedBox(height: 16),
        
        // Buttons
        Row(
          children: [
            ElevatedButton(
              onPressed: () {},
              child: const Text('Order Now'),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: () {},
              child: const Text('Reserve Table'),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () {},
              child: const Text('View Menu'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Input field
        TextField(
          decoration: const InputDecoration(
            labelText: 'Customer Name',
            hintText: 'Enter customer name',
            prefixIcon: Icon(Icons.person),
          ),
        ),
        const SizedBox(height: 16),
        
        // Switch and Slider
        Row(
          children: [
            Switch(
              value: true,
              onChanged: (value) {},
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Slider(
                value: 0.7,
                onChanged: (value) {},
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildThemeSwitcherExamples(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Theme Switcher Variants',
          style: AppTypography.headlineSmall,
        ),
        const SizedBox(height: 16),
        
        // List tile style
        const ThemeSwitcher(style: ThemeSwitcherStyle.listTile),
        const SizedBox(height: 16),
        
        // Segmented control
        const ThemeSwitcher(style: ThemeSwitcherStyle.segmentedControl),
        const SizedBox(height: 16),
        
        // Icon buttons
        const ThemeSwitcher(style: ThemeSwitcherStyle.iconButtons),
        const SizedBox(height: 16),
        
        // Dropdown
        const ThemeSwitcher(style: ThemeSwitcherStyle.dropdown),
      ],
    );
  }
}

class _ColorSample extends StatelessWidget {
  const _ColorSample(this.name, this.color);
  
  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final textColor = ThemeData.estimateBrightnessForColor(color) == Brightness.dark
        ? Colors.white
        : Colors.black;
    
    return Container(
      width: 100,
      height: 80,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              name,
              style: AppTypography.labelSmall.copyWith(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              '#${color.toARGB32().toRadixString(16).toUpperCase().substring(2).padLeft(6, '0')}',
              style: AppTypography.labelSmall.copyWith(
                color: textColor.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TableStatusChip extends StatelessWidget {
  const _TableStatusChip(this.status, this.color);
  
  final String status;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status,
        style: AppTypography.labelSmall.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// Example of using theme colors programmatically
class RestaurantCard extends StatelessWidget {
  const RestaurantCard({
    super.key,
    required this.title,
    required this.status,
    this.isUrgent = false,
  });
  
  final String title;
  final String status;
  final bool isUrgent;

  @override
  Widget build(BuildContext context) {
    final customColors = context.customColors;
    final theme = Theme.of(context);
    
    // Use theme-appropriate colors based on status
    Color statusColor;
    switch (status.toLowerCase()) {
      case 'available':
        statusColor = customColors.success;
        break;
      case 'occupied':
        statusColor = customColors.tableOccupied;
        break;
      case 'reserved':
        statusColor = customColors.warning;
        break;
      default:
        statusColor = theme.colorScheme.primary;
    }
    
    return Card(
      elevation: isUrgent ? 8 : 2,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: isUrgent 
              ? Border.all(color: customColors.warning, width: 2)
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: AppTypography.titleMedium),
                  Icon(
                    Icons.circle,
                    color: statusColor,
                    size: 12,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                status,
                style: AppTypography.bodySmall.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isUrgent) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: customColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'URGENT',
                    style: AppTypography.labelSmall.copyWith(
                      color: customColors.warning,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}