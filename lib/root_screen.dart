import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'features/inventory/presentation/inventory_page.dart';
import 'features/sync/presentation/sync_page.dart';
import 'features/dashboard/presentation/dashboard_page.dart';
import 'features/dashboard/presentation/sales_calendar_screen.dart';
import 'features/dashboard/presentation/settings_page.dart';
import 'features/inventory/presentation/express_inventory_screen.dart';
import 'core/theme/settings_provider.dart';

final navigationIndexProvider = StateProvider<int>((ref) => 0);

class RootScreen extends ConsumerWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(navigationIndexProvider);
    final settingsAsync = ref.watch(appSettingsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return settingsAsync.when(
      data: (settings) {
        final themeType = settings['theme'] as GlassTheme;

        final List<Widget> screens = [
          const InventoryPage(),
          const DashboardPage(),
          const SalesCalendarScreen(),
          const ExpressInventoryScreen(),
          const SyncPage(),
          const SettingsPage(),
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
            child: Row(
              children: [
                if (isDesktop) _buildSidebar(context, ref, selectedIndex, isDark),
                Expanded(
                  child: ClipRect(child: screens[selectedIndex]),
                ),
              ],
            ),
          ),
          bottomNavigationBar: isDesktop ? null : _LiquidBottomBar(),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, s) => Scaffold(body: Center(child: Text('Erreur: $e'))),
    );
  }

  Widget _buildSidebar(BuildContext context, WidgetRef ref, int selectedIndex, bool isDark) {
    return Container(
      width: 250,
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 30)],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            color: (isDark ? Colors.white : Colors.black).withOpacity(isDark ? 0.05 : 0.03),
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
            child: Column(
              children: [
                const Text('EMPIRE PRO', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24, letterSpacing: 2)),
                const SizedBox(height: 50),
                _SidebarItem(0, Icons.inventory_2_rounded, 'Inventaire', selectedIndex, ref),
                _SidebarItem(1, Icons.auto_graph_rounded, 'Statistiques', selectedIndex, ref),
                _SidebarItem(2, Icons.calendar_month_rounded, 'Calendrier', selectedIndex, ref),
                _SidebarItem(3, Icons.qr_code_scanner_rounded, 'Inv. Express', selectedIndex, ref),
                _SidebarItem(4, Icons.bolt_rounded, 'Synchronisation', selectedIndex, ref),
                const Spacer(),
                _SidebarItem(5, Icons.settings_rounded, 'Paramètres', selectedIndex, ref),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final int index;
  final IconData icon;
  final String label;
  final int current;
  final WidgetRef ref;

  const _SidebarItem(this.index, this.icon, this.label, this.current, this.ref);

  @override
  Widget build(BuildContext context) {
    final isActive = index == current;
    final color = isActive ? Theme.of(context).colorScheme.primary : Colors.grey;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () => ref.read(navigationIndexProvider.notifier).state = index,
        borderRadius: BorderRadius.circular(15),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            color: isActive ? color.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 15),
              Text(label, style: TextStyle(color: color, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
            ],
          ),
        ),
      ),
    );
  }
}

class _LiquidBottomBar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(navigationIndexProvider);
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
              padding: const EdgeInsets.symmetric(horizontal: 4),
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
                  _NavIcon(3, Icons.qr_code_scanner_rounded, 'Scan', selectedIndex, ref),
                  _NavIcon(4, Icons.bolt_rounded, 'P2P', selectedIndex, ref),
                  _NavIcon(5, Icons.settings_rounded, 'Param', selectedIndex, ref),
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
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? color.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 22),
            if (isActive)
              Text(label, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold))
                .animate().fadeIn().moveY(begin: 3, end: 0),
          ],
        ),
      ),
    );
  }
}
