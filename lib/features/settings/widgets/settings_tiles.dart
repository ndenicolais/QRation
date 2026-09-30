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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:qration/core/theme/app_fonts.dart';

/// Titled card grouping the tiles of one Settings section.
class SettingsGroup extends StatelessWidget {
  const SettingsGroup({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppFonts.montserrat(
            fontSize: 18.sp,
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
        Card(
          color: theme.cardTheme.color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
            side: BorderSide(
              color: theme.colorScheme.outline,
              width: 1.w,
            ),
          ),
          margin: EdgeInsets.only(top: 8.r),
          child: Column(children: children),
        ),
      ],
    );
  }
}

/// Tile opening another screen or triggering an action.
class SettingsNavTile extends StatelessWidget {
  const SettingsNavTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(icon, color: colorScheme.primary),
      title: _TileTitle(title),
      subtitle: subtitle != null ? _TileSubtitle(subtitle!) : null,
      trailing: Icon(
        MingCuteIcons.mgc_right_fill,
        color: colorScheme.onSurfaceVariant,
      ),
      onTap: onTap,
    );
  }
}

/// Tile with an on/off switch.
class SettingsSwitchTile extends StatelessWidget {
  const SettingsSwitchTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(icon, color: colorScheme.primary),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TileTitle(title),
          if (subtitle != null)
            Padding(
              padding: EdgeInsets.only(top: 4.r),
              child: _TileSubtitle(subtitle!),
            ),
        ],
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: colorScheme.tertiary,
        activeTrackColor: colorScheme.secondary,
        inactiveThumbColor: colorScheme.secondary,
        inactiveTrackColor: colorScheme.primary,
      ),
    );
  }
}

/// Tile with a title and a horizontally scrollable segmented choice.
class SettingsSegmentedTile<T> extends StatelessWidget {
  const SettingsSegmentedTile({
    super.key,
    required this.icon,
    required this.title,
    required this.segments,
    required this.selected,
    required this.onChanged,
    this.selectedBackgroundColor,
  });

  final IconData icon;
  final String title;
  final List<ButtonSegment<T>> segments;
  final T selected;
  final ValueChanged<T> onChanged;
  final Color? selectedBackgroundColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: colorScheme.primary, size: 20.r),
              SizedBox(width: 12.w),
              _TileTitle(title),
            ],
          ),
          SizedBox(height: 10.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SegmentedButton<T>(
              segments: segments,
              selected: {selected},
              showSelectedIcon: false,
              onSelectionChanged: (newSelection) =>
                  onChanged(newSelection.first),
              style: SegmentedButton.styleFrom(
                visualDensity: VisualDensity.compact,
                selectedBackgroundColor:
                    selectedBackgroundColor ?? colorScheme.primary,
                selectedForegroundColor: colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TileTitle extends StatelessWidget {
  const _TileTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppFonts.montserrat(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _TileSubtitle extends StatelessWidget {
  const _TileSubtitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppFonts.montserrat(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
