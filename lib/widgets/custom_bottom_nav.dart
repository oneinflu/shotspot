import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:animate_do/animate_do.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 30,
      left: 25,
      right: 25,
      child: FadeInUp(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(35),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A).withOpacity(0.9),
                borderRadius: BorderRadius.circular(35),
                border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildDockItem(0, Icons.grid_view_rounded),
                  _buildDockItem(1, Icons.event_available_rounded),
                  _buildDockItem(2, Icons.shopping_cart_rounded),
                  _buildDockItem(3, Icons.receipt_long_rounded),
                  _buildDockItem(4, Icons.person_rounded),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDockItem(int index, IconData icon) {
    bool isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE91E63) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.grey[500],
          size: 28,
        ),
      ),
    );
  }
}
