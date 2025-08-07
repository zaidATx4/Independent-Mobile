import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/food_search_provider.dart';
import '../widgets/food_search_bar.dart';
import '../widgets/food_filter_chips.dart';
import '../widgets/food_item_list.dart';

class FoodSearchScreen extends ConsumerStatefulWidget {
  const FoodSearchScreen({super.key});

  @override
  ConsumerState<FoodSearchScreen> createState() => _FoodSearchScreenState();
}

class _FoodSearchScreenState extends ConsumerState<FoodSearchScreen> {
  late final ScrollController _scrollController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    
    // Initialize the search refresh listener
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(searchRefreshProvider);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchResults = ref.watch(foodSearchResultsProvider);
    final categories = ref.watch(foodCategoriesProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A), // indpt/neutral
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button and title
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  // Back button
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFFFEFEFF), // indpt/text primary
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(44),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(44),
                        onTap: () => context.pop(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            size: 16,
                            color: Color(0xFFFEFEFF), // indpt/text primary
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Title
                  const Expanded(
                    child: Text(
                      'Search',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700, // Bold
                        fontSize: 24,
                        height: 32 / 24, // lineHeight / fontSize = Indpt/Title 1
                        color: Color(0xFFFEFEFF), // indpt/text primary
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Search bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: FoodSearchBar(
                controller: _searchController,
                onChanged: (query) {
                  ref.read(searchQueryProvider.notifier).state = query;
                  // Simple debouncing with future delay
                  Future.delayed(const Duration(milliseconds: 300), () {
                    if (ref.read(searchQueryProvider) == query) {
                      ref.read(foodSearchResultsProvider.notifier).updateSearchQuery(query);
                    }
                  });
                },
              ),
            ),

            // Filter chips
            Container(
              height: 42, // Fixed height for the filter chips row
              margin: const EdgeInsets.only(top: 8),
              child: categories.when(
                data: (categoriesList) => FoodFilterChips(
                  categories: categoriesList,
                  onCategoryToggle: (categoryId) {
                    ref.read(foodCategoriesProvider.notifier).selectSingleCategory(categoryId);
                  },
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFFFFBF1), // indpt/sand
                  ),
                ),
                error: (error, stack) => const SizedBox.shrink(),
              ),
            ),

            // Food items list
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: searchResults.when(
                  data: (items) => FoodItemList(
                    items: items,
                    scrollController: _scrollController,
                  ),
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFFFFBF1), // indpt/sand
                    ),
                  ),
                  error: (error, stack) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48,
                          color: const Color(0xFF9C9C9D), // indpt/text tertiary
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Something went wrong',
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w500, // Medium
                            fontSize: 16,
                            height: 24 / 16, // Indpt/Text 1
                            color: Color(0xFFFEFEFF), // indpt/text primary
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Please try again',
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400, // Regular
                            fontSize: 14,
                            height: 21 / 14, // Indpt/btn
                            color: Color(0xFF9C9C9D), // indpt/text tertiary
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            ref.invalidate(foodSearchResultsProvider);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFFBF1), // indpt/sand
                            foregroundColor: const Color(0xFF242424), // indpt/accent
                          ),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}