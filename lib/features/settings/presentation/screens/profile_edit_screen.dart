import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// State providers for profile editing
final profileNameProvider = StateProvider<String>((ref) => 'John Smith');
final profileEmailProvider = StateProvider<String>(
  (ref) => 'independent@example.com',
);
final profilePhoneProvider = StateProvider<String>((ref) => '+971 50 123 4567');

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  bool _showNameEditBanner = false;
  bool _showPhoneEditBanner = false;
  bool _showEmailEditBanner = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    final theme = Theme.of(context);
    final isLightTheme = theme.brightness == Brightness.light;

    // Responsive banner height (minimum 160px, maximum 220px)
    final bannerHeight = (screenHeight * 0.25).clamp(160.0, 220.0);

    return Scaffold(
      backgroundColor: isLightTheme
          ? const Color(0xFFFFFCF5)
          : const Color(0xFF1A1A1A),
      body: Stack(
        children: [
          Column(
            children: [
              // Banner Section with Header and Profile - matching settings screen
              Container(
                height: bannerHeight,
                width: screenWidth,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      isLightTheme
                          ? 'assets/images/illustrations/Settings_Banner_design_light.png'
                          : 'assets/images/illustrations/Settings_Banner_design_Dark.png',
                    ),
                    fit: BoxFit.cover,
                    opacity: 0.2,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Header with title and back button
                        Row(
                          children: [
                            // Back button with circle border
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
                                'Edit Profile',
                                style: TextStyle(
                                  color: isLightTheme
                                      ? const Color(0xCC1A1A1A)
                                      : const Color(0xFFFEFEFF),
                                  fontSize: 24,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold,
                                  height: 32 / 24,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Profile Header - exactly like settings screen
                        Expanded(
                          child: _buildProfileHeader(context, isLightTheme),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Content Section with List Items
              Expanded(
                child: Column(
                  children: [
                    // List Items Section
                    Expanded(
                      child: Container(
                        width: screenWidth,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            const SizedBox(height: 16),

                            // Name Item
                            _buildEditableListItem(
                              label: 'Name',
                              value: ref.watch(profileNameProvider),
                              onTap: () => _showNameEditor(),
                              isLightTheme: isLightTheme,
                              showTopBorder: true,
                              showBottomBorder: true,
                            ),

                            // Phone Number Item
                            _buildEditableListItem(
                              label: 'Phone Number',
                              value: ref.watch(profilePhoneProvider),
                              onTap: () => _showPhoneEditor(),
                              isLightTheme: isLightTheme,
                              showTopBorder: false,
                              showBottomBorder: true,
                            ),

                            // Email Item
                            _buildEditableListItem(
                              label: 'Email',
                              value: ref.watch(profileEmailProvider),
                              onTap: () => _showEmailEditor(),
                              isLightTheme: isLightTheme,
                              showTopBorder: false,
                              showBottomBorder: true,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Save Button Section
                    Container(
                      width: screenWidth,
                      padding: EdgeInsets.fromLTRB(
                        16,
                        16,
                        16,
                        MediaQuery.of(context).padding.bottom,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _handleSave,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isLightTheme
                                ? const Color(0xFF1A1A1A)
                                : const Color(0xFFFFFBF1),
                            foregroundColor: isLightTheme
                                ? const Color(0xFFFEFEFF)
                                : const Color(0xFF242424),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(44),
                            ),
                          ),
                          child: const Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                              height: 24 / 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Edit Banner Overlays
          if (_showNameEditBanner) _buildNameEditBanner(context, isLightTheme),
          if (_showPhoneEditBanner)
            _buildPhoneEditBanner(context, isLightTheme),
          if (_showEmailEditBanner)
            _buildEmailEditBanner(context, isLightTheme),
        ],
      ),
    );
  }

  Widget _buildEditableListItem({
    required String label,
    required String value,
    required VoidCallback onTap,
    required bool isLightTheme,
    required bool showTopBorder,
    required bool showBottomBorder,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            top: showTopBorder
                ? BorderSide(
                    color: isLightTheme
                        ? const Color(0xFFD9D9D9)
                        : const Color(0xFF4D4E52),
                    width: 1,
                  )
                : BorderSide.none,
            bottom: showBottomBorder
                ? BorderSide(
                    color: isLightTheme
                        ? const Color(0xFFD9D9D9)
                        : const Color(0xFF4D4E52),
                    width: 1,
                  )
                : BorderSide.none,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Label
            Text(
              label,
              style: TextStyle(
                color: isLightTheme
                    ? const Color(0xCC1A1A1A)
                    : const Color(0xCCFEFEFF),
                fontSize: 14,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
                height: 21 / 14,
              ),
            ),

            // Value
            SizedBox(
              width: 169,
              child: Text(
                value,
                style: TextStyle(
                  color: isLightTheme
                      ? const Color(0xFF878787)
                      : const Color(0xFF9C9C9D),
                  fontSize: 12,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.normal,
                  height: 18 / 12,
                ),
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, bool isLightTheme) {
    return Row(
      children: [
        // Profile Image - with camera overlay for editing
        Container(
          width: 75,
          height: 75,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            image: const DecorationImage(
              image: AssetImage(
                'assets/images/illustrations/profile_Image.jpg',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: const Color(0x33000000), // Semi-transparent overlay
            ),
            child: const Icon(
              Icons.camera_alt,
              color: Color(0xFFFEFEFF),
              size: 24,
            ),
          ),
        ),
        const SizedBox(width: 24),
        // Profile Info - with tap to edit name
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Name - tappable
              GestureDetector(
                onTap: () => _showNameEditor(),
                child: Consumer(
                  builder: (context, ref, child) {
                    final name = ref.watch(profileNameProvider);
                    return Text(
                      name,
                      style: TextStyle(
                        color: isLightTheme
                            ? const Color(0xFF1A1A1A)
                            : const Color(0xFFFEFEFF),
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        height: 24 / 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    );
                  },
                ),
              ),
              const SizedBox(height: 4),
              // Email - read only
              Consumer(
                builder: (context, ref, child) {
                  final email = ref.watch(profileEmailProvider);
                  return Text(
                    email,
                    style: TextStyle(
                      color: isLightTheme
                          ? const Color(0xFF1A1A1A).withValues(alpha: 0.8)
                          : const Color(0xFFFEFEFF).withValues(alpha: 0.8),
                      fontSize: 12,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.normal,
                      height: 18 / 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  );
                },
              ),
              const SizedBox(height: 2),
              // Phone - read only
              Consumer(
                builder: (context, ref, child) {
                  final phone = ref.watch(profilePhoneProvider);
                  return Text(
                    phone,
                    style: TextStyle(
                      color: isLightTheme
                          ? const Color(0xFF1A1A1A).withValues(alpha: 0.8)
                          : const Color(0xFFFEFEFF).withValues(alpha: 0.8),
                      fontSize: 12,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.normal,
                      height: 18 / 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNameEditBanner(BuildContext context, bool isLightTheme) {
    return GestureDetector(
      onTap: () => _hideNameEditor(),
      child: Container(
        color: const Color.fromRGBO(0, 0, 0, 0.2), // Semi-transparent overlay
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF242424), // Dark background matching Figma
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Home indicator
                  Container(
                    height: 21,
                    width: double.infinity,
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: SizedBox(
                          width: 55,
                          height: 5,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Color(0xFF888888),
                              borderRadius: BorderRadius.all(
                                Radius.circular(100),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Title section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Color(0xFF4D4E52), width: 1),
                        ),
                      ),
                      padding: const EdgeInsets.only(bottom: 8),
                      child: const Text(
                        'Enter your name',
                        style: TextStyle(
                          color: Color(0xFFFEFEFF),
                          fontSize: 16,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          height: 24 / 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  // Text input section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: TextField(
                      controller: _nameController,
                      style: const TextStyle(
                        color: Color(0xFFFEFEFF),
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.normal,
                        height: 24 / 16,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                        filled: false,
                        fillColor: Colors.transparent,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                      ),
                      autofocus: true,
                    ),
                  ),

                  // Buttons section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Color(0xFF4D4E52), width: 1),
                        ),
                      ),
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          // Cancel button
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _hideNameEditor(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFFFEFEFF),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(44),
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Color(0xFFFEFEFF),
                                  fontSize: 16,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w500,
                                  height: 24 / 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 4),

                        // Save button
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _saveNameAndHideEditor(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFFBF1),
                                borderRadius: BorderRadius.circular(44),
                              ),
                              child: const Text(
                                'Save',
                                style: TextStyle(
                                  color: Color(0xFF242424),
                                  fontSize: 16,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w500,
                                  height: 24 / 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showNameEditor() {
    final currentName = ref.read(profileNameProvider);
    _nameController.text = currentName;
    setState(() {
      _showNameEditBanner = true;
    });
  }

  void _hideNameEditor() {
    setState(() {
      _showNameEditBanner = false;
    });
  }

  void _saveNameAndHideEditor() {
    final newName = _nameController.text.trim();
    if (newName.isNotEmpty) {
      ref.read(profileNameProvider.notifier).state = newName;

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Name updated successfully'),
          backgroundColor: Color(0xFF4CAF50),
          duration: Duration(seconds: 2),
        ),
      );
    }

    _hideNameEditor();
  }

  Widget _buildPhoneEditBanner(BuildContext context, bool isLightTheme) {
    return GestureDetector(
      onTap: () => _hidePhoneEditor(),
      child: Container(
        color: const Color.fromRGBO(0, 0, 0, 0.2),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF242424),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Home indicator
                  Container(
                    height: 21,
                    width: double.infinity,
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: SizedBox(
                          width: 55,
                          height: 5,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Color(0xFF888888),
                              borderRadius: BorderRadius.all(
                                Radius.circular(100),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Title section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Color(0xFF4D4E52), width: 1),
                        ),
                      ),
                      padding: const EdgeInsets.only(bottom: 8),
                      child: const Text(
                        'Enter your phone number',
                        style: TextStyle(
                          color: Color(0xFFFEFEFF),
                          fontSize: 16,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          height: 24 / 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  // Text input section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(
                        color: Color(0xFFFEFEFF),
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.normal,
                        height: 24 / 16,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                        filled: false,
                        fillColor: Colors.transparent,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                      ),
                      autofocus: true,
                    ),
                  ),

                  // Buttons section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Color(0xFF4D4E52), width: 1),
                        ),
                      ),
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          // Cancel button
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _hidePhoneEditor(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFFFEFEFF),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(44),
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Color(0xFFFEFEFF),
                                  fontSize: 16,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w500,
                                  height: 24 / 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 4),

                        // Save button
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _savePhoneAndHideEditor(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFFBF1),
                                borderRadius: BorderRadius.circular(44),
                              ),
                              child: const Text(
                                'Save',
                                style: TextStyle(
                                  color: Color(0xFF242424),
                                  fontSize: 16,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w500,
                                  height: 24 / 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailEditBanner(BuildContext context, bool isLightTheme) {
    return GestureDetector(
      onTap: () => _hideEmailEditor(),
      child: Container(
        color: const Color.fromRGBO(0, 0, 0, 0.2),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF242424),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Home indicator
                  Container(
                    height: 21,
                    width: double.infinity,
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: SizedBox(
                          width: 55,
                          height: 5,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Color(0xFF888888),
                              borderRadius: BorderRadius.all(
                                Radius.circular(100),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Title section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Color(0xFF4D4E52), width: 1),
                        ),
                      ),
                      padding: const EdgeInsets.only(bottom: 8),
                      child: const Text(
                        'Enter your email',
                        style: TextStyle(
                          color: Color(0xFFFEFEFF),
                          fontSize: 16,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          height: 24 / 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  // Text input section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(
                        color: Color(0xFFFEFEFF),
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.normal,
                        height: 24 / 16,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                        filled: false,
                        fillColor: Colors.transparent,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                      ),
                      autofocus: true,
                    ),
                  ),

                  // Buttons section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Color(0xFF4D4E52), width: 1),
                        ),
                      ),
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          // Cancel button
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _hideEmailEditor(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFFFEFEFF),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(44),
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Color(0xFFFEFEFF),
                                  fontSize: 16,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w500,
                                  height: 24 / 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 4),

                        // Save button
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _saveEmailAndHideEditor(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFFBF1),
                                borderRadius: BorderRadius.circular(44),
                              ),
                              child: const Text(
                                'Save',
                                style: TextStyle(
                                  color: Color(0xFF242424),
                                  fontSize: 16,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w500,
                                  height: 24 / 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showPhoneEditor() {
    final currentPhone = ref.read(profilePhoneProvider);
    _phoneController.text = currentPhone;
    setState(() {
      _showPhoneEditBanner = true;
    });
  }

  void _hidePhoneEditor() {
    setState(() {
      _showPhoneEditBanner = false;
    });
  }

  void _savePhoneAndHideEditor() {
    final newPhone = _phoneController.text.trim();
    if (newPhone.isNotEmpty) {
      ref.read(profilePhoneProvider.notifier).state = newPhone;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Phone number updated successfully'),
          backgroundColor: Color(0xFF4CAF50),
          duration: Duration(seconds: 2),
        ),
      );
    }

    _hidePhoneEditor();
  }

  void _showEmailEditor() {
    final currentEmail = ref.read(profileEmailProvider);
    _emailController.text = currentEmail;
    setState(() {
      _showEmailEditBanner = true;
    });
  }

  void _hideEmailEditor() {
    setState(() {
      _showEmailEditBanner = false;
    });
  }

  void _saveEmailAndHideEditor() {
    final newEmail = _emailController.text.trim();
    if (newEmail.isNotEmpty) {
      ref.read(profileEmailProvider.notifier).state = newEmail;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email updated successfully'),
          backgroundColor: Color(0xFF4CAF50),
          duration: Duration(seconds: 2),
        ),
      );
    }

    _hideEmailEditor();
  }

  void _handleSave() {
    // Show success message for overall save
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile saved successfully'),
        backgroundColor: Color(0xFF4CAF50),
        duration: Duration(seconds: 2),
      ),
    );

    // Navigate back to settings
    context.pop();
  }
}
