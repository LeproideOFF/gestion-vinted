import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';
import 'package:vibration/vibration.dart';
import '../domain/vinted_article.dart';
import '../domain/market_config.dart';
import 'inventory_provider.dart';
import 'market_provider.dart';
import '../../../core/utils/file_service.dart';
import '../../../core/utils/voice_service.dart';
import '../../../core/utils/ocr_service.dart';
import '../../../core/utils/log_service.dart';
import '../../../shared/glass_container.dart';

class AddArticlePage extends ConsumerStatefulWidget {
  final VintedArticle? articleToEdit;
  const AddArticlePage({super.key, this.articleToEdit});

  @override
  ConsumerState<AddArticlePage> createState() => _AddArticlePageState();
}

class _AddArticlePageState extends ConsumerState<AddArticlePage> {
  final _formKey = GlobalKey<FormState>();
  late ConfettiController _confettiController;
  
  // Controllers
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _brandController;
  late TextEditingController _sizeController;
  late TextEditingController _categoryController;
  late TextEditingController _purchasePriceController;
  late TextEditingController _sellingPriceController;
  late TextEditingController _shippingController;
  late TextEditingController _feesController;
  late TextEditingController _cleaningController;
  late TextEditingController _repairController;
  late TextEditingController _packagingController;
  late TextEditingController _locationController;
  late TextEditingController _notesController;
  late TextEditingController _trackingController;
  late TextEditingController _barcodeController;
  
  String _status = 'A vendre';
  String _condition = 'Très bon état';
  String _market = 'Vinted';
  List<String> _photoPaths = [];
  final ImagePicker _picker = ImagePicker();
  final VoiceAssistant _voice = VoiceAssistant();
  bool _isListening = false;
  double _listingScore = 0.0;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _voice.init();
    
    final a = widget.articleToEdit;
    _titleController = TextEditingController(text: a?.title ?? '');
    _descriptionController = TextEditingController(text: a?.description ?? '');
    _brandController = TextEditingController(text: a?.brand ?? '');
    _sizeController = TextEditingController(text: a?.size ?? '');
    _categoryController = TextEditingController(text: a?.category ?? '');
    _purchasePriceController = TextEditingController(text: a?.purchasePrice.toString() ?? '0.0');
    _sellingPriceController = TextEditingController(text: a?.sellingPrice.toString() ?? '0.0');
    _shippingController = TextEditingController(text: a?.shippingCost.toString() ?? '0.0');
    _feesController = TextEditingController(text: a?.platformFees.toString() ?? '0.0');
    _cleaningController = TextEditingController(text: a?.cleaningCost.toString() ?? '0.0');
    _repairController = TextEditingController(text: a?.repairCost.toString() ?? '0.0');
    _packagingController = TextEditingController(text: a?.packagingCost.toString() ?? '0.0');
    _locationController = TextEditingController(text: a?.location ?? '');
    _notesController = TextEditingController(text: a?.notes ?? '');
    _trackingController = TextEditingController(text: a?.trackingNumber ?? '');
    _barcodeController = TextEditingController(text: a?.barcode ?? '');
    
