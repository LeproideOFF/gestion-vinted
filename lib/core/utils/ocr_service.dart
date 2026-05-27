import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class LabelScanResult {
  final String? brand;
  final String? size;
  final String? category;

  LabelScanResult({this.brand, this.size, this.category});
}

class OCRService {
  static final TextRecognizer _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  static Future<LabelScanResult?> scanClothingLabel(String imagePath) async {
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);

      String? brand;
      String? size;
      String? category;

      final brands = ['NIKE', 'ADIDAS', 'ZARA', 'LEVI', 'GUESS', 'LACOSTE', 'RALPH LAUREN', 'HM', 'MANGO', 'PUMA'];
      final sizes = RegExp(r'\b(XS|S|M|L|XL|XXL|34|36|38|40|42|44|46|48|50|2|4|6|8|10|12)\b');
      final categories = {
        'JEANS': 'Jeans',
        'TSHIRT': 'T-Shirt',
        'SWEAT': 'Sweat',
        'JACKET': 'Veste',
        'SHOES': 'Chaussures',
        'SHIRT': 'Chemise',
        'PANTS': 'Pantalon'
      };

      for (TextBlock block in recognizedText.blocks) {
        for (TextLine line in block.lines) {
          final text = line.text.toUpperCase();
          
          // Détection Marque
          for (var b in brands) {
            if (text.contains(b)) {
              brand = b[0] + b.substring(1).toLowerCase();
            }
          }

          // Détection Taille
          final sizeMatch = sizes.firstMatch(text);
          if (sizeMatch != null) {
            size = sizeMatch.group(0);
          }

          // Détection Catégorie
          categories.forEach((key, value) {
            if (text.contains(key)) {
              category = value;
            }
          });
        }
      }

      return LabelScanResult(brand: brand, size: size, category: category);
    } catch (e) {
      print('Erreur OCR Label: $e');
      return null;
    }
  }

  static Future<Map<String, double>?> scanReceipt() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.camera);
      if (image == null) return null;

      final inputImage = InputImage.fromFilePath(image.path);
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);

      double purchasePrice = 0.0;
      
      for (TextBlock block in recognizedText.blocks) {
        for (TextLine line in block.lines) {
          final text = line.text.toUpperCase();
          if (text.contains('TOTAL') || text.contains('EUR') || text.contains('€')) {
            final regExp = RegExp(r'(\d+[.,]\d{2})');
            final match = regExp.firstMatch(text);
            if (match != null) {
              String val = match.group(1)!.replaceAll(',', '.');
              double price = double.parse(val);
              if (price > purchasePrice) purchasePrice = price;
            }
          }
        }
      }

      return {'purchasePrice': purchasePrice};
    } catch (e) {
      print('Erreur OCR: $e');
      return null;
    }
  }

  static void dispose() {
    _textRecognizer.close();
  }
}
