import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme_service.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/theme_extensions.dart';

/// A widget that provides theme switching functionality
/// Can be displayed as a list tile, segmented control, or icon buttons
class ThemeSwitcher extends ConsumerWidget {
  const ThemeSwitcher({
    super.key,
    this.style = ThemeSwitcherStyle.listTile,
    this.showLabels = true,
    this.compact = false,
  });
  
  final ThemeSwitcherStyle style;
  final bool showLabels;
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);
    
    switch (style) {
      case ThemeSwitcherStyle.listTile:
        return _buildListTile(context, currentTheme, themeNotifier);
      case ThemeSwitcherStyle.segmentedControl:
        return _buildSegmentedControl(context, currentTheme, themeNotifier);
      case ThemeSwitcherStyle.iconButtons:
        return _buildIconButtons(context, currentTheme, themeNotifier);
      case ThemeSwitcherStyle.dropdown:
        return _buildDropdown(context, currentTheme, themeNotifier);
    }
  }
  
  Widget _buildListTile(BuildContext context, AppThemeMode currentTheme, ThemeNotifier notifier) {
    return ListTile(
      leading: Icon(
        currentTheme.icon,
        color: context.customColors.info,
      ),
      title: Text(
        'Theme',
        style: AppTypography.titleMedium,
      ),
      subtitle: Text(
        currentTheme.name,
        style: AppTypography.bodySmall,
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => _showThemeDialog(context, currentTheme, notifier),
    );
  }
  
  Widget _buildSegmentedControl(BuildContext context, AppThemeMode currentTheme, ThemeNotifier notifier) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: AppThemeMode.values.map((mode) {
          final isSelected = mode == currentTheme;
          return Expanded(
            child: GestureDetector(
              onTap: () => notifier.setThemeMode(mode),
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: compact ? 8 : 12,
                  horizontal: compact ? 12 : 16,
                ),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      mode.icon,
                      size: compact ? 16 : 20,
                      color: isSelected
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    if (showLabels && !compact) ...[
                      const SizedBox(width: 8),
                      Text(
                        mode.name,
                        style: AppTypography.labelMedium.copyWith(
                          color: isSelected
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
  
  Widget _buildIconButtons(BuildContext context, AppThemeMode currentTheme, ThemeNotifier notifier) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: AppThemeMode.values.map((mode) {
        final isSelected = mode == currentTheme;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: IconButton(
            onPressed: () => notifier.setThemeMode(mode),
            icon: Icon(mode.icon),
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
            tooltip: mode.name,
          ),
        );
      }).toList(),
    );
  }
  
  Widget _buildDropdown(BuildContext context, AppThemeMode currentTheme, ThemeNotifier notifier) {
    return DropdownButton<AppThemeMode>(
      value: currentTheme,
      items: AppThemeMode.values.map((mode) {
        return DropdownMenuItem(
          value: mode,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(mode.icon, size: 20),
              const SizedBox(width: 12),
              Text(mode.name),
            ],
          ),
        );
      }).toList(),
      onChanged: (mode) {
        if (mode != null) {
          notifier.setThemeMode(mode);
        }
      },
      underline: const SizedBox.shrink(),
    );
  }
  
  void _showThemeDialog(BuildContext context, AppThemeMode currentTheme, ThemeNotifier notifier) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: AppThemeMode.values.map((mode) {
            return RadioListTile<AppThemeMode>(
              value: mode,
              groupValue: currentTheme,
              onChanged: (value) {
                if (value != null) {
                  notifier.setThemeMode(value);
                  Navigator.of(context).pop();
                }
              },
              title: Row(
                children: [
                  Icon(mode.icon, size: 20),
                  const SizedBox(width: 12),
                  Text(mode.name),
                ],
              ),
              subtitle: Text(_getThemeDescription(mode)),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
  
  String _getThemeDescription(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return 'Always use light theme';
      case AppThemeMode.dark:
        return 'Always use dark theme';
      case AppThemeMode.system:
        return 'Follow system setting';
    }
  }
}

/// Enum defining different visual styles for the theme switcher
enum ThemeSwitcherStyle {
  listTile,
  segmentedControl,
  iconButtons,
  dropdown,
}

/// A simple theme toggle button that switches between light and dark
class ThemeToggleButton extends ConsumerWidget {
  const ThemeToggleButton({
    super.key,
    this.tooltip,
  });
  
  final String? tooltip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);
    
    final isDark = currentTheme == AppThemeMode.dark;
    
    return IconButton(
      onPressed: () {
        final newTheme = isDark ? AppThemeMode.light : AppThemeMode.dark;
        themeNotifier.setThemeMode(newTheme);
      },
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return RotationTransition(
            turns: animation,
            child: child,
          );
        },
        child: Icon(
          isDark ? Icons.light_mode : Icons.dark_mode,
          key: ValueKey(isDark),
        ),
      ),
      tooltip: tooltip ?? (isDark ? 'Switch to light theme' : 'Switch to dark theme'),
    );
  }
}

/// Preview widget showing how the theme looks
class ThemePreview extends StatelessWidget {
  const ThemePreview({
    super.key,
    required this.themeData,
    this.title = 'Preview',
  });
  
  final ThemeData themeData;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: themeData,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: themeData.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: themeData.colorScheme.outline,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: AppTypography.titleMedium.copyWith(
                color: themeData.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            
            // Sample buttons
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Primary'),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Outlined'),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Sample text
            Text(
              'Body text sample with proper contrast',
              style: AppTypography.bodyMedium.copyWith(
                color: themeData.colorScheme.onSurface,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Sample colors
            Row(
              children: [
                _ColorChip('Primary', themeData.colorScheme.primary),
                const SizedBox(width: 8),
                _ColorChip('Secondary', themeData.colorScheme.secondary),
                const SizedBox(width: 8),
                _ColorChip('Surface', themeData.colorScheme.surface),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorChip extends StatelessWidget {
  const _ColorChip(this.label, this.color);
  
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
              width: 1,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}