import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool isLandlord;

  const BottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.isLandlord = false,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = isLandlord
        ? [
            {'icon': Icons.home, 'label': 'Dashboard'},
            {'icon': Icons.add, 'label': 'Post Room'},
            {'icon': Icons.list, 'label': 'Listings'},
            {'icon': Icons.message, 'label': 'Messages'},
            {'icon': Icons.person, 'label': 'Profile'},
          ]
        : [
            {'icon': Icons.home, 'label': 'Home'},
            {'icon': Icons.search, 'label': 'Browse'},
            {'icon': Icons.people, 'label': 'Matches'},
            {'icon': Icons.message, 'label': 'Messages'},
            {'icon': Icons.person, 'label': 'Profile'},
          ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!, width: 1)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(tabs.length, (index) {
              final tab = tabs[index];
              final isActive = currentIndex == index;
              return Expanded(
                child: InkWell(
                  onTap: () => onTap(index),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal:
                          4, // Reduced horizontal padding for better fit
                      vertical: 8,
                    ), // Closes EdgeInsets.symmetric
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // Line 57
                      children: [
                        Icon(
                          tab['icon'] as IconData,
                          color: isActive
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                          size: 24,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tab['label'] as String,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 12,
                            color: isActive
                                ? Theme.of(context).primaryColor
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
