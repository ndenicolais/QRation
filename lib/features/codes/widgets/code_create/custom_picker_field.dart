// QRation — Copyright © 2026 Nicola De Nicolais — All Rights Reserved.
// Licensed under a source-available, non-commercial license. See LICENSE.
//
// Commercial use, including publishing or monetizing on any app store,
// requires explicit written permission from the copyright holder.
//
// Author: Nicola De Nicolais
// Contact: ndn21dev@gmail.com
// GitHub: https://github.com/ndenicolais

import 'package:flutter/material.dart';
import 'package:qration/l10n/app_localizations.dart';
import 'package:qration/core/theme/app_fonts.dart';

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
    return TextField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppFonts.montserrat(
          color: Theme.of(context).colorScheme.tertiary,
        ),
      ),
      style: AppFonts.montserrat(
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
          );

          if (pickedDate != null && context.mounted) {
            TimeOfDay? pickedTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
              helpText:
                  AppLocalizations.of(context)!.custom_picker_field_time_text,
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
