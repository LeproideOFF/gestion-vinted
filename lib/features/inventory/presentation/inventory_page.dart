import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'inventory_provider.dart';
import 'add_article_page.dart';
import 'article_qr_screen.dart';
import 'market_provider.dart';
import '../../../shared/glass_container.dart';
import '../domain/vinted_article.dart';
import '../domain/market_config.dart';
import '../../../core/utils/business_service.dart';
import '../../../core/theme/settings_provider.dart';

final searchProvider = StateProvider<String>((ref) => '');

class InventoryPage extends ConsumerWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inventoryAsync = ref.watch(inventoryListProvider);
    final searchQuery = ref.watch(searchProvider);
    final currentMarket = ref.watch(selectedMarketProvider);

    return Scaffold(
      extendBody: true,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar.large(
            backgroundColor: Colors.transparent,
            elevation: 0,
            stretch: true,
            title: Text(currentMarket == 'Global' ? 'Tout le Stock' : currentMarket, style: const TextStyle(fontWeight: FontWeight.w900)),
            actions: [
              _MarketPicker(),
              _SearchButton(),
              const SizedBox(width: 16),
            ],
          ),
          SliverToBoxAdapter(
            child: inventoryAsync.when(
              data: (articles) {
                var filtered = articles.where((a) {
                  final query = searchQuery.toLowerCase();
                  final titleMatch = a.title.toLowerCase().contains(query) || a.uuid.toLowerCase().contains(query);
                  final marketMatch = (currentMarket == 'Global') || a.market == currentMarket;
                  return titleMatch && marketMatch;
                }).toList();

                if (filtered.isEmpty) return _buildEmptyState(context, isSearch: searchQuery.isNotEmpty);
                
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 200),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) => _ArticleCard(article: filtered[index], index: index),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Erreur: $err')),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFab(context),
    );
  }

  Widget _buildFab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 90),
      child: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const AddArticlePage()),
        ),
        icon: const Icon(Icons.add_rounded),
        label: const Text('AJOUTER'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, {bool isSearch = false}) {
    return SizedBox(
      height: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isSearch ? Icons.search_off_rounded : Icons.add_shopping_cart, size: 60, color: Colors.grey.withOpacity(0.3)),
            const SizedBox(height: 16),
            const Text('Rien ici pour le moment', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class _MarketPicker extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marketsAsync = ref.watch(marketNotifierProvider);
    final selected = ref.watch(selectedMarketProvider);

    return marketsAsync.when(
      data: (markets) => PopupMenuButton<String>(
        icon: GlassContainer(
          borderRadius: 15,
          padding: const EdgeInsets.all(8),
          child: const Icon(Icons.filter_list_rounded),
        ),
        onSelected: (val) {
          if (val == 'ADD_NEW') {
            _showAddMarketDialog(context, ref);
          } else {
            ref.read(selectedMarketProvider.notifier).state = val;
            ref.read(appSettingsProvider.notifier).setMarket(val);
          }
        },
        itemBuilder: (context) => [
          const PopupMenuItem(value: 'Global', child: Text('🌍 Tout voir')),
          const PopupMenuDivider(),
          ...markets.map((m) => PopupMenuItem(
            value: m.name,
            child: Row(
              children: [
                Container(width: 12, height: 12, decoration: BoxDecoration(color: Color(m.colorValue), shape: BoxShape.circle)),
                const SizedBox(width: 10),
                Text(m.name),
              ],
            ),
          )),
          const PopupMenuDivider(),
          const PopupMenuItem(value: 'ADD_NEW', child: Row(children: [Icon(Icons.add, size: 16), SizedBox(width: 10), Text('Ajouter...')])),
        ],
      ),
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  void _showAddMarketDialog(BuildContext context, WidgetRef ref) {
    final nameCtrl = TextEditingController();
    Color selectedColor = Colors.purple;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nouveau Marché'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nom (ex: eBay, Etsy...)')),
            const SizedBox(height: 20),
            const Text('Couleur du thème'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [Colors.purple, Colors.pink, Colors.amber, Colors.lime, Colors.indigo].map((c) => GestureDetector(
                onTap: () => selectedColor = c,
                child: Container(width: 30, height: 30, color: c),
              )).toList(),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(onPressed: () {
            if (nameCtrl.text.isNotEmpty) {
              ref.read(marketNotifierProvider.notifier).addMarket(nameCtrl.text, selectedColor);
              Navigator.pop(context);
            }
          }, child: const Text('Ajouter')),
        ],
      ),
    );
  }
}

class _SearchButton extends ConsumerStatefulWidget {
  @override
  _SearchButtonState createState() => _SearchButtonState();
}

class _SearchButtonState extends ConsumerState<_SearchButton> {
  bool _isSearching = false;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: 300.ms,
      width: _isSearching ? 150 : 50,
      child: GlassContainer(
        borderRadius: 20,
        child: _isSearching 
          ? TextField(
              controller: _controller,
              onChanged: (val) => ref.read(searchProvider.notifier).state = val,
              decoration: InputDecoration(
                hintText: 'Recherche...',
                border: InputBorder.none,
                prefixIcon: const Icon(Icons.search, size: 18),
                suffixIcon: GestureDetector(onTap: () {
                  setState(() => _isSearching = false);
                  ref.read(searchProvider.notifier).state = '';
                }, child: const Icon(Icons.close, size: 16)),
              ),
            )
          : IconButton(icon: const Icon(Icons.search), onPressed: () => setState(() => _isSearching = true)),
      ),
    );
  }
}

class _ArticleCard extends ConsumerWidget {
  final VintedArticle article;
  final int index;
  const _ArticleCard({required this.article, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Dismissible(
        key: Key(article.uuid),
        background: Container(color: Colors.blue, alignment: Alignment.centerLeft, padding: const EdgeInsets.only(left: 20), child: const Icon(Icons.edit, color: Colors.white)),
        secondaryBackground: Container(color: Colors.red, alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20), child: const Icon(Icons.delete, color: Colors.white)),
        confirmDismiss: (dir) async {
          if (dir == DismissDirection.startToEnd) {
            Navigator.push(context, MaterialPageRoute(builder: (c) => AddArticlePage(articleToEdit: article)));
            return false;
          }
          return true;
        },
        onDismissed: (_) => ref.read(inventoryNotifierProvider.notifier).removeArticle(article.id!),
        child: GlassContainer(
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: article.photoPaths.isNotEmpty 
                ? Image.file(File(article.photoPaths.first), width: 60, height: 60, fit: BoxFit.cover)
                : Container(width: 60, height: 60, color: Colors.grey[200], child: const Icon(Icons.image)),
            ),
            title: Text(article.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${article.sellingPrice}€ • ${article.status}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => AddArticlePage(articleToEdit: article))),
          ),
        ),
      ),
    );
  }
}
