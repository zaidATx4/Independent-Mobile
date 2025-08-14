import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Location search bar widget matching Figma design
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
      // Background matching Figma design
      color: const Color(0xFF1A1A1A), // indpt/neutral background
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0), // px-4 py-2.5
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFFFEFEFF).withOpacity(0.64), // Use #FEFEFF with 64% opacity
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
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFFFEFEFF),
                  height: 1.5,
                ),
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF9C9C9D),
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
                        child: const Icon(
                          Icons.close,
                          size: 20.0,
                          color: Color(0xFFFEFEFF), // Use #FEFEFF
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
      colorFilter: const ColorFilter.mode(
        Color(0xFFFEFEFF), // Use #FEFEFF color
        BlendMode.srcIn,
      ),
    );
  }
}