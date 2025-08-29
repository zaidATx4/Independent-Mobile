import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/event_entity.dart';

class SingleEventScreen extends ConsumerWidget {
  final EventEntity event;

  const SingleEventScreen({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Full-screen background image
          _buildBackgroundImage(),
          
          // Top navigation bar with dark overlay
          _buildTopNavigation(context, isLight),
          
          // Bottom content section with blur/glass effect
          _buildBottomContent(isLight),
        ],
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Positioned.fill(
      child: Image.asset(
        event.imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[800],
            child: const Center(
              child: Icon(
                Icons.image_not_supported,
                color: Colors.white54,
                size: 80,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopNavigation(BuildContext context, bool isLight) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 8,
          left: 16,
          right: 16,
          bottom: 16,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.6),
              Colors.black.withValues(alpha: 0.3),
              Colors.transparent,
            ],
          ),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(44),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Text(
                'Events',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                  height: 1.33,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomContent(bool isLight) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Builder(
        builder: (context) => Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0x1A000000), // Dark background layer
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0x40FFFFFF), // Glass fill
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildEventHeader(),
                      const SizedBox(height: 24),
                      _buildEventDetails(),
                      const SizedBox(height: 24),
                      _buildAboutSection(),
                      SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        ),
      ),
    );
  }

  Widget _buildEventHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Organizer logo
        Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              _getOrganizerDisplayText(),
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        
        // Event title and subtitle
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event.title,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Savor bold flavors. Unlock exclusive deals.',
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Colors.white,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEventDetails() {
    final startDate = DateFormat('MMM dd').format(event.dateTime);
    final endDate = DateFormat('MMM dd').format(event.dateTime.add(const Duration(days: 30))); // Mock end date
    final time = DateFormat('HH:mm').format(event.dateTime);

    return Column(
      children: [
        _buildDetailRowWithSvg(
          svgPath: 'assets/images/icons/SVGs/Location_Icon_dark_2.svg',
          text: event.location,
        ),
        const SizedBox(height: 16),
        _buildDetailRowWithSvg(
          svgPath: 'assets/images/icons/SVGs/Calender_icon.svg',
          text: '$startDate - $endDate',
        ),
        const SizedBox(height: 16),
        _buildDetailRow(
          icon: Icons.access_time,
          text: '$time PM',
        ),
      ],
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: Colors.white,
            height: 1.3,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRowWithSvg({
    required String svgPath,
    required String text,
  }) {
    return Row(
      children: [
        SvgPicture.asset(
          svgPath,
          width: 20,
          height: 20,
          colorFilter: const ColorFilter.mode(
            Colors.white,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: Colors.white,
            height: 1.3,
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.white,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          event.description.isNotEmpty 
              ? event.description 
              : 'Join our mouthwatering celebration of tastes! Enjoy exclusive deals, limited-time dishes, and exciting rewards from your favorite restaurants - all in one flavorful event!',
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Colors.white,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  String _getOrganizerDisplayText() {
    switch (event.organizerName.toLowerCase()) {
      case 'salt':
        return 'SALT';
      case 'parkers':
        return 'PARK';
      case 'night market':
        return 'NM';
      default:
        return event.organizerName.isNotEmpty 
            ? event.organizerName.substring(0, 1).toUpperCase()
            : 'E';
    }
  }
}