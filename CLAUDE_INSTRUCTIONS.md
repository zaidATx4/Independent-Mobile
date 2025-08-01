# Restaurant Management Platform - Claude Code Instructions

## Project Overview
- **Type**: Flutter cross-platform mobile app
- **Domain**: Restaurant management, reservations, loyalty, ordering, wallet, gift cards, events
- **Architecture**: Clean Architecture with feature-first organization
- **State Management**: Riverpod 2.0
- **UI**: Pre-designed in Figma (maintain design consistency)
- **Target**: iOS and Android

## Business Rules
- Multi-restaurant support (different brands)
- Real-time order tracking
- Loyalty points calculation: 1 point per $1 spent, 100 points = $5 reward
- Reservation time slots: 15-minute intervals
- Wallet transactions must be atomic
- Gift cards expire after 12 months

## Code Architecture Rules

### Folder Structure

### Feature Structure (MANDATORY)
Each feature MUST have:
- `data/` (repositories, data sources, models)
- `domain/` (entities, use cases)
- `presentation/` (pages, widgets, providers)

### State Management Rules
- Use Riverpod providers for all state
- Async providers for API calls
- StateNotifier for complex state
- Always implement loading and error states
- Use .family and .autoDispose when appropriate

## Development Standards

### Code Quality
- Follow Clean Code principles
- Use meaningful variable names (orderRepository not or)
- Add comprehensive error handling
- Implement proper logging
- Write unit tests for business logic

### API Integration
- All API calls through repository pattern
- Use Dio with interceptors
- Implement retry logic for failed requests
- Handle offline scenarios
- Cache responses when appropriate

### UI Guidelines
- Follow Figma designs exactly
- Use responsive design principles
- Implement proper accessibility
- Handle different screen sizes
- Use platform-adaptive widgets where needed

### Performance Rules
- Lazy load lists and images
- Implement proper pagination
- Use const constructors where possible
- Dispose resources properly
- Optimize widget rebuilds
## Feature-Specific Rules

### Ordering System
- Validate menu item availability before adding to cart
- Calculate taxes and tips properly
- Handle special dietary requirements
- Implement order modification time limits
- Support group ordering scenarios

### Reservation System
- Check table availability in real-time
- Handle time zone conversions
- Implement waiting list functionality
- Send confirmation notifications
- Handle cancellation policies

### Loyalty Program
- Points calculation must be precise
- Handle tier upgrades automatically
- Implement expiration policies
- Support bonus point campaigns
- Track redemption history

### Wallet & Payments
- All transactions must be atomic
- Implement proper security measures
- Handle failed payment scenarios
- Support multiple payment methods
- Maintain transaction history

## Testing Standards

### What to Test
- All business logic (loyalty calculations, reservations)
- API integration layers
- State management flows
- Critical user journeys
- Payment processing

### Testing Structure
- Unit tests for use cases and repositories
- Widget tests for complex UI components
- Integration tests for complete user flows
- Golden tests for consistent UI rendering

## Claude Code Communication Rules

### When Making Changes
1. Always explain what you're implementing and why
2. Show which files will be affected
3. Highlight any breaking changes
4. Mention testing requirements
5. Note any dependencies that need updating

### Error Handling
- When encountering issues, explain the problem clearly
- Suggest multiple solution approaches
- Consider impact on other features
- Ensure backwards compatibility

### Code Review Checklist
Before completing any task, verify:
- [ ] Follows established architecture patterns
- [ ] Implements proper error handling
- [ ] Includes appropriate logging
- [ ] Maintains Figma design consistency
- [ ] Handles edge cases
- [ ] Updates related tests
