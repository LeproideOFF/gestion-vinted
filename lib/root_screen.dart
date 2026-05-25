import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'features/inventory/presentation/inventory_page.dart';
import 'features/sync/presentation/sync_page.dart';
import 'features/dashboard/presentation/dashboard_page.dart';
import 'features/dashboard/presentation/sales_calendar_screen.dart';
import 'features/inventory/presentation/audit_mode_screen.dart';
import 'core/theme/settings_provider.dart';

final navigationIndexProvider = StateProvider<int>((ref) => 0);

class RootScreen extends ConsumerWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(navigationIndexProvider);
    final settings = ref.watch(appSettingsProvider);
    final themeType = settings['theme'] as GlassTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final screens = [
      const InventoryPage(),
      const DashboardPage(),
      const SalesCalendarScreen(),
      const AuditModeScreen(),
      const SyncPage(),
    ];

    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: ThemeColors.getGradient(themeType, isDark),
          ),
        ),
        child: screens[selectedIndex],
      ),
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
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: (isDark ? Colors.white : Colors.black).withOpacity(isDark ? 0.1 : 0.05),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _NavIcon(0, Icons.inventory_2_rounded, 'Stock', selectedIndex, ref),
                  _NavIcon(1, Icons.auto_graph_rounded, 'Stats', selectedIndex, ref),
                  _NavIcon(2, Icons.calendar_month_rounded, 'Agenda', selectedIndex, ref),
                  _NavIcon(3, Icons.qr_code_scanner_rounded, 'Audit', selectedIndex, ref),
                  _NavIcon(4, Icons.bolt_rounded, 'P2P', selectedIndex, ref),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _NavIcon(int index, IconData icon, String label, int current, WidgetRef ref) {
    final isActive = index == current;
    final color = isActive ? Theme.of(ref.context).colorScheme.primary : Colors.grey.withOpacity(0.7);

    return GestureDetector(
      onTap: () => ref.read(navigationIndexProvider.notifier).state = index,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: 300.ms,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? color.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            if (isActive)
              Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold))
                .animate().fadeIn().moveY(begin: 3, end: 0),
          ],
        ),
      ),
    );
  }
}
