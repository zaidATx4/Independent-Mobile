import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/theme/theme_service.dart';
import '../../domain/entities/food_entities.dart';

class FoodItemCard extends StatelessWidget {
  final FoodItem item;

  const FoodItemCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: context.getThemedColor(
              lightColor: const Color(0xFFD9D9D9), // Light theme: light gray stroke
              darkColor: const Color(0xFF4D4E52), // Dark theme: stroke
            ),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Food image
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: AssetImage(item.imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Food details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Food name
                Text(
                  item.name,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500, // Medium
                    fontSize: 14,
                    height: 21 / 14, // lineHeight / fontSize = Indpt/btn
                    color: context.getThemedColor(
                      lightColor: const Color(0xFF1A1A1A), // Light theme: dark text
                      darkColor: const Color(0xFFFEFEFF), // Dark theme: text primary
                    ),
                  ),
                ),
                
                const SizedBox(height: 4),
                
                // Food description
                Text(
                  item.description,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400, // Regular
                    fontSize: 12,
                    height: 18 / 12, // lineHeight / fontSize = Indpt/Text 3
                    color: context.getThemedColor(
                      lightColor: const Color(0xFF878787), // Light theme: medium gray
                      darkColor: const Color(0xFF9C9C9D), // Dark theme: text tertiary
                    ),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Price and add button
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Price with currency
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.price.toStringAsFixed(1),
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600, // SemiBold
                      fontSize: 20,
                      height: 30 / 20, // lineHeight / fontSize = Indpt/Title 2
                      color: context.getThemedColor(
                        lightColor: const Color(0xFF1A1A1A), // Light theme: dark text
                        darkColor: const Color(0xFFFEFEFF), // Dark theme: text primary
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 4),
                  
                  // SAR currency icon
                  SvgPicture.asset(
                    'assets/images/icons/SVGs/Loyalty/SAR.svg',
                    width: 14,
                    height: 16,
                    colorFilter: ColorFilter.mode(
                      context.getThemedColor(
                        lightColor: const Color(0xFF1A1A1A), // Light theme: dark icon
                        darkColor: const Color(0xFFFEFEFF), // Dark theme: text primary
                      ),
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Add button
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: context.getThemedColor(
                    lightColor: const Color(0xFF1A1A1A), // Light theme: dark background
                    darkColor: const Color(0xFFFFFBF1), // Dark theme: sand
                  ),
                  borderRadius: BorderRadius.circular(44),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(44),
                    onTap: () {
                      // TODO: Implement add to cart functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${item.name} added to cart'),
                          backgroundColor: const Color(0xFFFFFBF1),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        Icons.add,
                        size: 16,
                        color: context.getThemedColor(
                          lightColor: const Color(0xFFFEFEFF), // Light theme: white icon
                          darkColor: const Color(0xFF242424), // Dark theme: accent
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}