// Updated Pickup Details Screen for Secure Checkout Flow
// 
// Key Changes Made:
// 1. Location Source: Uses food's location from ordering flow instead of separate location list
// 2. Time Picker Only: "Pick Up Later" shows time picker only, no date selection
// 3. Time Field UI: Added pickup time field in "Pick Up Later" radio card
// 4. Auto Time Picker: Time picker automatically shows when "Pick Up Later" is selected
// 5. Business Hours Validation: Validates time against location's operating hours
// 6. Enhanced Security: Maintains PCI DSS compliance and secure state management
// 
// Usage Examples:
// - Pass LocationEntity from food ordering: orderingLocation parameter
// - Pass converted PickupLocationEntity: foodLocation parameter  
// - Auto-conversion between location entity types
// 
// Integration with Food Ordering:
// context.push('/checkout/pickup-details', extra: {
//   'subtotal': 29.99, 'tax': 4.50, 'total': 34.49,
//   'orderingLocation': selectedLocationFromFoodFlow,
// });

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/checkout_entities.dart';
import '../providers/checkout_providers.dart';
import '../widgets/checkout_location_card.dart';
import '../widgets/checkout_radio_option.dart';
import '../widgets/checkout_date_picker.dart';
import '../widgets/checkout_continue_button.dart';
import '../utils/checkout_error_handler.dart';

// Import food ordering entities for conversion
import '../../../../food_ordering/domain/entities/location_entity.dart';

class PickupDetailsScreen extends ConsumerStatefulWidget {
  final String? brandId;
  final String? locationId;
  final double subtotal;
  final double tax;
  final double total;
  final PickupLocationEntity? foodLocation; // Location from food ordering flow
  final LocationEntity? orderingLocation; // Alternative: pass LocationEntity from food ordering
  final String? brandLogoUrl; // Brand logo URL from cart data

  const PickupDetailsScreen({
    super.key,
    this.brandId,
    this.locationId,
    required this.subtotal,
    required this.tax,
    required this.total,
    this.foodLocation, // Added food location parameter
    this.orderingLocation, // Alternative parameter for LocationEntity
    this.brandLogoUrl, // Brand logo URL parameter
  });

  /// Convert LocationEntity from food ordering to PickupLocationEntity
  static PickupLocationEntity convertLocationToPickupLocation(
    LocationEntity location,
    {String? brandLogoPath}
  ) {
    return PickupLocationEntity(
      id: location.id,
      name: location.name,
      address: location.address,
      latitude: location.latitude,
      longitude: location.longitude,
      brandLogoPath: brandLogoPath ?? 'assets/images/logos/default_brand.png', // Default logo
      isActive: location.isOpen && location.acceptsPickup,
      metadata: {
        'phone': location.phoneNumber,
        'operatingHours': location.operatingHours,
        'acceptsDelivery': location.acceptsDelivery,
        'acceptsPickup': location.acceptsPickup,
        'distanceKm': location.distanceKm,
        'estimatedDeliveryMinutes': location.estimatedDeliveryMinutes,
      },
    );
  }

  @override
  ConsumerState<PickupDetailsScreen> createState() => _PickupDetailsScreenState();
}

