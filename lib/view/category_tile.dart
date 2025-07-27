import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  final String category;
  final bool isSelected;
  final Function(String) onTap;
  final double? minWidth;

  const CategoryTile({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
    this.minWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Material(
        color: isSelected ? Colors.white : Colors.orange, // Selected=white, others=orange
        borderRadius: BorderRadius.circular(20.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(20.0),
          onTap: () => onTap(category),
          child: Container(
            constraints: minWidth != null
                ? BoxConstraints(minWidth: minWidth!)
                : const BoxConstraints(minWidth: 80),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Center(
              child: Text(
                category[0].toUpperCase() + category.substring(1),
                style: TextStyle(
                  color: isSelected ? Colors.orange : Colors.white, // Text colors inverted
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ),
    );
  }
}