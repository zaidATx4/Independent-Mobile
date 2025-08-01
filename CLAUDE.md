# CLAUDE.md - Restaurant Management Flutter App

## Project Overview
**Name**: Independent Mobile  
**Type**: Flutter cross-platform mobile application  
**Domain**: Restaurant management platform with reservations, loyalty, ordering, wallet, gift cards, and events  
**Current Status**: Early development - basic "Hello Claude" screen implemented  

## Essential Development Commands

### Setup & Dependencies
```bash
flutter pub get                    # Install dependencies
flutter pub upgrade               # Update dependencies
flutter pub outdated             # Check for outdated packages
```

### Development & Testing
```bash
flutter run                      # Run app (debug mode)
flutter run --release           # Run in release mode
flutter test                     # Run unit tests
flutter analyze                  # Static analysis
flutter test --coverage         # Run tests with coverage
```

### Build Commands
```bash
flutter build apk              # Build Android APK
flutter build appbundle        # Build Android App Bundle
flutter build ios              # Build iOS app
flutter build web              # Build web version
flutter clean                  # Clean build cache
```

### Debugging & Performance
```bash
flutter doctor                  # Check Flutter setup
flutter devices               # List available devices
flutter logs                   # View device logs
flutter drive test_driver/app_test.dart  # Integration tests
```

## Architecture Overview

### Clean Architecture Implementation
The project follows Clean Architecture with feature-first organization:

```
lib/
├── features/           # Feature modules
│   ├── ordering/      # Order management
│   ├── reservations/  # Table reservations  
│   ├── loyalty/       # Loyalty program
│   ├── wallet/        # Digital wallet
│   └── auth/          # Authentication
├── shared/            # Shared components
│   ├── data/         # Common data layer
│   ├── domain/       # Common business logic
│   └── presentation/ # Common UI components
└── core/              # App-wide utilities
```

### Feature Structure (Mandatory)
Each feature MUST contain:
- `data/` - Repositories, data sources, models
- `domain/` - Entities, use cases  
- `presentation/` - Pages, widgets, providers

### State Management
- **Primary**: Riverpod 2.0
- **Patterns**: Async providers for API calls, StateNotifier for complex state
- **Requirements**: Always implement loading and error states

## Key Business Rules

### Loyalty System
- **Calculation**: 1 point per $1 spent, 100 points = $5 reward
- **Precision**: Points calculation must be exact
- **Automation**: Handle tier upgrades automatically

### Reservations
- **Time slots**: 15-minute intervals
- **Real-time**: Check table availability in real-time
- **Time zones**: Handle conversions properly

### Financial Operations
- **Atomicity**: All wallet transactions must be atomic
- **Gift cards**: Expire after 12 months
- **Security**: Implement proper security measures for payments

## Current Dependencies

### Core Dependencies
- `flutter`: SDK framework
- `cupertino_icons: ^1.0.8`: iOS-style icons

### Development Dependencies  
- `flutter_test`: Testing framework
- `flutter_lints: ^5.0.0`: Linting rules

### Missing Dependencies (To Be Added)
Based on architecture requirements:
- `riverpod`: State management
- `dio`: HTTP client
- `freezed`: Code generation for models
- `go_router`: Navigation
- `hive` or `sqflite`: Local storage

## Development Standards

### Code Quality Requirements
- Follow Clean Code principles
- Use meaningful variable names (`orderRepository` not `or`)
- Comprehensive error handling with proper logging
- Unit tests for all business logic
- Widget tests for complex UI components

### API Integration Patterns
- Repository pattern for all API calls
- Dio with interceptors for HTTP requests
- Retry logic for failed requests
- Offline scenario handling
- Response caching where appropriate

### UI/UX Guidelines
- **Design System**: Follow Figma designs exactly
- **Responsiveness**: Handle different screen sizes
- **Accessibility**: Implement proper accessibility features
- **Performance**: Use const constructors, lazy loading, proper pagination

## Testing Strategy

### Required Test Coverage
- **Unit Tests**: Business logic (loyalty calculations, reservations)
- **Widget Tests**: Complex UI components  
- **Integration Tests**: Complete user flows
- **Golden Tests**: UI consistency verification

### Critical Testing Areas
- Payment processing flows
- Loyalty point calculations
- Reservation availability checks
- API integration layers
- State management flows

## Development Workflow

### Before Starting Work
1. Review current feature requirements
2. Check Figma designs for UI specifications  
3. Understand data flow and API requirements
4. Plan state management approach

### During Development
1. Follow TDD when possible
2. Implement features incrementally
3. Test on both iOS and Android
4. Verify against business rules
5. Maintain code documentation

### Before Completion Checklist
- [ ] All tests passing
- [ ] Performance verified
- [ ] UI matches Figma designs
- [ ] Error scenarios tested
- [ ] Documentation updated
- [ ] Follows established architecture patterns
- [ ] Proper error handling implemented
- [ ] Appropriate logging included

## Project-Specific Configuration

### Analysis Options
- Uses `package:flutter_lints/flutter.yaml`
- Standard Flutter linting rules applied
- Custom rules can be added in `analysis_options.yaml`

### Multi-Platform Support
- **Primary Targets**: iOS and Android
- **Additional**: Web, macOS, Linux, Windows support configured
- **Platform-specific**: Use adaptive widgets where needed

### Code Review Configuration
The project includes automated code review focusing on:
- Clean Architecture compliance
- Riverpod best practices  
- Business logic correctness
- Security issues (payments/user data)
- Performance implications
- Flutter/Dart best practices

## Important Files & Locations

### Configuration Files
- `C:\Users\Owner\Documents\GitHub\Independent-Mobile\pubspec.yaml` - Dependencies
- `C:\Users\Owner\Documents\GitHub\Independent-Mobile\analysis_options.yaml` - Linting rules
- `C:\Users\Owner\Documents\GitHub\Independent-Mobile\.claude-code-review.yml` - Code review config

### Documentation
- `C:\Users\Owner\Documents\GitHub\Independent-Mobile\CLAUDE_INSTRUCTIONS.md` - Detailed architecture rules
- `C:\Users\Owner\Documents\GitHub\Independent-Mobile\DEVELOPMENT_WORKFLOW.md` - Workflow guidelines
- `C:\Users\Owner\Documents\GitHub\Independent-Mobile\README.md` - Basic project info

### Core Application
- `C:\Users\Owner\Documents\GitHub\Independent-Mobile\lib\main.dart` - App entry point
- `C:\Users\Owner\Documents\GitHub\Independent-Mobile\test\widget_test.dart` - Test template

## Next Steps for Development

1. **State Management Setup**: Add Riverpod dependencies and configure providers
2. **Navigation**: Implement go_router for navigation structure  
3. **Feature Development**: Start with authentication module
4. **API Integration**: Set up Dio and repository patterns
5. **Testing**: Implement comprehensive test suite
6. **UI Implementation**: Begin implementing Figma designs

## Quick Start Commands
```bash
# Clone and setup
git clone <repository-url>
cd Independent-Mobile
flutter pub get

# Run app
flutter run

# Run tests  
flutter test

# Build APK
flutter build apk
```

---
*This document provides essential information for Claude instances working on the Independent Mobile restaurant management Flutter application. Keep this updated as the project evolves.*