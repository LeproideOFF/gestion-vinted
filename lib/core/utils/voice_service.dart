import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/material.dart';
import 'log_service.dart';

class VoiceAssistant {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isAvailable = false;
  bool _isInitializing = false;

  Future<bool> init() async {
    if (_isInitializing) return false;
    _isInitializing = true;
    try {
      _isAvailable = await _speech.initialize(
        onStatus: (status) => LogService.log('Voice status: $status'),
        onError: (error) => LogService.log('Voice error: ${error.errorMsg}'),
      );
      _isInitializing = false;
      return _isAvailable;
    } catch (e) {
      LogService.log('Voice init critical error: $e');
      _isInitializing = false;
      return false;
    }
  }

  Future<void> listen({required Function(String) onResult}) async {
    if (!_isAvailable) {
      final success = await init();
      if (!success) return;
    }
    
    try {
      await _speech.listen(
        onResult: (result) {
          if (result.finalResult) {
            onResult(result.recognizedWords);
          }
        },
        localeId: 'fr_FR',
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 5),
        cancelOnError: true,
        listenMode: stt.ListenMode.dictation,
      );
    } catch (e) {
      LogService.log('Voice listen error: $e');
    }
  }

  Future<void> stop() async {
    await _speech.stop();
  }

  bool get isListening => _speech.isListening;
  bool get isAvailable => _isAvailable;

  Map<String, dynamic> parseVoiceCommand(String text) {
    final lowerText = text.toLowerCase();
    Map<String, dynamic> data = {};
    LogService.log('Parsing voice command: $text');
    
    if (lowerText.contains('ajoute')) {
      final start = lowerText.indexOf('ajoute') + 7;
      final end = lowerText.contains('acheté') ? lowerText.indexOf('acheté') : lowerText.length;
      if (start < end) data['title'] = text.substring(start, end).trim();
    }

    final purchaseReg = RegExp(r'achet. (\d+)');
    final pMatch = purchaseReg.firstMatch(lowerText);
    if (pMatch != null) data['purchasePrice'] = double.parse(pMatch.group(1)!);

    final sellingReg = RegExp(r'revente (\d+)');
    final sMatch = sellingReg.firstMatch(lowerText);
    if (sMatch != null) data['sellingPrice'] = double.parse(sMatch.group(1)!);

    return data;
  }
}
