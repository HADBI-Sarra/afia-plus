import 'package:flutter/material.dart';
import 'package:afia_plus_app/l10n/app_localizations.dart';

/// Helper function to convert error keys to localized error messages
String? getLocalizedError(String? errorKey, BuildContext context) {
  if (errorKey == null) return null;
  
  final l10n = AppLocalizations.of(context);
  if (l10n == null) return errorKey; // Fallback if localization not available
  
  // Map error keys to localization getters
  switch (errorKey) {
    case 'errorEmailEmpty':
      return l10n.errorEmailEmpty;
    case 'errorEmailInvalid':
      return l10n.errorEmailInvalid;
    case 'errorPasswordEmpty':
      return l10n.errorPasswordEmpty;
    case 'errorPasswordShort':
      return l10n.errorPasswordShort;
    case 'errorPasswordWeak':
      return l10n.errorPasswordWeak;
    case 'errorPasswordConfirmationEmpty':
      return l10n.errorPasswordConfirmationEmpty;
    case 'errorPasswordsDoNotMatch':
      return l10n.errorPasswordsDoNotMatch;
    case 'errorEmailTaken':
      return l10n.errorEmailTaken;
    case 'errorFirstNameEmpty':
      return l10n.errorFirstNameEmpty;
    case 'errorFirstNameInvalid':
      return l10n.errorFirstNameInvalid;
    case 'errorLastNameEmpty':
      return l10n.errorLastNameEmpty;
    case 'errorLastNameInvalid':
      return l10n.errorLastNameInvalid;
    case 'errorDobEmpty':
      return l10n.errorDobEmpty;
    case 'errorDobMinor':
      return l10n.errorDobMinor;
    case 'errorDobFormat':
      return l10n.errorDobFormat;
    case 'errorPhoneEmpty':
      return l10n.errorPhoneEmpty;
    case 'errorPhoneInvalid':
      return l10n.errorPhoneInvalid;
    case 'errorNinEmpty':
      return l10n.errorNinEmpty;
    case 'errorNinInvalid':
      return l10n.errorNinInvalid;
    case 'errorFieldEmpty':
      return l10n.errorFieldEmpty;
    case 'errorSpecialityNotSelected':
      return l10n.errorSpecialityNotSelected;
    case 'errorLicenceInvalid':
      return l10n.errorLicenceInvalid;
    case 'errorYearsInvalid':
      return l10n.errorYearsInvalid;
    case 'errorPriceInvalid':
      return l10n.errorPriceInvalid;
    case 'failedToLoadSpecialities':
      return l10n.failedToLoadSpecialities;
    case 'errorTimeout':
      return l10n.errorTimeout;
    case 'errorEmailCheckFailed':
      return l10n.errorEmailCheckFailed;
    case 'errorSignupFailed':
      return l10n.errorSignupFailed;
    case 'doctorNotFound':
      return l10n.doctorNotFound;
    default:
      // For dynamic errors or unknown keys, try to handle common patterns
      if (errorKey.startsWith('errorMinCharacters')) {
        // Extract number if present, otherwise use default
        // Format: errorMinCharacters15, errorMinCharacters5, etc.
        final match = RegExp(r'errorMinCharacters(\d+)').firstMatch(errorKey);
        if (match != null) {
          final num = int.tryParse(match.group(1) ?? '0') ?? 0;
          return l10n.errorMinCharacters(num);
        }
        return l10n.errorMinCharacters(5); // Default
      }
      if (errorKey.startsWith('errorOccurred')) {
        // Extract error message if present
        // Format: errorOccurred:actual error message
        final colonIndex = errorKey.indexOf(':');
        if (colonIndex != -1 && colonIndex < errorKey.length - 1) {
          return l10n.errorOccurred(errorKey.substring(colonIndex + 1));
        }
        return l10n.errorOccurred('');
      }
      // Return as-is if not a recognized key (might be a server error message)
      return errorKey;
  }
}

