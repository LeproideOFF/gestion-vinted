import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../domain/vinted_article.dart';
import 'inventory_provider.dart';
import '../../../core/utils/file_service.dart';
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
  List<String> _photoPaths = [];
  final ImagePicker _picker = ImagePicker();
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
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
      _photoPaths = List.from(a.photoPaths);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _purchasePriceController.dispose();
    _sellingPriceController.dispose();
    _shippingController.dispose();
    _feesController.dispose();
    _packagingController.dispose();
    _locationController.dispose();
    _barcodeController.dispose();
    _trackingController.dispose();
    super.dispose();
  }

  void _generateDescription() {
    if (_titleController.text.isNotEmpty) {
      setState(() {
        _descriptionController.text = "Magnifique ${_titleController.text} en excellent état. N'hésitez pas à me contacter pour plus d'infos ! \n\n#Vinted #${_titleController.text.replaceAll(' ', '')} #Mode";
      });
    }
  }

  void _estimatePrice() {
    if (_titleController.text.isNotEmpty) {
      // Simulation IA simple
      setState(() {
        _sellingPriceController.text = "25.0";
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Estimation IA : 25€ (Basée sur des ventes similaires)')));
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final permanentPath = await FileService.saveImageToPermanentStorage(image.path);
      setState(() => _photoPaths.add(permanentPath));
    }
  }

  Future<void> _scanBarcode() async {
    // Si on est sur Desktop, mobile_scanner ne marchera pas directement, donc on simule
    if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
      setState(() => _barcodeController.text = const Uuid().v4().substring(0, 13));
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Code barre généré (Desktop)')));
      return;
    }

    final code = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const _BarcodeScannerScreen()),
    );
    if (code != null) {
      setState(() => _barcodeController.text = code);
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
    return DropTarget(
      onDragEntered: (details) => setState(() => _isDragging = true),
      onDragExited: (details) => setState(() => _isDragging = false),
      onDragDone: (details) async {
        setState(() => _isDragging = false);
        for (final file in details.files) {
          final permanentPath = await FileService.saveImageToPermanentStorage(file.path);
          setState(() => _photoPaths.add(permanentPath));
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(widget.articleToEdit != null ? 'Modifier' : 'Nouveau'),
          backgroundColor: Colors.transparent,
          elevation: 0,
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
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 120, 20, 100),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Photos (Glissez-déposez sur Mac)'),
                      const SizedBox(height: 10),
                      _buildPhotoPicker(),
                      const SizedBox(height: 25),
                      
                      GlassContainer(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            _buildSectionTitle('L\'ARTICLE & IA'),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                Expanded(child: _buildField(_titleController, 'Titre', Icons.title)),
                                IconButton(icon: const Icon(Icons.price_check, color: Colors.blue), onPressed: _estimatePrice, tooltip: 'Estimer Prix IA'),
                              ],
                            ),
                            const SizedBox(height: 15),
                            _buildField(_descriptionController, 'Description', Icons.description, maxLines: 3),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                onPressed: _generateDescription,
                                icon: const Icon(Icons.auto_awesome, size: 16),
                                label: const Text('Générer Mots-clés IA'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 25),
                      GlassContainer(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle('LOGISTIQUE & SUIVI'),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                Expanded(child: _buildField(_locationController, 'Emplacement (ex: Bac A)', Icons.shelves)),
                                const SizedBox(width: 10),
                                Expanded(child: _buildField(_trackingController, 'Num. Suivi', Icons.local_shipping)),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                Expanded(child: _buildField(_barcodeController, 'Code Barre / QR', Icons.qr_code)),
                                IconButton(icon: const Icon(Icons.qr_code_scanner), onPressed: _scanBarcode),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 25),
                      GlassContainer(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle('FINANCES (€)'),
                            const SizedBox(height: 15),
                            _buildField(_purchasePriceController, 'Prix d\'achat', Icons.shopping_bag_outlined, keyboardType: TextInputType.number),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                Expanded(child: _buildField(_shippingController, 'Frais port', Icons.local_shipping_outlined, keyboardType: TextInputType.number)),
                                const SizedBox(width: 10),
                                Expanded(child: _buildField(_feesController, 'Comm. Vinted', Icons.account_balance_wallet_outlined, keyboardType: TextInputType.number)),
                                const SizedBox(width: 10),
                                Expanded(child: _buildField(_packagingController, 'Emballage', Icons.inventory_2_outlined, keyboardType: TextInputType.number)),
                              ],
                            ),
                            const Divider(height: 40),
                            _buildSectionTitle('MA REVENTE'),
                            const SizedBox(height: 15),
                            _buildField(_sellingPriceController, 'Prix de vente sur Vinted', Icons.sell_rounded, keyboardType: TextInputType.number),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 25),
                      _buildSectionTitle('Statut'),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: _status,
                        items: ['A vendre', 'Vendu', 'Réservé']
                            .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                            .toList(),
                        onChanged: (val) => setState(() => _status = val!),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.info_outline),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(65),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        ),
                        child: Text(widget.articleToEdit != null ? 'Enregistrer les modifications' : 'Ajouter à l\'inventaire', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ).animate().fadeIn(delay: 500.ms).scale(),
                    ],
                  ),
                ),
              ),
              if (_isDragging)
                Container(
                  color: Colors.deepPurple.withOpacity(0.3),
                  child: const Center(
                    child: Icon(Icons.cloud_download, size: 100, color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1.5, color: Colors.grey));
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
        filled: true,
        fillColor: Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.02),
      ),
      validator: (value) => (value == null || value.isEmpty) ? 'Requis' : null,
    );
  }

  Widget _buildPhotoPicker() {
    return SizedBox(
      height: 110,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ..._photoPaths.map((path) => Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.file(File(path), height: 110, width: 110, fit: BoxFit.cover),
                    ),
                    Positioned(
                      top: 5, right: 5,
                      child: GestureDetector(
                        onTap: () => setState(() => _photoPaths.remove(path)),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                          child: const Icon(Icons.close, size: 15, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().scale().fadeIn()),
          GestureDetector(
            onTap: _pickImage,
            child: GlassContainer(
              borderRadius: 20,
              child: Container(
                height: 110,
                width: 110,
                child: const Icon(Icons.add_a_photo_rounded, size: 30, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BarcodeScannerScreen extends StatelessWidget {
  const _BarcodeScannerScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scanner le code barre')),
      body: MobileScanner(
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          if (barcodes.isNotEmpty) {
            final String code = barcodes.first.rawValue ?? '';
            if (code.isNotEmpty) {
              Navigator.pop(context, code);
            }
          }
        },
      ),
    );
  }
}
