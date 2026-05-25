import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:gestion_vinted/shared/glass_container.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ArticleQRCodeScreen extends StatelessWidget {
  final String uuid;
  final String title;

  const ArticleQRCodeScreen({super.key, required this.uuid, required this.title});

  @override
  Widget build(BuildContext context) {
    final GlobalKey globalKey = GlobalKey();

    return Scaffold(
      appBar: AppBar(title: const Text('Code de l\'article')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RepaintBoundary(
                key: globalKey,
                child: GlassContainer(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18), textAlign: TextAlign.center),
                      const SizedBox(height: 20),
                      BarcodeWidget(
                        barcode: Barcode.qrCode(),
                        data: uuid,
                        width: 200,
                        height: 200,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 10),
                      Text(uuid.substring(0, 8), style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () => _shareQR(globalKey),
                icon: const Icon(Icons.print_rounded),
                label: const Text('Partager pour impression'),
                style: ElevatedButton.styleFrom(minimumSize: const Size(250, 50)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _shareQR(GlobalKey key) async {
    try {
      RenderRepaintBoundary boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final directory = await getTemporaryDirectory();
      final path = '${directory.path}/qr_code_$uuid.png';
      final file = File(path);
      await file.writeAsBytes(pngBytes);

      await Share.shareXFiles([XFile(path)], text: 'QR Code pour $title');
    } catch (e) {
      print('Erreur partage QR: $e');
    }
  }
}
