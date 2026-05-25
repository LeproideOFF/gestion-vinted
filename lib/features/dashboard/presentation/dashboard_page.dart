import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../inventory/presentation/inventory_provider.dart';
import '../../../shared/glass_container.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../inventory/domain/vinted_article.dart';
import '../../../core/utils/business_service.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articlesAsync = ref.watch(inventoryListProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              colorScheme.primary.withOpacity(0.1),
              colorScheme.surface,
              colorScheme.secondary.withOpacity(0.05),
            ],
          ),
        ),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar.large(
              backgroundColor: Colors.transparent,
              title: const Text('Statistiques', style: TextStyle(fontWeight: FontWeight.w900)),
              actions: [
                IconButton(
                  icon: const Icon(Icons.download_rounded),
                  onPressed: () async {
                    final articles = ref.read(inventoryListProvider).value ?? [];
                    await BusinessService.exportInventoryToCSV(articles);
                  },
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: articlesAsync.when(
                data: (articles) => _buildContent(context, articles),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, s) => Center(child: Text('Erreur: $e')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<VintedArticle> articles) {
    final totalSpent = articles.fold(0.0, (sum, a) => sum + a.totalPurchaseCost);
    final soldArticles = articles.where((a) => a.status == 'Vendu').toList();
    final totalSales = soldArticles.fold(0.0, (sum, a) => sum + a.sellingPrice);
    final totalProfit = soldArticles.fold(0.0, (sum, a) => sum + a.netProfit);
    final avgROI = soldArticles.isEmpty ? 0.0 : (soldArticles.fold(0.0, (sum, a) => sum + a.ROI) / soldArticles.length);
    
    // Objectif de vente (Simulé à 1000€ pour démo)
    const double goal = 1000.0;
    final double progress = (totalSales / goal).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          _buildGoalCard(totalSales, goal, progress),
          const SizedBox(height: 25),
          _buildMainProfitCard(totalProfit, avgROI),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildInfoCard('Investi', totalSpent, Icons.account_balance_wallet_rounded, Colors.blue)),
              const SizedBox(width: 15),
              Expanded(child: _buildInfoCard('Ventes', totalSales, Icons.monetization_on_rounded, Colors.orange)),
            ],
          ),
          const SizedBox(height: 30),
          _buildInventoryHealth(articles),
          const SizedBox(height: 150),
        ],
      ),
    );
  }

  Widget _buildGoalCard(double sales, double goal, double progress) {
    return GlassContainer(
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('OBJECTIF MENSUEL', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 1.5, color: Colors.grey)),
              Text('${sales.toInt()}€ / ${goal.toInt()}€', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
            ],
          ),
          const SizedBox(height: 15),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: Colors.blue.withOpacity(0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ).animate().shimmer(delay: 1.seconds),
        ],
      ),
    );
  }

  Widget _buildMainProfitCard(double profit, double roi) {
    return GlassContainer(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          const Text('BÉNÉFICE NET RÉALISÉ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 2, color: Colors.grey)),
          const SizedBox(height: 10),
          Text('${profit.toStringAsFixed(2)}€', 
            style: const TextStyle(fontSize: 54, fontWeight: FontWeight.w900, color: Colors.green)
          ).animate().fadeIn().scale(curve: Curves.elasticOut, duration: 1.seconds),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
            child: Text('ROI Moyen: ${roi.toStringAsFixed(1)}%', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, double value, IconData icon, Color color) {
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
          Text('${value.toInt()}€', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  Widget _buildInventoryHealth(List<VintedArticle> articles) {
    final sold = articles.where((a) => a.status == 'Vendu').length;
    final total = articles.length;
    final ratio = total == 0 ? 0.0 : sold / total;

    return GlassContainer(
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          const Text('Rotation de Stock', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 20),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 80, height: 80,
                child: CircularProgressIndicator(
                  value: ratio,
                  strokeWidth: 10,
                  backgroundColor: Colors.grey.withOpacity(0.1),
                  strokeCap: StrokeCap.round,
                ),
              ),
              Text('${(ratio * 100).toInt()}%', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
            ],
          ),
        ],
      ),
    );
  }
}
