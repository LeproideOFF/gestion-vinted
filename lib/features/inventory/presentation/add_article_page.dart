import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:desktop_drop/desktop_drop.dart';
import '../domain/vinted_article.dart';
import 'inventory_provider.dart';
import '../../../core/utils/file_service.dart';
import '../../../core/utils/voice_service.dart';
import '../../../shared/glass_container.dart';

class AddArticlePage extends ConsumerStatefulWidget {
  final VintedArticle? articleToEdit;
  const AddArticlePage({super.key, this.articleToEdit});

  @override
  ConsumerState<AddArticlePage> createState() => _AddArticlePageState();
}

class _AddArticlePageState extends ConsumerState<AddArticlePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _purchasePriceController;
  late TextEditingController _sellingPriceController;
  late TextEditingController _shippingController;
  late TextEditingController _feesController;
  late TextEditingController _packagingController;
  late TextEditingController _locationController;
  late TextEditingController _barcodeController;
  late TextEditingController _trackingController;
  
  String _status = 'A vendre';
  String _market = 'Vinted';
  List<String> _photoPaths = [];
  final ImagePicker _picker = ImagePicker();
  final VoiceAssistant _voice = VoiceAssistant();
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _voice.init();
    final a = widget.articleToEdit;
    _titleController = TextEditingController(text: a?.title ?? '');
    _descriptionController = TextEditingController(text: a?.description ?? '');
    _purchasePriceController = TextEditingController(text: a?.purchasePrice.toString() ?? '0.0');
    _sellingPriceController = TextEditingController(text: a?.sellingPrice.toString() ?? '0.0');
    _shippingController = TextEditingController(text: a?.shippingCost.toString() ?? '0.0');
    _feesController = TextEditingController(text: a?.platformFees.toString() ?? '0.0');
    _packagingController = TextEditingController(text: a?.packagingCost.toString() ?? '0.0');
    _locationController = TextEditingController(text: a?.location ?? '');
    _barcodeController = TextEditingController(text: a?.barcode ?? '');
    _trackingController = TextEditingController(text: a?.trackingNumber ?? '');
    
    if (a != null) {
      _status = a.status;
      _market = a.market;
      _photoPaths = List.from(a.photoPaths);
    }
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
        });
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final article = VintedArticle(
        id: widget.articleToEdit?.id,
        uuid: widget.articleToEdit?.uuid ?? const Uuid().v4(),
        title: _titleController.text,
        description: _descriptionController.text,
        purchasePrice: double.tryParse(_purchasePriceController.text) ?? 0.0,
        sellingPrice: double.tryParse(_sellingPriceController.text) ?? 0.0,
        shippingCost: double.tryParse(_shippingController.text) ?? 0.0,
        platformFees: double.tryParse(_feesController.text) ?? 0.0,
        packagingCost: double.tryParse(_packagingController.text) ?? 0.0,
        status: _status,
        market: _market,
        location: _locationController.text,
        barcode: _barcodeController.text,
        trackingNumber: _trackingController.text,
        updatedAt: DateTime.now(),
        createdAt: widget.articleToEdit?.createdAt ?? DateTime.now(),
        photoPaths: _photoPaths,
      );

      ref.read(inventoryNotifierProvider.notifier).addArticle(article);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Détails Article'),
        actions: [
          IconButton(
            icon: Icon(_isListening ? Icons.mic : Icons.mic_none, color: _isListening ? Colors.red : null),
            onPressed: _toggleVoice,
          ).animate(onPlay: (c) => _isListening ? c.repeat() : c.stop()).shake(),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 120, 20, 100),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildPhotoPicker(),
                const SizedBox(height: 25),
                
                GlassContainer(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildSectionTitle('MARCHÉ CIBLE'),
                      const SizedBox(height: 10),
                      SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(value: 'Vinted', label: Text('Vinted'), icon: Icon(Icons.shopping_bag)),
                          ButtonSegment(value: 'Leboncoin', label: Text('LBC'), icon: Icon(Icons.storefront)),
                        ],
                        selected: {_market},
                        onSelectionChanged: (val) => setState(() => _market = val.first),
                      ),
                      const SizedBox(height: 20),
                      _buildField(_titleController, 'Titre', Icons.title),
                      const SizedBox(height: 15),
                      _buildField(_descriptionController, 'Description', Icons.description, maxLines: 3),
                    ],
                  ),
                ),
                
                const SizedBox(height: 25),
                GlassContainer(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildSectionTitle('FINANCES & LOGISTIQUE'),
                      const SizedBox(height: 15),
                      _buildField(_purchasePriceController, 'Coût d\'achat', Icons.euro, keyboardType: TextInputType.number),
                      const SizedBox(height: 15),
                      _buildField(_sellingPriceController, 'Prix de vente', Icons.sell, keyboardType: TextInputType.number),
                      const SizedBox(height: 15),
                      _buildField(_locationController, 'Emplacement', Icons.shelves),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(65), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                  child: const Text('ENREGISTRER', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2, color: Colors.grey));
  }

  Widget _buildField(TextEditingController controller, String label, IconData icon, {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      ),
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(File(path), width: 120, height: 120, fit: BoxFit.cover),
            ),
          )),
          GestureDetector(
            onTap: () async {
              final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
              if (image != null) {
                final perm = await FileService.saveImageToPermanentStorage(image.path);
                setState(() => _photoPaths.add(perm));
              }
            },
            child: GlassContainer(
              borderRadius: 20,
              child: Container(width: 120, height: 120, child: const Icon(Icons.add_a_photo, color: Colors.grey)),
            ),
          ),
        ],
      ),
    );
  }
}
