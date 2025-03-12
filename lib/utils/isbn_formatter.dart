import 'package:flutter/services.dart';

class ISBNFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String formatted = newValue.text.replaceAll(RegExp(r'\D'), '');

    if (formatted.length <= 10) {
      formatted = _formatISBN10(formatted);
    } else if (formatted.length == 13) {
      formatted = _formatISBN13(formatted);
    }

    return newValue.copyWith(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length));
  }

  // Format ISBN-10 (X-XXXX-XXXX-X)
  String _formatISBN10(String value) {
    if (value.length <= 1) return value;
    if (value.length <= 5) {
      return '${value.substring(0, 1)}-${value.substring(1)}';
    }
    if (value.length <= 9) {
      return '${value.substring(0, 1)}-${value.substring(1, 5)}-${value.substring(5)}';
    }
    if (value.length == 10) {
      return '${value.substring(0, 1)}-${value.substring(1, 5)}-${value.substring(5, 9)}-${value.substring(9)}';
    }
    return value;
  }

  // Format ISBN-13 (979-12-8022-967-0)
  String _formatISBN13(String value) {
    if (value.length <= 3) return value;
    if (value.length <= 5) {
      return '${value.substring(0, 3)}-${value.substring(3)}';
    }
    if (value.length <= 9) {
      return '${value.substring(0, 3)}-${value.substring(3, 5)}-${value.substring(5)}';
    }
    if (value.length <= 12) {
      return '${value.substring(0, 3)}-${value.substring(3, 5)}-${value.substring(5, 9)}-${value.substring(9)}';
    }
    if (value.length == 13) {
      return '${value.substring(0, 3)}-${value.substring(3, 5)}-${value.substring(5, 9)}-${value.substring(9, 12)}-${value.substring(12)}';
    }
    return value;
  }
}
