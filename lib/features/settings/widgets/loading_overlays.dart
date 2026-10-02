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
import 'package:qration/core/theme/app_fonts.dart';
import 'package:qration/core/widgets/app_loader.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: AppLoader());
  }
}

class FileLoadingIndicator extends StatelessWidget {
  const FileLoadingIndicator({super.key, required this.downloadProgress});

  final double downloadProgress;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(
                value: downloadProgress,
                strokeWidth: 4,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            Text(
              '${(downloadProgress * 100).toStringAsFixed(0)}%',
              style: AppFonts.montserrat(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FileLoadingOverlay extends StatelessWidget {
  const FileLoadingOverlay({super.key, required this.downloadProgress});

  final double downloadProgress;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.5),
      child: Center(
        child: FileLoadingIndicator(downloadProgress: downloadProgress),
      ),
    );
  }
}

class JsonLoadingOverlay extends StatelessWidget {
  const JsonLoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.5),
      child: const Center(child: LoadingIndicator()),
    );
  }
}