    if (a != null) {
      _status = a.status;
      _condition = a.condition;
      _market = a.market;
      _photoPaths = List.from(a.photoPaths);
    }
    _calculateListingScore();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _brandController.dispose();
    _sizeController.dispose();
    _categoryController.dispose();
    _purchasePriceController.dispose();
    _sellingPriceController.dispose();
    _shippingController.dispose();
    _feesController.dispose();
    _cleaningController.dispose();
    _repairController.dispose();
    _packagingController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    _trackingController.dispose();
    _barcodeController.dispose();
    super.dispose();
  }

  void _runIAAction(String action) {
    LogService.log('Running IA Action: $action');
    setState(() {
      switch (action) {
        case 'OPTIMIZE_DESC':
          _descriptionController.text = "✨ PROMO : ${_titleController.text}\n💎 État : $_condition\n📏 Taille : ${_sizeController.text}\n📦 Envoi soigné sous 24h\n\n#Vinted #Trend #Fashion";
          break;
        case 'GUESS_BRAND':
          final t = _titleController.text.toLowerCase();
          if (t.contains('nike')) _brandController.text = 'Nike';
          else if (t.contains('adidas')) _brandController.text = 'Adidas';
          else if (t.contains('levi')) _brandController.text = 'Levi\'s';
          else if (t.contains('zara')) _brandController.text = 'Zara';
          else _brandController.text = 'Détecté !';
          break;
        case 'ESTIMATE_PRICE':
          double base = double.tryParse(_purchasePriceController.text) ?? 10.0;
          _sellingPriceController.text = (base * 2.5).toStringAsFixed(2);
          break;
        case 'GENERATE_TAGS':
          _notesController.text = "Tags IA: #Vinted #EmpirePro #Resell #${_brandController.text.replaceAll(' ', '')}";
          break;
        case 'SMART_LOCATION':
          _locationController.text = "Zone ${(_titleController.text.length % 3) + 1}";
          break;
      }
    });
    _calculateListingScore();
  }

  void _calculateListingScore() {
    double score = 0.0;
    if (_titleController.text.length > 10) score += 0.2;
    if (_descriptionController.text.length > 30) score += 0.2;
    if (_photoPaths.isNotEmpty) score += 0.3;
    if (_brandController.text.isNotEmpty) score += 0.1;
    if (_purchasePriceController.text != '0.0') score += 0.2;
    setState(() => _listingScore = score.clamp(0.0, 1.0));
  }

  Future<void> _toggleVoice() async {
    if (_isListening) {
      await _voice.stop();
      setState(() => _isListening = false);
    } else {
      setState(() => _isListening = true);
      await _voice.listen(onResult: (text) {
        final data = _voice.parseVoiceCommand(text);
        setState(() {
          if (data.containsKey('title')) _titleController.text = data['title'];
          if (data.containsKey('purchasePrice')) _purchasePriceController.text = data['purchasePrice'].toString();
          if (data.containsKey('sellingPrice')) _sellingPriceController.text = data['sellingPrice'].toString();
          _isListening = false;
        });
        _calculateListingScore();
      });
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        final article = VintedArticle(
          id: widget.articleToEdit?.id,
          uuid: widget.articleToEdit?.uuid ?? const Uuid().v4(),
          title: _titleController.text,
          description: _descriptionController.text,
          brand: _brandController.text,
          size: _sizeController.text,
          category: _categoryController.text,
          condition: _condition,
          purchasePrice: double.tryParse(_purchasePriceController.text) ?? 0.0,
          sellingPrice: double.tryParse(_sellingPriceController.text) ?? 0.0,
          shippingCost: double.tryParse(_shippingController.text) ?? 0.0,
          platformFees: double.tryParse(_feesController.text) ?? 0.0,
          cleaningCost: double.tryParse(_cleaningController.text) ?? 0.0,
          repairCost: double.tryParse(_repairController.text) ?? 0.0,
          packagingCost: double.tryParse(_packagingController.text) ?? 0.0,
          status: _status,
          market: _market,
          location: _locationController.text,
          notes: _notesController.text,
          trackingNumber: _trackingController.text,
          barcode: _barcodeController.text,
          updatedAt: DateTime.now(),
          createdAt: widget.articleToEdit?.createdAt ?? DateTime.now(),
          photoPaths: _photoPaths,
        );

        if (_status == 'Vendu' && widget.articleToEdit?.status != 'Vendu') {
          _confettiController.play();
          Vibration.vibrate(duration: 500);
        }

        await ref.read(inventoryNotifierProvider.notifier).addArticle(article);
        if (mounted) {
          if (_status == 'Vendu') await Future.delayed(const Duration(seconds: 2));
          Navigator.of(context).pop();
        }
      } catch (e) {
        LogService.log('SUBMIT_ERROR: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final markets = ref.watch(marketNotifierProvider).value ?? [];
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Expert Empire Edition'),
        actions: [
          IconButton(icon: const Icon(Icons.auto_awesome, color: Colors.amber), onPressed: () => _runIAAction('OPTIMIZE_DESC')),
          IconButton(icon: const Icon(Icons.mic, color: Colors.blue), onPressed: _toggleVoice),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Theme.of(context).colorScheme.primary.withOpacity(0.15), Theme.of(context).colorScheme.surface],
          ),
        ),
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: isDesktop ? 800 : double.infinity),
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 120, 20, 120),
                  child: Form(
                    key: _formKey,
                    onChanged: _calculateListingScore,
                    child: Column(
                      children: [
                        _buildAiHub(),
                        const SizedBox(height: 25),
                        _buildPhotoPicker(),
                        const SizedBox(height: 25),
                        _buildGlassSection('IDENTITÉ DU PRODUIT', [
                          _buildField(_titleController, 'Titre de l\'annonce', Icons.title),
                          const SizedBox(height: 15),
                          DropdownButtonFormField<String>(
                            value: markets.any((m) => m.name == _market) ? _market : (markets.isNotEmpty ? markets.first.name : 'Vinted'),
                            decoration: _inputDecoration('Plateforme', Icons.storefront),
                            items: markets.map((m) => DropdownMenuItem(value: m.name, child: Text(m.name))).toList(),
                            onChanged: (val) => setState(() => _market = val!),
                          ),
                          const SizedBox(height: 15),
                          _buildField(_brandController, 'Marque', Icons.label_important_outline),
                          const SizedBox(height: 15),
                          _buildField(_categoryController, 'Catégorie', Icons.category_outlined),
                        ]),
                        const SizedBox(height: 25),
                        _buildGlassSection('DÉTAILS & ÉTAT', [
                          Row(children: [
                            Expanded(child: _buildField(_sizeController, 'Taille', Icons.straighten)),
                            const SizedBox(width: 10),
                            Expanded(child: DropdownButtonFormField<String>(
                              value: _condition,
                              decoration: _inputDecoration('État', Icons.star_outline),
                              items: ['Neuf', 'Très bon', 'Bon', 'Satisfaisant'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                              onChanged: (val) => setState(() => _condition = val!),
                            )),
                          ]),
                          const SizedBox(height: 15),
                          _buildField(_descriptionController, 'Description complète', Icons.description_outlined, maxLines: 4),
                        ]),
                        const SizedBox(height: 25),
                        _buildGlassSection('MON ACHAT (Investissement)', [
                          Row(children: [
                            Expanded(child: _buildField(_purchasePriceController, 'Prix Achat', Icons.shopping_cart, keyboardType: TextInputType.number)),
                            const SizedBox(width: 10),
                            Expanded(child: _buildField(_shippingController, 'Frais Port', Icons.local_shipping, keyboardType: TextInputType.number)),
                          ]),
                          const SizedBox(height: 15),
                          Row(children: [
                            Expanded(child: _buildField(_feesController, 'Frais Plateforme', Icons.account_balance_wallet, keyboardType: TextInputType.number)),
                            const SizedBox(width: 10),
                            Expanded(child: _buildField(_cleaningController, 'Nettoyage', Icons.wash, keyboardType: TextInputType.number)),
                          ]),
                          const SizedBox(height: 15),
                          _buildField(_repairController, 'Coût Réparation', Icons.build_circle_outlined, keyboardType: TextInputType.number),
                        ]),
                        const SizedBox(height: 25),
                        _buildGlassSection('MA REVENTE (Profit)', [
                          _buildField(_sellingPriceController, 'Prix de vente cible', Icons.sell, keyboardType: TextInputType.number),
                          const SizedBox(height: 15),
                          _buildField(_packagingController, 'Frais Emballage', Icons.inventory_2_outlined, keyboardType: TextInputType.number),
                          const SizedBox(height: 15),
                          DropdownButtonFormField<String>(
                            value: _status,
                            decoration: _inputDecoration('Statut de vente', Icons.info_outline),
                            items: ['A vendre', 'Vendu', 'Réservé'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                            onChanged: (val) => setState(() => _status = val!),
                          ),
                        ]),
                        const SizedBox(height: 25),
                        _buildGlassSection('LOGISTIQUE & NOTES', [
                          _buildField(_locationController, 'Emplacement physique (Bac A...)', Icons.shelves),
                          const SizedBox(height: 15),
                          _buildField(_trackingController, 'Numéro de suivi', Icons.qr_code_scanner),
                          const SizedBox(height: 15),
                          _buildField(_barcodeController, 'Code Barre / SKU', Icons.barcode_reader),
                          const SizedBox(height: 15),
                          _buildField(_notesController, 'Notes personnelles', Icons.note_alt_outlined, maxLines: 2),
                        ]),
                        const SizedBox(height: 40),
                        _buildSubmitButton(),
                      ],
                    ),
                  ),
                ),
                if (_isListening) _buildVoiceOverlay(),
                _buildConfetti(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAiHub() {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      color: Colors.amber.withOpacity(0.1),
      child: Column(
        children: [
          Row(
            children: [
              CircularProgressIndicator(value: _listingScore, strokeWidth: 5),
              const SizedBox(width: 15),
              const Text('IA MAGIC HUB', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5)),
            ],
          ),
          const SizedBox(height: 15),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _aiBtn('Estimation Prix', Icons.price_check, () => _runIAAction('ESTIMATE_PRICE')),
              _aiBtn('Deviner Marque', Icons.auto_awesome, () => _runIAAction('GUESS_BRAND')),
              _aiBtn('Auto-Location', Icons.shelves, () => _runIAAction('SMART_LOCATION')),
              _aiBtn('Générer Tags', Icons.tag, () => _runIAAction('GENERATE_TAGS')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _aiBtn(String label, IconData icon, VoidCallback onTap) {
    return ActionChip(
      avatar: Icon(icon, size: 16, color: Colors.amber),
      label: Text(label, style: const TextStyle(fontSize: 10)),
      onPressed: onTap,
      backgroundColor: Colors.white10,
    );
  }

  Widget _buildGlassSection(String title, List<Widget> children) {
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey, letterSpacing: 1.5)),
          const SizedBox(height: 15),
          ...children,
        ],
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String label, IconData icon, {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: _inputDecoration(label, icon),
      style: const TextStyle(fontSize: 14),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 20),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      filled: true,
      fillColor: Colors.black.withOpacity(0.02),
    );
  }

  Widget _buildPhotoPicker() {
    return SizedBox(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ..._photoPaths.map((path) => Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Stack(
              children: [
                ClipRRect(borderRadius: BorderRadius.circular(20), child: Image.file(File(path), width: 120, height: 120, fit: BoxFit.cover)),
                Positioned(top: 5, right: 5, child: GestureDetector(onTap: () => setState(() => _photoPaths.remove(path)), child: Container(padding: const EdgeInsets.all(4), decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle), child: const Icon(Icons.close, size: 14, color: Colors.white)))),
              ],
            ),
          )),
          GestureDetector(
            onTap: () async {
              final img = await _picker.pickImage(source: ImageSource.gallery);
              if (img != null) {
                final perm = await FileService.saveImageToPermanentStorage(img.path);
                setState(() => _photoPaths.add(perm));
                
                // Scan IA automatique de l'étiquette
                final result = await OCRService.scanClothingLabel(perm);
                if (result != null) {
                  setState(() {
                    if (result.brand != null && _brandController.text.isEmpty) {
                      _brandController.text = result.brand!;
                    }
                    if (result.size != null && _sizeController.text.isEmpty) {
                      _sizeController.text = result.size!;
                    }
                    if (result.category != null && _categoryController.text.isEmpty) {
                      _categoryController.text = result.category!;
                    }
                  });
                }
              }
            },
            child: GlassContainer(borderRadius: 20, child: Container(width: 120, height: 120, child: const Icon(Icons.add_a_photo, color: Colors.grey))),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _submit,
      style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(70), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)), elevation: 10),
      child: const Text('ENREGISTRER L\'ARTICLE', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
    );
  }

  Widget _buildVoiceOverlay() {
    return Container(color: Colors.black87, child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.mic, size: 80, color: Colors.red).animate(onPlay: (c) => c.repeat()).scale(duration: 500.ms), const SizedBox(height: 30), const Text('Dites par exemple :', style: TextStyle(color: Colors.white70)), const Text('"Ajoute Jean Levi\'s acheté 10€ revente 40€"', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)), const SizedBox(height: 50), ElevatedButton(onPressed: _toggleVoice, child: const Text('STOP'))])));
  }

  Widget _buildConfetti() {
    return Align(alignment: Alignment.topCenter, child: ConfettiWidget(confettiController: _confettiController, blastDirectionality: BlastDirectionality.explosive, shouldLoop: false));
  }
}
