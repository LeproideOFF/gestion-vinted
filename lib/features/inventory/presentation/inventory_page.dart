import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'inventory_provider.dart';
import 'add_article_page.dart';
import 'article_qr_screen.dart';
import '../../../shared/glass_container.dart';
import '../domain/vinted_article.dart';
import '../../../core/utils/business_service.dart';

final searchProvider = StateProvider<String>((ref) => '');
final filterStatusProvider = StateProvider<String?>((ref) => null);

class InventoryPage extends ConsumerWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inventoryAsync = ref.watch(inventoryListProvider);
    final searchQuery = ref.watch(searchProvider);
    final filterStatus = ref.watch(filterStatusProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primary.withOpacity(0.15),
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
              elevation: 0,
              stretch: true,
              title: const Text('Inventaire', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 36, letterSpacing: -1)),
              actions: [
                _SearchButton(),
                const SizedBox(width: 10),
                _FilterMenu(),
                const SizedBox(width: 16),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: _buildQuickStats(inventoryAsync),
              ),
            ),
            SliverToBoxAdapter(
              child: inventoryAsync.when(
                data: (articles) {
                  var filtered = articles.where((a) {
                    final query = searchQuery.toLowerCase();
                    // Recherche par titre OU par UUID (pour le scan QR)
                    return a.title.toLowerCase().contains(query) || a.uuid.toLowerCase().contains(query);
                  }).toList();

                  if (filterStatus != null) {
                    filtered = filtered.where((a) => a.status == filterStatus).toList();
                  }
                  
                  if (filtered.isEmpty) return _buildEmptyState(context, isSearch: searchQuery.isNotEmpty || filterStatus != null);
                  
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 180),
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
      ),
      floatingActionButton: _buildFab(context),
    );
  }

  Widget _buildQuickStats(AsyncValue<List<VintedArticle>> asyncArticles) {
    return asyncArticles.when(
      data: (articles) => Row(
        children: [
          _StatChip(label: '${articles.length} Articles', icon: Icons.inventory_2_rounded, color: Colors.blue),
          const SizedBox(width: 10),
          _StatChip(
            label: '${articles.where((a) => a.status == 'Vendu').length} Vendus', 
            icon: Icons.check_circle_rounded, 
            color: Colors.green
          ),
        ],
      ),
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildFab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 90),
      child: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const AddArticlePage()),
        ),
        icon: const Icon(Icons.add_rounded, size: 30),
        label: const Text('AJOUTER', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5)),
        elevation: 20,
      ).animate().scale(delay: 500.ms, curve: Curves.elasticOut),
    );
  }

  Widget _buildEmptyState(BuildContext context, {bool isSearch = false}) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GlassContainer(
            borderRadius: 40,
            padding: const EdgeInsets.all(30),
            child: Icon(isSearch ? Icons.search_off_rounded : Icons.add_shopping_cart_rounded, size: 60, color: Colors.grey.withOpacity(0.5)),
          ),
          const SizedBox(height: 24),
          Text(isSearch ? 'Aucun résultat' : 'Votre inventaire est vide', 
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey)),
        ],
      ).animate().fadeIn().slideY(begin: 0.2, end: 0),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  const _StatChip({required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: 15,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _FilterMenu extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentFilter = ref.watch(filterStatusProvider);
    return PopupMenuButton<String?>(
      icon: GlassContainer(
        borderRadius: 15,
        padding: const EdgeInsets.all(8),
        child: Icon(Icons.filter_list_rounded, color: currentFilter != null ? Colors.deepPurple : null),
      ),
      onSelected: (val) => ref.read(filterStatusProvider.notifier).state = val,
      itemBuilder: (context) => [
        const PopupMenuItem(value: null, child: Text('Tous les articles')),
        const PopupMenuItem(value: 'A vendre', child: Text('En vente')),
        const PopupMenuItem(value: 'Vendu', child: Text('Vendus')),
        const PopupMenuItem(value: 'Réservé', child: Text('Réservés')),
      ],
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

  Future<void> _scanAndSearch() async {
    final code = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const _InventoryQRScanner()),
    );
    if (code != null) {
      setState(() => _isSearching = true);
      _controller.text = code;
      ref.read(searchProvider.notifier).state = code;
    }
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchProvider);
    if (query.isEmpty && _controller.text.isNotEmpty) _controller.clear();

    return AnimatedContainer(
      duration: 300.ms,
      width: _isSearching ? 240 : 50,
      child: GlassContainer(
        borderRadius: 20,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: _isSearching 
          ? Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    autofocus: true,
                    onChanged: (val) => ref.read(searchProvider.notifier).state = val,
                    decoration: const InputDecoration(
                      hintText: 'Titre ou scan...',
                      border: InputBorder.none,
                      icon: Icon(Icons.search_rounded, size: 20),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.qr_code_scanner_rounded, size: 20, color: Colors.blue),
                  onPressed: _scanAndSearch,
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () {
                    setState(() => _isSearching = false);
                    _controller.clear();
                    ref.read(searchProvider.notifier).state = '';
                  },
                ),
              ],
            )
          : IconButton(icon: const Icon(Icons.search_rounded), onPressed: () => setState(() => _isSearching = true)),
      ),
    );
  }
}

