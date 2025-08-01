# Assets Structure

This folder contains all static assets for the Independent Mobile restaurant management app.

## Folder Structure

### 📁 images/
- **icons/** - App icons, navigation icons, feature icons
- **backgrounds/** - Background images, patterns, textures
- **logos/** - Brand logos, partner logos, restaurant logos
- **illustrations/** - Custom illustrations, graphics, artwork

### 📁 videos/
- **splash_video.mp4** - Splash screen background video
- **onboarding/** - Onboarding tutorial videos
- **promotional/** - Marketing and promotional videos

### 📁 fonts/
- Custom font files (.ttf, .otf)
- Restaurant brand fonts
- System fallback fonts

### 📁 animations/
- **lottie/** - Lottie animation files (.json)
- **rive/** - Rive animation files (.riv)
- **gif/** - GIF animations for loading states

### 📁 sounds/
- **notifications/** - Notification sounds
- **ui/** - UI interaction sounds
- **background/** - Background ambient sounds

## File Naming Conventions

### Images
- Use snake_case: `restaurant_logo.png`
- Include size suffixes: `icon_home_24.png`, `icon_home_32.png`
- Use descriptive names: `background_login_screen.jpg`

### Videos
- Include purpose: `splash_video.mp4`, `onboarding_intro.mp4`
- Keep file sizes optimized for mobile

### Fonts
- Family name + weight: `OpenSans-Regular.ttf`, `OpenSans-Bold.ttf`

## Image Guidelines

### Formats
- **PNG** - Icons, logos, images with transparency
- **JPG** - Photos, backgrounds without transparency
- **SVG** - Vector graphics, scalable icons
- **WebP** - Optimized images for better performance

### Sizes
- **Icons**: 24x24, 32x32, 48x48, 72x72dp
- **Logos**: Multiple sizes for different use cases
- **Backgrounds**: Optimize for common screen sizes

### Density Support
For Android, consider providing multiple densities:
- mdpi (1x)
- hdpi (1.5x)  
- xhdpi (2x)
- xxhdpi (3x)
- xxxhdpi (4x)

## Usage in Code

```dart
// Images
Image.asset('assets/images/logos/app_logo.png')

// Icons
Image.asset('assets/images/icons/icon_home_24.png')

// Videos
VideoPlayerController.asset('assets/videos/splash_video.mp4')

// Fonts (in pubspec.yaml)
fonts:
  - family: CustomFont
    fonts:
      - asset: assets/fonts/CustomFont-Regular.ttf
```

## Optimization Tips

1. **Compress images** before adding to assets
2. **Use appropriate formats** for different content types
3. **Remove unused assets** regularly
4. **Consider lazy loading** for large assets
5. **Use vector graphics** when possible for scalability