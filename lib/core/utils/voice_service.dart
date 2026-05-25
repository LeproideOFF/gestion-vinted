import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/material.dart';

class VoiceAssistant {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isAvailable = false;

  Future<bool> init() async {
    _isAvailable = await _speech.initialize();
    return _isAvailable;
  }

  Future<void> listen({required Function(String) onResult}) async {
    if (_isAvailable) {
      await _speech.listen(
        onResult: (result) => onResult(result.recognizedWords),
        localeId: 'fr_FR',
      );
    }
  }

  Future<void> stop() async {
    await _speech.stop();
  }

  // Analyse simplifiée de la voix pour extraire des données
  // Ex: "Ajoute Jean Levi's acheté 10 euros revente 40"
  Map<String, dynamic> parseVoiceCommand(String text) {
    final lowerText = text.toLowerCase();
    Map<String, dynamic> data = {};
    
    // Titre
    if (lowerText.contains('ajoute')) {
      final start = lowerText.indexOf('ajoute') + 7;
      final end = lowerText.contains('acheté') ? lowerText.indexOf('acheté') : lowerText.length;
      data['title'] = text.substring(start, end).trim();
    }

    // Prix achat
    final purchaseReg = RegExp(r'acheté (\d+)');
    final pMatch = purchaseReg.firstMatch(lowerText);
    if (pMatch != null) data['purchasePrice'] = double.parse(pMatch.group(1)!);

    // Prix revente
    final sellingReg = RegExp(r'revente (\d+)');
    final sMatch = sellingReg.firstMatch(lowerText);
    if (sMatch != null) data['sellingPrice'] = double.parse(sMatch.group(1)!);

    return data;
  }
}