class _PickupDetailsScreenState extends ConsumerState<PickupDetailsScreen> {
  TimeOfDay? selectedTime; // Changed to TimeOfDay for time-only picker
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    
    // Clear any previous pickup selections when entering the screen
    // This ensures clean state for re-selection after navigation back
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(checkoutProvider.notifier).refreshForReentry();
    });
  }
  
  void _initializeCheckoutIfNeeded() {
    if (_isInitialized) return;
    _isInitialized = true;
    
    
    // Convert ordering location to pickup location if provided
    PickupLocationEntity? convertedFoodLocation = widget.foodLocation;
    if (convertedFoodLocation == null && widget.orderingLocation != null) {
      final brandLogo = widget.brandLogoUrl ?? 'assets/images/logos/brands/Salt.png';
      
      convertedFoodLocation = PickupDetailsScreen.convertLocationToPickupLocation(
        widget.orderingLocation!,
        brandLogoPath: brandLogo,
      );
    }
    
    // TEMP FIX: If no location is provided, create a default location for testing
    if (convertedFoodLocation == null) {
      convertedFoodLocation = const PickupLocationEntity(
        id: 'temp-1',
        name: 'Default Test Location',
        address: 'Test Address, City, Country',
        brandLogoPath: 'assets/images/logos/brands/Salt.png',
        latitude: 25.2048,
        longitude: 55.2708,
        isActive: true,
      );
    }
    
    
    ref.read(checkoutProvider.notifier).initializeCheckout(
      subtotal: widget.subtotal,
      tax: widget.tax,
      total: widget.total,
      brandId: widget.brandId,
      locationId: widget.locationId,
      foodLocation: convertedFoodLocation, // Pass converted food location to provider
    );
    
    // Auto-select "Pick Up Now" only if no pickup time is already selected
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        final currentState = ref.read(checkoutProvider);
        if (currentState.selectedPickupTime == null) {
          ref.read(checkoutProvider.notifier).selectPickupTime(
            PickupTimeEntity.now(),
          );
        } else {
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Initialize checkout after build cycle completes
    if (!_isInitialized) {
      Future(() => _initializeCheckoutIfNeeded());
    }
    
    final checkoutState = ref.watch(checkoutProvider);
    final selectedPickupTime = ref.watch(selectedPickupTimeProvider);
    final canProceed = ref.watch(canProceedToPaymentProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A), // indpt/neutral
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            _buildAppBar(context),
            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      
                      // Pickup Location Section
                      _buildSectionHeader('Pickup Location'),
                      const SizedBox(height: 8),
                      _buildLocationSection(checkoutState),
                      
                      const SizedBox(height: 32),
                      
                      // Pickup Time Section
                      _buildSectionHeader('Pickup Time'),
                      const SizedBox(height: 8),
                      _buildPickupTimeSection(selectedPickupTime),
                      
                      const SizedBox(height: 100), // Space for bottom button
                    ],
                  ),
                ),
              ),
            ),
            // Bottom Section with Continue Button
            _buildBottomSection(canProceed),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Back Button
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
                  color: Color(0xFFFEFEFF),
                  size: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Title
          const Expanded(
            child: Text(
              'Pickup Details',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFFFEFEFF), // indpt/text primary with opacity 0.8
                height: 32 / 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Color(0xFFFEFEFF), // indpt/text primary
        height: 21 / 14,
      ),
    );
  }

  Widget _buildLocationSection(CheckoutState state) {
    // Get location from multiple sources in priority order:
    // 1. Pre-selected location from state (set during initialization)
    // 2. Food location from parameter
    // 3. Converted ordering location
    // 4. First available location
    PickupLocationEntity? location = state.selectedLocation ?? widget.foodLocation;
    
    if (location == null && widget.orderingLocation != null) {
      location = PickupDetailsScreen.convertLocationToPickupLocation(
        widget.orderingLocation!,
        brandLogoPath: widget.brandLogoUrl ?? 'assets/images/logos/brands/Salt.png',
      );
    }
    
    location ??= (state.availableLocations.isNotEmpty ? state.availableLocations.first : null);

    if (location == null) {
      if (state.isLoading) {
        return const CheckoutLocationCardSkeleton();
      }
      return _buildErrorState('No pickup location available');
    }

    return CheckoutLocationCard(
      location: location,
      isSelected: true,
      onTap: () {
        // Location is pre-selected from food ordering, no need to change
      },
    );
  }

  Widget _buildPickupTimeSection(PickupTimeEntity? selectedPickupTime) {
    return Column(
      children: [
        // Pick Up Now Option
        CheckoutRadioOption(
          isSelected: selectedPickupTime?.type == PickupTimeType.now,
          title: 'Pick Up Now',
          description: 'Get your order as soon as possible',
          onTap: () {
            ref.read(checkoutProvider.notifier).selectPickupTime(
              PickupTimeEntity.now(),
            );
          },
        ),
        const SizedBox(height: 16),
        // Pick Up Later Option
        CheckoutRadioOption(
          isSelected: selectedPickupTime?.type == PickupTimeType.later,
          title: 'Pick Up Later',
          description: 'Choose a time that suits you.',
          onTap: () {
            // First select the "later" option, then show time picker
            if (selectedPickupTime?.type != PickupTimeType.later) {
              // Create a temporary "later" pickup time entity without scheduled time
              // This will be updated when user picks a time
              final tempLaterEntity = PickupTimeEntity.later(DateTime.now().add(const Duration(hours: 1)));
              ref.read(checkoutProvider.notifier).selectPickupTime(tempLaterEntity);
              
              // Then show time picker for user to select actual time
              Future.delayed(const Duration(milliseconds: 100), () {
                _showTimePicker();
              });
            }
          },
          additionalContent: selectedPickupTime?.type == PickupTimeType.later
              ? CheckoutTimePicker(
                  placeholder: 'Select pickup time',
                  selectedTime: selectedTime,
                  onTap: _showTimePicker,
                )
              : null,
        ),
      ],
    );
  }

  Widget _buildBottomSection(bool canProceed) {
    final checkoutState = ref.watch(checkoutProvider);
    final isLoading = ref.watch(isCheckoutLoadingProvider);
    
    // Debug: Print state for troubleshooting
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A), // indpt/neutral
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CheckoutContinueButton(
            price: widget.total.toStringAsFixed(0),
            currency: 'SAR',
            buttonText: 'Continue to Payment',
            enabled: canProceed && !isLoading,
            isLoading: isLoading,
            onPressed: (canProceed && !isLoading) ? _onContinuePressed : null,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF4D4E52)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: Color(0xFF9C9C9D),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF9C9C9D),
                height: 21 / 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showTimePicker() async {
    final now = DateTime.now();
    final minimumTime = now.add(const Duration(minutes: 30));
    final currentTime = TimeOfDay.fromDateTime(minimumTime);

    // Show time picker
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? currentTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFFFFBF1), // indpt/sand
              onPrimary: Color(0xFF242424), // indpt/accent
              surface: Color(0xFF1A1A1A), // indpt/neutral
              onSurface: Color(0xFFFEFEFF), // indpt/text primary
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime == null) return;

    // Create datetime for today with selected time
    final selectedDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    // Validate minimum time (must be at least 30 minutes from now)
    if (selectedDateTime.isBefore(minimumTime)) {
      if (mounted) {
        CheckoutErrorHandler.showErrorSnackBar(
          context, 
          'Pickup time must be at least 30 minutes from now'
        );
      }
      return;
    }

    // Validate business hours based on location's operating hours
    if (!_isTimeWithinBusinessHours(pickedTime)) {
      if (mounted) {
        CheckoutErrorHandler.showErrorSnackBar(
          context, 
          'Pickup time must be within business hours (9:00 AM - 10:00 PM)'
        );
      }
      return;
    }

    setState(() {
      selectedTime = pickedTime;
    });

    // Update the pickup time selection with today's date and selected time
    ref.read(checkoutProvider.notifier).selectPickupTime(
      PickupTimeEntity.later(selectedDateTime),
    );
  }

  /// Validate if the selected time is within business hours
  bool _isTimeWithinBusinessHours(TimeOfDay time) {
    // Get current location's operating hours
    final checkoutState = ref.read(checkoutProvider);
    final location = checkoutState.selectedLocation ?? widget.foodLocation;
    
    if (location == null) {
      // Default business hours if no location data
      return time.hour >= 9 && time.hour < 22;
    }
    
    // If location has metadata with operating hours from food ordering
    final operatingHours = location.metadata?['operatingHours'] as Map<String, String>?;
    if (operatingHours != null) {
      final today = DateTime.now();
      final dayName = _getDayName(today.weekday);
      final todayHours = operatingHours[dayName];
      
      if (todayHours != null) {
        return _isTimeWithinRange(time, todayHours);
      }
    }
    
    // Default business hours (9 AM to 10 PM) if no operating hours data
    return time.hour >= 9 && time.hour < 22;
  }
  
  /// Get day name from weekday number
  String _getDayName(int weekday) {
    const days = {
      1: 'monday',
      2: 'tuesday', 
      3: 'wednesday',
      4: 'thursday',
      5: 'friday',
      6: 'saturday',
      7: 'sunday',
    };
    return days[weekday] ?? 'monday';
  }
  
  /// Check if time is within operating hours range (e.g., "09:00-22:00")
  bool _isTimeWithinRange(TimeOfDay time, String hoursRange) {
    try {
      final parts = hoursRange.split('-');
      if (parts.length != 2) return false;
      
      final startParts = parts[0].split(':');
      final endParts = parts[1].split(':');
      
      final startHour = int.parse(startParts[0]);
      final startMinute = int.parse(startParts[1]);
      final endHour = int.parse(endParts[0]);
      final endMinute = int.parse(endParts[1]);
      
      final timeMinutes = time.hour * 60 + time.minute;
      final startMinutes = startHour * 60 + startMinute;
      final endMinutes = endHour * 60 + endMinute;
      
      return timeMinutes >= startMinutes && timeMinutes < endMinutes;
    } catch (e) {
      // If parsing fails, use default hours
      return time.hour >= 9 && time.hour < 22;
    }
  }

  void _onContinuePressed() async {
    final checkoutNotifier = ref.read(checkoutProvider.notifier);
    
    try {
      await checkoutNotifier.confirmPickupDetails();
      
      // Navigate to payment method selection screen
      if (mounted) {
        context.push('/checkout/payment-method', extra: {
          'total': widget.total,
          'currency': 'SAR',
        });
      }
    } catch (e) {
      if (mounted) {
        final errorMessage = CheckoutErrorHandler.getErrorMessage(e);
        CheckoutErrorHandler.showErrorSnackBar(context, errorMessage);
      }
    }
  }

}

// Mock pickup locations for development
final mockPickupLocations = [
  const PickupLocationEntity(
    id: '1',
    name: 'Mall of the Emirates',
    address: 'North Beach, Jumeirah 1, Dubai, UAE',
    brandLogoPath: 'assets/images/logos/brands/Salt.png',
    latitude: 25.2048,
    longitude: 55.2708,
    isActive: true,
  ),
];