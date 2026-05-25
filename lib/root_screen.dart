import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'features/inventory/presentation/inventory_page.dart';
import 'features/sync/presentation/sync_page.dart';
import 'features/dashboard/presentation/dashboard_page.dart';

final navigationIndexProvider = StateProvider<int>((ref) => 0);

class RootScreen extends ConsumerWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(navigationIndexProvider);

    final screens = [
      const InventoryPage(),
      const DashboardPage(),
      const SyncPage(),
    ];

    return Scaffold(
      extendBody: true,
      body: screens[selectedIndex],
      bottomNavigationBar: _LiquidBottomBar(),
    );
  }
}

class _LiquidBottomBar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(navigationIndexProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 30),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 30,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(35),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: (isDark ? Colors.white : Colors.black).withOpacity(isDark ? 0.08 : 0.05),
                borderRadius: BorderRadius.circular(35),
                border: Border.all(
                  color: (isDark ? Colors.white : Colors.white).withOpacity(0.15),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _NavBarIcon(
                    index: 0,
                    icon: Icons.inventory_2_rounded,
                    label: 'Stock',
                    isActive: selectedIndex == 0,
                    onTap: () => ref.read(navigationIndexProvider.notifier).state = 0,
                  ),
                  _NavBarIcon(
                    index: 1,
                    icon: Icons.auto_graph_rounded,
                    label: 'Profit',
                    isActive: selectedIndex == 1,
                    onTap: () => ref.read(navigationIndexProvider.notifier).state = 1,
                  ),
                  _NavBarIcon(
                    index: 2,
                    icon: Icons.bolt_rounded,
                    label: 'Synchro',
                    isActive: selectedIndex == 2,
                    onTap: () => ref.read(navigationIndexProvider.notifier).state = 2,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarIcon extends StatelessWidget {
  final int index;
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavBarIcon({required this.index, required this.icon, required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? colorScheme.primary.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? colorScheme.primary : Colors.grey.withOpacity(0.6),
              size: 26,
            ),
            if (isActive)
              Text(label, style: TextStyle(color: colorScheme.primary, fontSize: 10, fontWeight: FontWeight.bold))
                  .animate().fadeIn().moveY(begin: 5, end: 0),
          ],
        ),
      ),
    );
  }
}
