import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qration/theme/theme_notifier.dart';

class CustomPickerField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isDatePicker;

  const CustomPickerField({
    super.key,
    required this.label,
    required this.controller,
    required this.isDatePicker,
  });

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    return TextField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.montserrat(
          color: Theme.of(context).colorScheme.tertiary,
        ),
      ),
      style: GoogleFonts.montserrat(
        color: Theme.of(context).colorScheme.secondary,
      ),
      onTap: () async {
        if (isDatePicker) {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
            helpText:
                AppLocalizations.of(context)!.custom_picker_field_date_text,
            builder: (context, child) => Theme(
              data: themeNotifier.currentTheme,
              child: child!,
            ),
          );

          if (pickedDate != null && context.mounted) {
            TimeOfDay? pickedTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
              helpText:
                  AppLocalizations.of(context)!.custom_picker_field_time_text,
              builder: (context, child) => Theme(
                data: themeNotifier.currentTheme,
                child: child!,
              ),
            );

            if (pickedTime != null) {
              final dateTime = DateTime(
                pickedDate.year,
                pickedDate.month,
                pickedDate.day,
                pickedTime.hour,
                pickedTime.minute,
              );

              controller.text = _convertToCustomFormat(dateTime);
            }
          }
        } else {
          TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
            builder: (context, child) => Theme(
              data: themeNotifier.currentTheme,
              child: child!,
            ),
          );

          if (pickedTime != null) {
            final now = DateTime.now();
            final dateTime = DateTime(
              now.year,
              now.month,
              now.day,
              pickedTime.hour,
              pickedTime.minute,
            );
            controller.text = _convertToCustomFormat(dateTime);
          }
        }
      },
    );
  }

  String _convertToCustomFormat(DateTime dateTime) {
    return '${dateTime.year.toString().padLeft(4, '0')}-'
        '${dateTime.month.toString().padLeft(2, '0')}-'
        '${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
