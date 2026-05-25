import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class OCRService {
  static final TextRecognizer _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  static Future<Map<String, double>?> scanReceipt() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.camera);
      if (image == null) return null;

      final inputImage = InputImage.fromFilePath(image.path);
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);

      double purchasePrice = 0.0;
      
      // Logique simple d'extraction : on cherche le plus gros montant ou "TOTAL"
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
