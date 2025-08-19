import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/theme_service.dart';

/// Location search bar widget matching Figma design with theme support
/// Search input with search icon and placeholder text
class LocationSearchBar extends StatefulWidget {
  final String hintText;
  final Function(String) onSearchChanged;
  final VoidCallback? onSearchClear;

  const LocationSearchBar({
    super.key,
    this.hintText = 'Search box',
    required this.onSearchChanged,
    this.onSearchClear,
  });

  @override
  State<LocationSearchBar> createState() => _LocationSearchBarState();
}

class _LocationSearchBarState extends State<LocationSearchBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Theme-aware background matching Figma design
      color: context.getThemedColor(
        lightColor: const Color(0xFFFFFCF5), // Light theme: cream background
        darkColor: const Color(0xFF1A1A1A), // Dark theme: neutral background
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0), // px-4 py-2.5
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: context.getThemedColor(
              lightColor: const Color(0xFF1A1A1A).withValues(alpha: 0.64), // Light theme: dark border with opacity
              darkColor: const Color(0xFFFEFEFF).withValues(alpha: 0.64), // Dark theme: light border with opacity
            ),
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(34.0),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                onChanged: (value) {
                  widget.onSearchChanged(value);
                },
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                  color: context.getThemedColor(
                    lightColor: const Color(0xFF1A1A1A), // Light theme: dark text
                    darkColor: const Color(0xFFFEFEFF), // Dark theme: light text
                  ),
                  height: 1.5,
                ),
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                    color: context.getThemedColor(
                      lightColor: const Color(0xFF878787), // Light theme: gray hint text
                      darkColor: const Color(0xFF9C9C9D), // Dark theme: light gray hint text
                    ),
                    height: 1.5,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  fillColor: Colors.transparent,
                  filled: false,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            // Search icon positioned on the right side
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: SizedBox(
                width: 24,
                height: 24,
                child: _controller.text.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          _controller.clear();
                          widget.onSearchChanged('');
                          widget.onSearchClear?.call();
                        },
                        child: Icon(
                          Icons.close,
                          size: 20.0,
                          color: context.getThemedColor(
                            lightColor: const Color(0xFF1A1A1A), // Light theme: dark icon
                            darkColor: const Color(0xFFFEFEFF), // Dark theme: light icon
                          ),
                        ),
                      )
                    : _buildSearchIconSvg(),
              ),
            ),
          ],
        ),
      ),
    );
  }


  /// Build search icon SVG matching Figma design
  Widget _buildSearchIconSvg() {
    return SvgPicture.asset(
      'assets/images/icons/SVGs/Loyalty/Search_icon.svg',
      width: 24.0,
      height: 24.0,
      colorFilter: ColorFilter.mode(
        context.getThemedColor(
          lightColor: const Color(0xFF1A1A1A), // Light theme: dark icon
          darkColor: const Color(0xFFFEFEFF), // Dark theme: light icon
        ),
        BlendMode.srcIn,
      ),
    );
  }
}