import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afia_plus_app/cubits/locale_cubit.dart';
import 'package:afia_plus_app/views/themes/style_simple/colors.dart';

/// Language switcher widget that can be placed in AppBar or anywhere
class LanguageSwitcher extends StatelessWidget {
  final bool showLabel;
  final IconData? icon;
  
  const LanguageSwitcher({
    super.key,
    this.showLabel = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, Locale>(
      builder: (context, locale) {
        final isArabic = locale.languageCode == 'ar';
        final isFrench = locale.languageCode == 'fr';
        
        return PopupMenuButton<String>(
          icon: icon != null 
              ? Icon(icon, color: darkGreenColor)
              : Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: darkGreenColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: darkGreenColor, width: 1.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isArabic ? 'العربية' : isFrench ? 'Français' : 'English',
                        style: const TextStyle(
                          color: darkGreenColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.language,
                        color: darkGreenColor,
                        size: 18,
                      ),
                    ],
                  ),
                ),
          onSelected: (String languageCode) {
            context.read<LocaleCubit>().changeLocale(Locale(languageCode));
          },
          itemBuilder: (BuildContext context) => [
            PopupMenuItem<String>(
              value: 'ar',
              child: Row(
                children: [
                  const Text('العربية'),
                  if (isArabic) ...[
                    const Spacer(),
                    const Icon(Icons.check, color: darkGreenColor, size: 18),
                  ],
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'en',
              child: Row(
                children: [
                  const Text('English'),
                  if (!isArabic && !isFrench) ...[
                    const Spacer(),
                    const Icon(Icons.check, color: darkGreenColor, size: 18),
                  ],
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'fr',
              child: Row(
                children: [
                  const Text('Français'),
                  if (isFrench) ...[
                    const Spacer(),
                    const Icon(Icons.check, color: darkGreenColor, size: 18),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Simple language toggle button (switches between ar/en)
class LanguageToggleButton extends StatelessWidget {
  const LanguageToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, Locale>(
      builder: (context, locale) {
        final isArabic = locale.languageCode == 'ar';
        
        return IconButton(
          icon: const Icon(Icons.language, color: darkGreenColor),
          tooltip: isArabic ? 'Switch to English' : 'التبديل إلى العربية',
          onPressed: () {
            context.read<LocaleCubit>().toggleLocale();
          },
        );
      },
    );
  }
}

