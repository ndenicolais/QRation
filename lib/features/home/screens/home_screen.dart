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
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:qration/core/widgets/app_changelog_dialog.dart';
import 'package:qration/features/codes/screens/code_create_types_screen.dart';
import 'package:qration/features/codes/screens/code_scanner_screen.dart';
import 'package:qration/features/favorites/screens/favorites_screen.dart';
import 'package:qration/features/history/screens/history_screen.dart';
import 'package:qration/features/settings/screens/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Scanner tab is first: the app should be immediately usable to scan on open.
  int _selectedIndex = _scanTab;

  static const _scanTab = 0;
  static const _createTab = 1;

  void _goToTab(int index) => setState(() => _selectedIndex = index);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) AppChangelogDialog.maybeShow(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final pages = [
      ScannerScreen(isActive: _selectedIndex == _scanTab),
      CodeCreateTypesScreen(),
      FavoritesScreen(onCreateCode: () => _goToTab(_createTab)),
      HistoryScreen(onScanNow: () => _goToTab(_scanTab)),
      const SettingsScreen(),
    ];

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          // Offstage tabs keep their widgets alive: disable their heroes so
          // the same code shown in two tabs never duplicates a Hero tag.
          children: [
            for (var i = 0; i < pages.length; i++)
              HeroMode(enabled: i == _selectedIndex, child: pages[i]),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
                blurRadius: 18,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: NavigationBar(
            height: 68,
            selectedIndex: _selectedIndex,
            onDestinationSelected: _goToTab,
            destinations: [
              NavigationDestination(
                icon: const Icon(MingCuteIcons.mgc_scan_2_line, size: 20),
                selectedIcon:
                    const Icon(MingCuteIcons.mgc_scan_2_fill, size: 21),
                label: l10n.bottom_nav_item_scan,
              ),
              NavigationDestination(
                icon: const Icon(MingCuteIcons.mgc_qrcode_line, size: 20),
                selectedIcon:
                    const Icon(MingCuteIcons.mgc_qrcode_fill, size: 21),
                label: l10n.bottom_nav_item_create,
              ),
              NavigationDestination(
                icon: const Icon(MingCuteIcons.mgc_heart_line, size: 20),
                selectedIcon:
                    const Icon(MingCuteIcons.mgc_heart_fill, size: 21),
                label: l10n.bottom_nav_item_favorites,
              ),
              NavigationDestination(
                icon: const Icon(MingCuteIcons.mgc_history_line, size: 20),
                selectedIcon:
                    const Icon(MingCuteIcons.mgc_history_fill, size: 21),
                label: l10n.bottom_nav_item_history,
              ),
              NavigationDestination(
                icon: const Icon(MingCuteIcons.mgc_settings_5_line, size: 20),
                selectedIcon:
                    const Icon(MingCuteIcons.mgc_settings_5_fill, size: 21),
                label: l10n.bottom_nav_item_settings,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
