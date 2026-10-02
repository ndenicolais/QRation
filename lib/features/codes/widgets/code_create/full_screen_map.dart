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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:free_map/free_map.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:qration/core/theme/app_colors.dart';

/// Map to pick the coordinates of a geo code by tapping a point. It needs no
/// location permission: the user's position is never read.
class FullScreenMap extends StatefulWidget {
  final Function(LatLng) onLocationPicked;

  const FullScreenMap({super.key, required this.onLocationPicked});

  @override
  FullScreenMapState createState() => FullScreenMapState();
}

class FullScreenMapState extends State<FullScreenMap> {
  LatLng selectedLocation = const LatLng(41.9099533, 12.371192);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Colors and title style come from the theme appBarTheme.
      appBar: AppBar(
        leading: IconButton(
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          icon: const Icon(MingCuteIcons.mgc_large_arrow_left_fill),
          onPressed: Get.back,
        ),
        title: Text(AppLocalizations.of(context)!.full_screen_map_title),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _buildMap(),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        onPressed: () {
          widget.onLocationPicked(selectedLocation);
          Get.back();
        },
        child: const Icon(MingCuteIcons.mgc_check_fill),
      ),
    );
  }

  Widget _buildMap() {
    return FmMap(
      mapOptions: MapOptions(
        initialCenter: selectedLocation,
        initialZoom: 5.5.r,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
        ),
        onTap: (tapPosition, point) {
          setState(() {
            selectedLocation = point;
          });
        },
      ),
      markers: [
        Marker(
          width: 60.w,
          height: 60.h,
          point: selectedLocation,
          child: Icon(
            MingCuteIcons.mgc_location_fill,
            color: AppColors.qrMarkerColor,
            size: 34.sp,
          ),
        ),
      ],
    );
  }
}
