import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_provider.g.dart';

enum GlassTheme { frost, deepOcean, royalGold, cyberNeon, leboncoin }

@riverpod
class AppSettings extends _$AppSettings {
  @override
  Map<String, dynamic> build() {
    return {
      'theme': GlassTheme.frost,
      'market': 'Vinted',
    };
  }

  void setTheme(GlassTheme theme) {
    state = {...state, 'theme': theme};
  }

  void setMarket(String market) {
    // Si on passe sur Leboncoin, on change automatiquement le thème
    if (market == 'Leboncoin') {
      state = {'market': market, 'theme': GlassTheme.leboncoin};
    } else {
      state = {'market': market, 'theme': GlassTheme.frost};
    }
  }
}

class ThemeColors {
  static Color getPrimary(GlassTheme theme) {
    switch (theme) {
      case GlassTheme.deepOcean: return const Color(0xFF0050FF);
      case GlassTheme.royalGold: return const Color(0xFFFFD700);
      case GlassTheme.cyberNeon: return const Color(0xFFFF00FF);
      case GlassTheme.leboncoin: return const Color(0xFFFF6E14); // Orange LBC
      default: return const Color(0xFF00B5B5); // Vinted Cyan
    }
  }

  static List<Color> getGradient(GlassTheme theme, bool isDark) {
    final primary = getPrimary(theme);
    if (theme == GlassTheme.leboncoin) {
      return [primary.withOpacity(0.2), isDark ? Colors.black : Colors.white];
    }
    return [primary.withOpacity(0.15), isDark ? Colors.black : Colors.white];
  }
}