class _InventoryQRScanner extends StatelessWidget {
  const _InventoryQRScanner();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scanner l\'article')),
      body: MobileScanner(
        onDetect: (capture) {
          final barcodes = capture.barcodes;
          if (barcodes.isNotEmpty) {
            final code = barcodes.first.rawValue;
            if (code != null) Navigator.pop(context, code);
          }
        },
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
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Dismissible(
        key: Key(article.uuid),
        background: _buildSwipeBackground(Alignment.centerLeft, Colors.blue, Icons.edit, 'Modifier'),
        secondaryBackground: _buildSwipeBackground(Alignment.centerRight, Colors.red, Icons.delete_outline, 'Supprimer'),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddArticlePage(articleToEdit: article)));
            return false;
          } else {
            return await _showDeleteConfirm(context, ref);
          }
        },
        child: GlassContainer(
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddArticlePage(articleToEdit: article))),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  _buildImage(),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(article.title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18), maxLines: 1),
                        const SizedBox(height: 4),
                        Text(article.brand.isNotEmpty ? article.brand : 'Marque inconnue', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text('${article.sellingPrice}€', style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.w900, fontSize: 20)),
                            const Spacer(),
                            _ProfitBadge(profit: article.netProfit),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (article.location.isNotEmpty)
                              _InfoTag(label: article.location, icon: Icons.shelves, color: Colors.blue),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.qr_code_2_rounded, size: 20, color: Colors.grey),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => ArticleQRCodeScreen(uuid: article.uuid, title: article.title)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            IconButton(
                              icon: const Icon(Icons.ios_share_rounded, size: 20, color: Colors.deepPurple),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () => BusinessService.shareArticle(article),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: (index * 50).ms).slideX(begin: 0.1, end: 0);
  }

  Widget _buildImage() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 15, offset: const Offset(0, 8))],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: article.photoPaths.isNotEmpty
                ? Image.file(File(article.photoPaths.first), width: 100, height: 100, fit: BoxFit.cover)
                : Container(width: 100, height: 100, color: Colors.grey[200], child: const Icon(Icons.image_not_supported, size: 40)),
          ),
        ),
        Positioned(
          bottom: 0, right: 0,
          child: _StatusBadge(status: article.status),
        ),
      ],
    );
  }

  Widget _buildSwipeBackground(Alignment alignment, Color color, IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: alignment,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(30)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 30),
          Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }

  Future<bool?> _showDeleteConfirm(BuildContext context, WidgetRef ref) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer ?'),
        content: Text('Voulez-vous vraiment supprimer "${article.title}" ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          TextButton(onPressed: () {
            ref.read(inventoryNotifierProvider.notifier).removeArticle(article.id!);
            Navigator.pop(context, true);
          }, child: const Text('Supprimer', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }
}

class _InfoTag extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  const _InfoTag({required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(5)),
      child: Row(
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _ProfitBadge extends StatelessWidget {
  final double profit;
  const _ProfitBadge({required this.profit});
  @override
  Widget build(BuildContext context) {
    final isPositive = profit >= 0;
    return GlassContainer(
      borderRadius: 12,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      color: isPositive ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
      hasShadow: false,
      child: Text('${isPositive ? '+' : ''}${profit.toStringAsFixed(2)}€', 
        style: TextStyle(color: isPositive ? Colors.green : Colors.red, fontWeight: FontWeight.w900, fontSize: 14)
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});
  @override
  Widget build(BuildContext context) {
    Color color = status == 'Vendu' ? Colors.red : (status == 'Réservé' ? Colors.orange : const Color(0xFF00B5B5));
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 3)),
      child: Icon(status == 'Vendu' ? Icons.check : (status == 'Réservé' ? Icons.pause : Icons.sell), size: 14, color: Colors.white),
    );
  }
}
