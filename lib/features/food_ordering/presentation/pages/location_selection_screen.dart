import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/location_selection_provider.dart';
import '../widgets/location_selection_header.dart';
import '../widgets/location_search_bar.dart';
import '../widgets/location_filter_chips.dart';
import '../widgets/location_card.dart';
import '../../domain/entities/location_entity.dart';

/// Location selection screen matching Figma design with dark theme
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
      backgroundColor: const Color(0xFF1A1A1A), // indpt/neutral background
      body: Stack(
        children: [
          // Main content container
          Column(
            children: [
              // Status bar spacer
              Container(
                height: MediaQuery.of(context).padding.top,
                color: const Color(0xFF1A1A1A),
              ),
              
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
          
          // Bottom navigation indicator (home indicator)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomIndicator(),
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
      color: const Color(0xFF1A1A1A),
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
                color: Colors.white.withOpacity(0.05),
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
                      color: Colors.white.withOpacity(0.1),
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
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Container(
                          width: 200.0,
                          height: 12.0,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
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
      color: const Color(0xFF1A1A1A),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48.0,
                color: Color(0xFFFEFEFF),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Something went wrong',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFEFEFF),
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                error,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14.0,
                  color: Color(0xFF9C9C9D),
                ),
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () => ref
                    .read(locationSelectionProvider(widget.brandId).notifier)
                    .refresh(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFFBF1),
                  foregroundColor: const Color(0xFF242424),
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
      color: const Color(0xFF1A1A1A),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_off_outlined,
                size: 48.0,
                color: const Color(0xFFFEFEFF).withOpacity(0.5),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'No locations found',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFEFEFF),
                ),
              ),
              const SizedBox(height: 8.0),
              const Text(
                'Try adjusting your search or filters',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14.0,
                  color: Color(0xFF9C9C9D),
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
      color: const Color(0xFF1A1A1A),
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

  /// Build bottom indicator matching Figma design
  Widget _buildBottomIndicator() {
    return Container(
      width: double.infinity,
      color: const Color(0xFF242424), // indpt/accent background
      padding: const EdgeInsets.symmetric(horizontal: 120.0, vertical: 8.0), // px-[120px] py-2
      child: Center(
        child: Container(
          width: 134.0, // Fixed width from Figma
          height: 5.0, // Fixed height from Figma
          decoration: BoxDecoration(
            color: const Color(0xFF9C9C9D), // indpt/text tertiary
            borderRadius: BorderRadius.circular(100.0), // rounded-[100px] - fully rounded
          ),
        ),
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