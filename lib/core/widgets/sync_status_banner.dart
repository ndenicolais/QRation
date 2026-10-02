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
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:qration/core/theme/app_radius.dart';
import 'package:qration/features/codes/services/codes_repository.dart';
import 'package:qration/l10n/app_localizations.dart';

/// Slim banner shown above code lists while offline or while local changes
/// wait to be synced; collapses to nothing when [status] is synced.
class SyncStatusBanner extends StatelessWidget {
  const SyncStatusBanner({super.key, required this.status});

  final SyncStatus status;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      child: status == SyncStatus.synced
          ? const SizedBox(width: double.infinity)
          : _Banner(status: status),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({required this.status});

  final SyncStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final offline = status == SyncStatus.offline;

    return Padding(
      padding: EdgeInsets.fromLTRB(14, 8, 14, 0),
      child: Semantics(
        liveRegion: true,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
          child: Row(
            children: [
              Icon(
                offline
                    ? MingCuteIcons.mgc_wifi_off_line
                    : MingCuteIcons.mgc_upload_2_line,
                size: 18,
                color: colorScheme.primary,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  offline ? l10n.sync_status_offline : l10n.sync_status_pending,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Makes a non-scrollable [child] (e.g. an empty state) pullable, so
/// pull-to-refresh also works when a list has nothing to show.
class PullToRefreshFill extends StatelessWidget {
  const PullToRefreshFill({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverFillRemaining(hasScrollBody: false, child: child),
      ],
    );
  }
}
