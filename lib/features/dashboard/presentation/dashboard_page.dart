import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../inventory/presentation/inventory_provider.dart';
import '../../inventory/presentation/market_provider.dart';
import '../../../shared/glass_container.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../inventory/domain/vinted_article.dart';
import '../../../core/utils/business_service.dart';
import '../../../core/theme/settings_provider.dart';
import '../../../core/utils/discord_service.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  String _statsMode = 'Consolidé';

  @override
  Widget build(BuildContext context) {
    final articlesAsync = ref.watch(inventoryListProvider);
    final marketsAsync = ref.watch(marketNotifierProvider);
    final settingsAsync = ref.watch(appSettingsProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return settingsAsync.when(
      data: (settings) => Scaffold(
        extendBody: true,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                colorScheme.primary.withOpacity(0.1),
                colorScheme.surface,
              ],
            ),
          ),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar.large(
                backgroundColor: Colors.transparent,
                title: Text('Performance ${_statsMode}', style: const TextStyle(fontWeight: FontWeight.w900)),
                actions: [
                  _buildModeSelector(marketsAsync),
                ],
              ),
              SliverToBoxAdapter(
                child: articlesAsync.when(
                  data: (articles) {
                    final filtered = _statsMode == 'Consolidé' 
                        ? articles 
                        : articles.where((a) => a.market == _statsMode).toList();
                    return _buildContent(context, filtered);
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, s) => Center(child: Text('Erreur: $e')),
                ),
              ),
            ],
          ),
        ),
      ),
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, s) => Scaffold(body: Center(child: Text('Erreur: $e'))),
    );
  }

  Widget _buildModeSelector(AsyncValue<List<dynamic>> marketsAsync) {
    return marketsAsync.when(
      data: (markets) => PopupMenuButton<String>(
        icon: const Icon(Icons.analytics_outlined),
        onSelected: (val) => setState(() => _statsMode = val),
        itemBuilder: (context) => [
          const PopupMenuItem(value: 'Consolidé', child: Text('🌍 Tout rassembler')),
          const PopupMenuDivider(),
          ...markets.map((m) => PopupMenuItem(value: m.name, child: Text('📦 ${m.name}'))),
        ],
      ),
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildContent(BuildContext context, List<VintedArticle> articles) {
    final soldArticles = articles.where((a) => a.status == 'Vendu').toList();
    final totalProfit = soldArticles.fold(0.0, (sum, a) => sum + a.netProfit);
    final totalSales = soldArticles.fold(0.0, (sum, a) => sum + a.sellingPrice);
    final totalInvested = articles.fold(0.0, (sum, a) => sum + a.totalPurchaseCost);
    
    // Déclencheur Rapport Journalier (Bouton manuel pour le moment dans l'UI)
    final articlesToday = articles.where((a) => 
      a.createdAt.year == DateTime.now().year && 
      a.createdAt.month == DateTime.now().month && 
      a.createdAt.day == DateTime.now().day).length;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          _buildAiInsights(articles),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () async {
                final best = _calculateBestMarket(articles);
                await ref.read(discordServiceProvider.notifier).sendDailyReport(
                  articlesAdded: articlesToday,
                  totalSales: totalSales,
                  totalProfit: totalProfit,
                  bestMarket: best,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('📊 Rapport envoyé sur Discord !'))
                );
              },
              icon: const Icon(Icons.send_rounded, size: 16),
              label: const Text('Envoyer Rapport Discord', style: TextStyle(fontSize: 10)),
            ),
          ),
          const SizedBox(height: 15),
          _buildMainProfitCard(totalProfit),
          const SizedBox(height: 25),
          _buildProfitChart(soldArticles),
          const SizedBox(height: 25),
          Row(
            children: [
              Expanded(child: _buildSmallCard('Investi', totalInvested, Colors.blue)),
              const SizedBox(width: 15),
              Expanded(child: _buildSmallCard('Ventes', totalSales, Colors.orange)),
            ],
          ),
          const SizedBox(height: 25),
          _buildFiscalAlert(totalSales),
          const SizedBox(height: 150),
        ],
      ),
    );
  }

  Widget _buildAiInsights(List<VintedArticle> articles) {
    String insight = "Analysez vos données pour obtenir des conseils.";
    IconData icon = Icons.lightbulb_outline_rounded;

    if (articles.isNotEmpty) {
      final bestMarket = _calculateBestMarket(articles);
      insight = "Conseil IA : Votre meilleur marché est $bestMarket. Concentrez vos efforts ici !";
      icon = Icons.auto_awesome_rounded;
    }

    return GlassContainer(
      padding: const EdgeInsets.all(16),
      color: Colors.blue.withOpacity(0.05),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 15),
          Expanded(child: Text(insight, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  String _calculateBestMarket(List<VintedArticle> articles) {
    Map<String, double> profits = {};
    for (var a in articles.where((a) => a.status == 'Vendu')) {
      profits[a.market] = (profits[a.market] ?? 0) + a.netProfit;
    }
    if (profits.isEmpty) return "Vinted";
    return profits.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  Widget _buildMainProfitCard(double profit) {
    return GlassContainer(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          const Text('PROFITS NETS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 2, color: Colors.grey)),
          const SizedBox(height: 10),
          Text('${profit.toStringAsFixed(2)}€', 
            style: TextStyle(fontSize: 54, fontWeight: FontWeight.w900, color: profit >= 0 ? Colors.green : Colors.red)
          ).animate().fadeIn().scale(curve: Curves.elasticOut),
        ],
      ),
    );
  }

  Widget _buildProfitChart(List<VintedArticle> sold) {
    sold.sort((a, b) => a.updatedAt.compareTo(b.updatedAt));
    
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Évolution des Profits', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: sold.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.netProfit)).toList(),
                    isCurved: true,
                    color: Colors.green,
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(show: true, color: Colors.green.withOpacity(0.1)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallCard(String title, double value, Color color) {
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
          Text('${value.toInt()}€', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: color)),
        ],
      ),
    );
  }

  Widget _buildFiscalAlert(double totalSales) {
    const double limit = 3000.0;
    final progress = (totalSales / limit).clamp(0.0, 1.0);
    final bool isWarning = totalSales > limit * 0.8;

    return GlassContainer(
      padding: const EdgeInsets.all(20),
      color: isWarning ? Colors.red.withOpacity(0.05) : null,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('SEUIL FISCAL (3000€)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1)),
              Text('${totalSales.toInt()}€', style: TextStyle(fontWeight: FontWeight.bold, color: isWarning ? Colors.red : null)),
            ],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(isWarning ? Colors.red : Colors.blue),
            minHeight: 8,
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      ),
    );
  }
}
