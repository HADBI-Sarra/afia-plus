import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('en')) {
    _loadSavedLocale();
  }

  static const String _localeKey = 'saved_locale';

  Future<void> _loadSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLocaleCode = prefs.getString(_localeKey);
      if (savedLocaleCode != null) {
        emit(Locale(savedLocaleCode));
      }
    } catch (e) {
      print('Error loading saved locale: $e');
      // Keep default English locale
    }
  }

  Future<void> changeLocale(Locale newLocale) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, newLocale.languageCode);
      emit(newLocale);
      print('✅ Locale changed to: ${newLocale.languageCode}');
    } catch (e) {
      print('Error saving locale: $e');
    }
  }

  Future<void> toggleLocale() async {
    final currentCode = state.languageCode;
    Locale newLocale;

    // Cycle through locales: en -> ar -> fr -> en
    switch (currentCode) {
      case 'ar':
        newLocale = const Locale('fr');
        break;
      case 'fr':
        newLocale = const Locale('en');
        break;
      case 'en':
      default:
        newLocale = const Locale('ar');
        break;
    }

    await changeLocale(newLocale);
  }
}
