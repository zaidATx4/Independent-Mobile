import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/location_selection_provider.dart';
import '../widgets/location_selection_header.dart';
import '../widgets/location_search_bar.dart';
import '../widgets/location_filter_chips.dart';
import '../widgets/location_card.dart';
import '../../domain/entities/location_entity.dart';
import '../../../../core/theme/theme_service.dart';

/// Location selection screen matching Figma design with theme support
/// Displays locations for a selected brand with search and filter functionality
class LocationSelectionScreen extends ConsumerStatefulWidget {
  final String brandId;
  final String? brandName;
  final String? brandLogoPath;

  const LocationSelectionScreen({
    super.key,
    required this.brandId,
    this.brandName,
    this.brandLogoPath,
  });

  @override
  ConsumerState<LocationSelectionScreen> createState() =>
      _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends ConsumerState<LocationSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(locationSelectionProvider(widget.brandId));

    return Scaffold(
      backgroundColor: context.getThemedColor(
        lightColor: const Color(0xFFFFFCF5), // Light theme: cream background
        darkColor: const Color(0xFF1A1A1A), // Dark theme: neutral background
      ),
      body: Stack(
        children: [
          // Main content container
          SafeArea(
            child: Column(
              children: [
                // Header with back button and title
                const LocationSelectionHeader(),
              
              // Search bar
              LocationSearchBar(
                onSearchChanged: (query) {
                  ref.read(locationSelectionProvider(widget.brandId).notifier)
                      .searchLocations(query);
                },
                onSearchClear: () {
                  ref.read(locationSelectionProvider(widget.brandId).notifier)
                      .clearSearch();
                },
              ),
              
              const SizedBox(height: 16.0), // Spacing above chips row
              
              // Filter chips
              LocationFilterChips(
                selectedFilter: state.selectedFilter,
                onFilterSelected: (filter) {
                  ref.read(locationSelectionProvider(widget.brandId).notifier)
                      .applyFilter(filter);
                },
              ),
              
              const SizedBox(height: 16.0), // Spacing below chips row
              
              // Locations list
              Expanded(
                child: _buildLocationsList(state),
              ),
            ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build locations list based on current state
  Widget _buildLocationsList(LocationSelectionState state) {
    if (state.isLoading) {
      return _buildLoadingState();
    }

    if (state.error != null) {
      return _buildErrorState(state.error!);
    }

    if (state.filteredLocations.isEmpty) {
      return _buildEmptyState();
    }

    return _buildLocationCards(state.filteredLocations);
  }

  /// Build loading state with shimmer effect
  Widget _buildLoadingState() {
    return Container(
      color: context.getThemedColor(
        lightColor: const Color(0xFFFFFCF5), // Light theme: cream background
        darkColor: const Color(0xFF1A1A1A), // Dark theme: neutral background
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: List.generate(
          5,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Container(
              width: double.infinity,
              height: 80.0, // Height matching location card
              decoration: BoxDecoration(
                color: context.getThemedColor(
                  lightColor: Colors.black.withValues(alpha: 0.05), // Light theme: subtle dark overlay
                  darkColor: Colors.white.withValues(alpha: 0.05), // Dark theme: subtle white overlay
                ),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16.0),
                  // Brand icon placeholder
                  Container(
                    width: 64.0,
                    height: 64.0,
                    decoration: BoxDecoration(
                      color: context.getThemedColor(
                        lightColor: Colors.black.withValues(alpha: 0.1), // Light theme: subtle dark overlay
                        darkColor: Colors.white.withValues(alpha: 0.1), // Dark theme: subtle white overlay
                      ),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  // Content placeholder
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 16.0,
                          decoration: BoxDecoration(
                            color: context.getThemedColor(
                              lightColor: Colors.black.withValues(alpha: 0.1), // Light theme: subtle dark overlay
                              darkColor: Colors.white.withValues(alpha: 0.1), // Dark theme: subtle white overlay
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Container(
                          width: 200.0,
                          height: 12.0,
                          decoration: BoxDecoration(
                            color: context.getThemedColor(
                              lightColor: Colors.black.withValues(alpha: 0.05), // Light theme: subtle dark overlay
                              darkColor: Colors.white.withValues(alpha: 0.05), // Dark theme: subtle white overlay
                            ),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build error state
  Widget _buildErrorState(String error) {
    return Container(
      color: context.getThemedColor(
        lightColor: const Color(0xFFFFFCF5), // Light theme: cream background
        darkColor: const Color(0xFF1A1A1A), // Dark theme: neutral background
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48.0,
                color: context.getThemedColor(
                  lightColor: const Color(0xFF1A1A1A), // Light theme: dark icon
                  darkColor: const Color(0xFFFEFEFF), // Dark theme: light icon
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Something went wrong',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: context.getThemedColor(
                    lightColor: const Color(0xFF1A1A1A), // Light theme: dark text
                    darkColor: const Color(0xFFFEFEFF), // Dark theme: light text
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                error,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14.0,
                  color: context.getThemedColor(
                    lightColor: const Color(0xFF878787), // Light theme: gray text
                    darkColor: const Color(0xFF9C9C9D), // Dark theme: light gray text
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () => ref
                    .read(locationSelectionProvider(widget.brandId).notifier)
                    .refresh(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.getThemedColor(
                    lightColor: const Color(0xFF1A1A1A), // Light theme: dark button
                    darkColor: const Color(0xFFFFFBF1), // Dark theme: sand button
                  ),
                  foregroundColor: context.getThemedColor(
                    lightColor: const Color(0xFFFEFEFF), // Light theme: light text
                    darkColor: const Color(0xFF242424), // Dark theme: dark text
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 12.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                ),
                child: const Text(
                  'Try Again',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build empty state when no locations found
  Widget _buildEmptyState() {
    return Container(
      color: context.getThemedColor(
        lightColor: const Color(0xFFFFFCF5), // Light theme: cream background
        darkColor: const Color(0xFF1A1A1A), // Dark theme: neutral background
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_off_outlined,
                size: 48.0,
                color: context.getThemedColor(
                  lightColor: const Color(0xFF1A1A1A).withValues(alpha: 0.5), // Light theme: semi-dark icon
                  darkColor: const Color(0xFFFEFEFF).withValues(alpha: 0.5), // Dark theme: semi-light icon
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                'No locations found',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: context.getThemedColor(
                    lightColor: const Color(0xFF1A1A1A), // Light theme: dark text
                    darkColor: const Color(0xFFFEFEFF), // Dark theme: light text
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Try adjusting your search or filters',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14.0,
                  color: context.getThemedColor(
                    lightColor: const Color(0xFF878787), // Light theme: gray text
                    darkColor: const Color(0xFF9C9C9D), // Dark theme: light gray text
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build location cards list
  Widget _buildLocationCards(List<LocationEntity> locations) {
    return Container(
      color: context.getThemedColor(
        lightColor: const Color(0xFFFFFCF5), // Light theme: cream background
        darkColor: const Color(0xFF1A1A1A), // Dark theme: neutral background
      ),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: locations.length,
        itemBuilder: (context, index) {
          final location = locations[index];
          return LocationCard(
            location: location,
            brandLogoPath: widget.brandLogoPath ?? _getDefaultBrandLogoPath(),
            onTap: () => _handleLocationTap(location),
            isFirstItem: index == 0, // Add top border for first item
          );
        },
      ),
    );
  }


  /// Handle location tap - select location and navigate to food menu
  void _handleLocationTap(LocationEntity location) {
    
    // Store selected location globally
    ref.read(selectedLocationProvider.notifier).state = location;
    
    // Select location in current provider
    ref.read(locationSelectionProvider(widget.brandId).notifier)
        .selectLocation(location);

    // Navigate to food menu screen
    context.push('/food-menu', extra: {
      'locationId': location.id,
      'brandId': widget.brandId,
      'brandLogoPath': widget.brandLogoPath,
      'selectedLocation': location,
    });
    
  }

  /// Get default brand logo path based on brand name
  String _getDefaultBrandLogoPath() {
    if (widget.brandName?.toLowerCase().contains('salt') ?? false) {
      return 'assets/images/logos/brands/Salt.png';
    }
    return 'assets/images/logos/brands/default.png';
  }
}