// QRation â€” Copyright Â© 2026 Nicola De Nicolais â€” All Rights Reserved.
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
import 'package:get/get.dart';
import 'package:qration/core/theme/app_radius.dart';
import 'package:qration/core/utils/code_type_text.dart';
import 'package:qration/core/widgets/app_delete_dialog.dart';
import 'package:qration/core/widgets/app_toast.dart';
import 'package:qration/core/widgets/code_list_tile.dart';
import 'package:qration/features/codes/controllers/code_details_controller.dart';
import 'package:qration/features/codes/models/code_model.dart';
import 'package:qration/features/codes/widgets/code_details/code_action_buttons.dart';
import 'package:qration/features/codes/widgets/code_details/code_content_card.dart';
import 'package:qration/features/codes/widgets/code_details/code_details_app_bar.dart';
import 'package:qration/features/codes/widgets/code_details/code_qr_card.dart';

class CodeDetailsScreen extends StatefulWidget {
  final CodeModel code;

  const CodeDetailsScreen({
    super.key,
    required this.code,
  });

  @override
  CodeDetailsScreenState createState() => CodeDetailsScreenState();
}

class CodeDetailsScreenState extends State<CodeDetailsScreen> {
  late final CodeDetailsController _controller;
  late CodeTypeText _contentType;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<CodeDetailsController>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _contentType = CodeTypeText.fromBarcodeType(
      widget.code.barcode.type,
      widget.code.barcode.rawValue ?? '',
      AppLocalizations.of(context)!,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: CodeDetailsAppBar(
        onEditNotes: _showNotesBottomSheet,
        onDelete: _confirmDeleteCode,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: GestureDetector(
          // Only dismisses the keyboard: not an action for screen readers.
          excludeFromSemantics: true,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 16,
                  children: [
                    CodeInfoRow(
                      dateLabel: l10n.code_details_screen_date_title,
                      date: widget.code.date.toString(),
                      typeLabel: l10n.code_details_screen_type_title,
                      typeIcon: _controller.contentIcon.icon,
                      typeContent: _contentType.type,
                      typeIconHeroTag: codeIconHeroTag(widget.code.id),
                    ),
                    CodeQrSection(
                      title: l10n.code_details_screen_title_title,
                      code: widget.code,
                      screenshotController: _controller.screenshotController,
                    ),
                    CodeActionButtons(
                      controller: _controller,
                      onCopy: () => _copyToClipboard(
                          context, widget.code.barcode.rawValue ?? ''),
                      onSave: _saveQRCode,
                    ),
                    CodeContentCard(
                      title: l10n.code_details_screen_content_title,
                      code: widget.code,
                      controller: _controller,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String content) {
    _controller.copyToClipboard(content);
    if (mounted) {
      showSuccessToast(
        context,
        AppLocalizations.of(context)!.code_details_screen_result_copy,
      );
    }
  }

  Future<void> _saveQRCode() async {
    final result = await _controller.saveQRCode();
    if (!mounted) return;

    switch (result) {
      case SaveQrResult.success:
        showSuccessToast(
          context,
          AppLocalizations.of(context)!.code_details_screen_toast_success,
        );
        break;
      case SaveQrResult.emptyImage:
      case SaveQrResult.error:
        showErrorToast(
          context,
          AppLocalizations.of(context)!.code_details_screen_toast_error,
        );
        break;
    }
  }

  void _showNotesBottomSheet() {
    final notesController = TextEditingController(text: widget.code.notes);
    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.dialog),
        ),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            0,
            20,
            MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.code_details_screen_notes_title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 12),
              TextField(
                controller: notesController,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!
                      .code_details_screen_notes_hint,
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 5,
                maxLength: 160,
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      AppLocalizations.of(context)!
                          .code_details_screen_notes_cancel,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: colorScheme.primary,
                          ),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      await _controller.updateNotes(notesController.text);
                      if (context.mounted) Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      // Overrides the app theme's minimumSize(double.infinity, 52):
                      // inside a Row the child gets unbounded width constraints,
                      // and an infinite minimumSize width crashes layout.
                      minimumSize: Size(88, 44),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!
                          .code_details_screen_notes_save,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ).then((_) => notesController.dispose());
  }

  void _confirmDeleteCode() {
    AppDeleteDialog.show(
      context: context,
      title: AppLocalizations.of(context)!.code_details_screen_delete_title,
      message:
          AppLocalizations.of(context)!.code_details_screen_delete_description,
      onConfirm: () async {
        await _controller.deleteCode();
        if (mounted) {
          showSuccessToast(
            context,
            AppLocalizations.of(context)!
                .code_details_screen_delete_toast_success,
          );
        }
        Get.back();
      },
    );
  }
}
