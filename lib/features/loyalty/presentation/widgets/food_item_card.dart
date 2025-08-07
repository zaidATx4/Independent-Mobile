import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color(0xFF4D4E52), // indpt/stroke
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
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500, // Medium
                    fontSize: 14,
                    height: 21 / 14, // lineHeight / fontSize = Indpt/btn
                    color: Color(0xFFFEFEFF), // indpt/text primary
                  ),
                ),
                
                const SizedBox(height: 4),
                
                // Food description
                Text(
                  item.description,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400, // Regular
                    fontSize: 12,
                    height: 18 / 12, // lineHeight / fontSize = Indpt/Text 3
                    color: Color(0xFF9C9C9D), // indpt/text tertiary
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
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600, // SemiBold
                      fontSize: 20,
                      height: 30 / 20, // lineHeight / fontSize = Indpt/Title 2
                      color: Color(0xFFFEFEFF), // indpt/text primary
                    ),
                  ),
                  
                  const SizedBox(width: 4),
                  
                  // SAR currency icon
                  SvgPicture.asset(
                    'assets/images/icons/SVGs/Loyalty/SAR.svg',
                    width: 14,
                    height: 16,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFFFEFEFF), // indpt/text primary
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
                  color: const Color(0xFFFFFBF1), // indpt/sand
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
                      child: const Icon(
                        Icons.add,
                        size: 16,
                        color: Color(0xFF242424), // indpt/accent
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