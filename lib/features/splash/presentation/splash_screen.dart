import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _videoController;
  late AnimationController _animationController;
  late Animation<double> _logoAnimation;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    _initializeAnimations();
  }

  void _initializeVideo() {
    _videoController =
        VideoPlayerController.asset('assets/videos/splash_video.mp4')
          ..initialize()
              .then((_) {
                setState(() {
                  _isVideoInitialized = true;
                });
                // Optimize video playback with sound and no buffering
                _videoController.setVolume(1.0); // Enable sound
                _videoController.setLooping(false);
                
                // Wait for video to be fully buffered before playing
                _waitForVideoReady().then((_) {
                  if (mounted && _videoController.value.isInitialized) {
                    _videoController.play();
                  }
                });

                // Navigate to language selection after video completes
                Future.delayed(_videoController.value.duration, () {
                  if (mounted) {
                    context.go('/language');
                  }
                });
              })
              .catchError((error) {
                debugPrint('Error initializing video: $error');
                // Fallback: navigate after 3 seconds if video fails
                Future.delayed(const Duration(seconds: 3), () {
                  if (mounted) {
                    context.go('/language');
                  }
                });
              });
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Start logo animation after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  Future<void> _waitForVideoReady() async {
    // Wait for video to be fully buffered/ready
    while (!_videoController.value.isInitialized || 
           _videoController.value.isBuffering) {
      await Future.delayed(const Duration(milliseconds: 50));
      if (!mounted) break;
    }
    
    // Additional small delay to ensure smooth start
    await Future.delayed(const Duration(milliseconds: 100));
  }

  @override
  void dispose() {
    _videoController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background video that fills entire screen
          if (_isVideoInitialized)
            Positioned.fill(
              child: OverflowBox(
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: VideoPlayer(_videoController),
                  ),
                ),
              ),
            )
          else
            // Black fallback while video loads
            Container(
              color: Colors.black,
              width: double.infinity,
              height: double.infinity,
            ),

          // Dark overlay on top of video
          if (_isVideoInitialized)
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromRGBO(0, 0, 0, 0.4),
                      Color.fromRGBO(0, 0, 0, 0.7),
                    ],
                  ),
                ),
              ),
            ),

          // Logo overlay
          Center(
            child: AnimatedBuilder(
              animation: _logoAnimation,
              builder: (context, child) {
                // Determine logo based on theme brightness
                final isDarkMode =
                    Theme.of(context).brightness == Brightness.dark ||
                    MediaQuery.of(context).platformBrightness ==
                        Brightness.dark;

                final logoPath = isDarkMode
                    ? 'assets/images/logos/Indpt_Logo_White_NoBg.png' // White logo for dark backgrounds
                    : 'assets/images/logos/Indpt_Logo_Dark_NoBg.png'; // Dark logo for light backgrounds

                return Transform.scale(
                  scale: _logoAnimation.value,
                  child: Opacity(
                    opacity: _logoAnimation.value,
                    child: Image.asset(
                      logoPath,
                      width: 120,
                      height: 120,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback to the white logo if the preferred one fails
                        return Image.asset(
                          'assets/images/logos/Indpt_Logo_White_NoBg.png',
                          width: 120,
                          height: 120,
                          errorBuilder: (context, error, stackTrace) {
                            // Final fallback if both logos fail
                            return Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                // ignore: deprecated_member_use
                                color: Colors.white.withValues(alpha: 0.9),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.restaurant,
                                size: 60,
                                color: Colors.black,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),

        ],
      ),
    );
  }
}
