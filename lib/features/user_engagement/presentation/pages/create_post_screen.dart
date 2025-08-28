import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../providers/feed_providers.dart';

/// Create post screen.
///
/// - Uses a scrollable container to avoid RenderFlex overflow when the
///   keyboard appears.
/// - Adjusts bottom padding with `MediaQuery.viewInsets.bottom` (keyboard)
///   and `MediaQuery.padding.bottom` (safe area / home indicator).
class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFocusNode = FocusNode();
  bool _isLoading = false;

  @override
  void dispose() {
    _textController.dispose();
    _textFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Scaffold(
      backgroundColor: isLight
          ? Colors.white
          : const Color(0xFF1A1A1A),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context, isLight),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: IntrinsicHeight(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildTextInput(context, isLight),
                              const SizedBox(height: 20),
                              _buildUploadButton(context, isLight),
                              const Spacer(),
                              Padding(
                                padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom >
                                          0
                                      ? 8
                                      : MediaQuery.of(context).padding.bottom +
                                            8,
                                ),
                                child: _buildActionButtons(context, isLight),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, bool isLight) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isLight
                      ? const Color(0xFF242424)
                      : const Color(0xFFFEFEFF),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(44),
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 16,
                color: isLight
                    ? const Color(0xFF242424)
                    : const Color(0xFFFEFEFF),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Create post',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w700,
                fontSize: 24,
                height: 1.33,
                color: isLight
                    ? const Color(0xFF242424)
                    : const Color(0xFFFEFEFF),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextInput(BuildContext context, bool isLight) {
    return SizedBox(
      height: 240,
      child: TextFormField(
        controller: _textController,
        focusNode: _textFocusNode,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        style: TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
          fontSize: 16,
          height: 1.5,
          color: isLight ? const Color(0xFF242424) : const Color(0xFFFEFEFF),
        ),
        decoration: InputDecoration(
          hintText: 'What is on your mind',
          hintStyle: const TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            fontSize: 16,
            height: 1.5,
            color: Color(0xFF9C9C9D),
          ),
          filled: false,
          fillColor: Colors.transparent,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: isLight
                  ? const Color(0xFF242424).withValues(alpha: 0.3)
                  : const Color(0xFFFEFEFF).withValues(alpha: 0.64),
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: isLight
                  ? const Color(0xFF242424).withValues(alpha: 0.3)
                  : const Color(0xFFFEFEFF).withValues(alpha: 0.64),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: isLight
                  ? const Color(0xFF242424)
                  : const Color(0xFFFEFEFF).withValues(alpha: 0.9),
              width: 1,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildUploadButton(BuildContext context, bool isLight) {
    // Transparent, pill-shaped upload button with centered label+icon.
    const double buttonHeight = 56.0;
    final borderColor = isLight
        ? const Color(0xFF242424).withValues(alpha: 0.4)
        : const Color(0xFFFEFEFF).withValues(alpha: 0.6);

    return Container(
      width: double.infinity,
      height: buttonHeight,
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(buttonHeight / 2), // pill shape
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Upload photo/video',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
                fontSize: 16,
                height: 1.0,
                color: isLight
                    ? const Color(0xFF242424)
                    : const Color(0xFFFEFEFF),
              ),
            ),
            const SizedBox(width: 10),
            // Icon after the label, centered vertically
            SvgPicture.asset(
              'assets/images/icons/SVGs/Photo_Icon.svg',
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(
                isLight
                    ? const Color(0xFF242424)
                    : const Color(0xFFFFFBF1),
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isLight) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              elevation: 0,
              side: BorderSide(
                color: isLight
                    ? const Color(0xFF242424)
                    : const Color(0xFFFEFEFF),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: isLight
                    ? const Color(0xFF242424)
                    : const Color(0xFFFEFEFF),
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isLight
                  ? const Color(0xFF242424)
                  : const Color(0xFFFFFBF1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: _isLoading ? null : _handlePostSubmit,
            child: _isLoading
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    'Post',
                    style: TextStyle(
                      color: isLight
                          ? Colors.white
                          : const Color(0xFF242424),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Future<void> _handlePostSubmit() async {
    if (_textController.text.trim().isEmpty) {
      _showSnackBar('Please enter some content for your post');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final content = _textController.text.trim();
      final hashtags = _extractHashtags(content);

      final repository = ref.read(postRepositoryProvider);
      final newPost = await repository.createPost(
        content: content,
        hashtags: hashtags.isNotEmpty ? hashtags : null,
      );

      if (!mounted) return;

      setState(() => _isLoading = false);

      if (newPost != null) {
        _showSnackBar('Post created successfully!');
        ref.invalidate(feedPostsProvider);
        Navigator.of(context).pop();
      } else {
        _showSnackBar('Failed to create post. Please try again.');
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
      _showSnackBar('Failed to create post. Please try again.');
    }
  }

  List<String> _extractHashtags(String text) {
    final RegExp hashtagRegex = RegExp(r'#\w+');
    final matches = hashtagRegex.allMatches(text);
    return matches.map((m) => m.group(0)!.substring(1)).toList();
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF242424),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
