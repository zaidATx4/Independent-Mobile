# Shared Features

This directory contains reusable functionalities that can be used across multiple modules/features in the application.

## Structure

### Cart Module (`/cart/`)
Contains all cart-related functionality that can be used by any feature (loyalty, ordering, etc.):
- **Data Layer**: Models, repositories for cart operations
- **Domain Layer**: Entities, use cases for cart business logic  
- **Presentation Layer**: Cart screens, widgets, providers

### Food Module (`/food/`)
Contains all food search and management functionality:
- **Data Layer**: Models, repositories for food data
- **Domain Layer**: Entities, use cases for food operations
- **Presentation Layer**: Food search screens, filter widgets, item cards

## Usage

Import shared functionalities using:
```dart
// Cart functionality
import 'package:independent/features/shared/cart/presentation/pages/cart_screen.dart';
import 'package:independent/features/shared/cart/presentation/widgets/cart_badge_widget.dart';

// Food functionality  
import 'package:independent/features/shared/food/presentation/pages/food_search_screen.dart';
import 'package:independent/features/shared/food/presentation/widgets/food_search_bar.dart';
```

## Benefits

1. **Reusability**: Same functionality can be used across multiple features
2. **Maintainability**: Single source of truth for common functionalities
3. **Consistency**: Uniform behavior across the application
4. **Modularity**: Easy to test and modify independently

## Clean Architecture

Each shared module follows Clean Architecture principles:
- **Data**: External concerns (APIs, databases)
- **Domain**: Business logic and entities
- **Presentation**: UI components and state management