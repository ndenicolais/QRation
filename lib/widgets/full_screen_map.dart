import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:free_map/free_map.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:qration/theme/app_colors.dart';
import 'package:qration/utils/permission_helper.dart';
import 'package:qration/widgets/custom_loader.dart';

class FullScreenMap extends StatefulWidget {
  final Function(LatLng) onLocationPicked;

  const FullScreenMap({super.key, required this.onLocationPicked});

  @override
  FullScreenMapState createState() => FullScreenMapState();
}

class FullScreenMapState extends State<FullScreenMap> {
  bool _isLocationPermissionGranted = false;
  LatLng selectedLocation = const LatLng(41.9099533, 12.371192);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(),
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: _isLocationPermissionGranted
            ? Center(child: _buildLoadingIndicator())
            : _buildMap(),
        floatingActionButton: FloatingActionButton(
          foregroundColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          elevation: 0,
          onPressed: () {
            widget.onLocationPicked(selectedLocation);
            Get.back();
          },
          child: const Icon(
            MingCuteIcons.mgc_check_fill,
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    try {
      await requestLocationPermission(context);
      setState(() {
        _isLocationPermissionGranted = false;
      });
    } catch (e) {
      if (mounted) {
        Get.back();
      }
    }
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

  AppBar _buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          MingCuteIcons.mgc_large_arrow_left_fill,
          color: Theme.of(context).colorScheme.secondary,
        ),
        onPressed: () {
          Get.back();
        },
      ),
      title: Text(
        AppLocalizations.of(context)!.full_screen_map_title,
        style: GoogleFonts.montserrat(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.secondary,
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CustomLoader(
        width: 50.w,
        height: 50.h,
      ),
    );
  }
}
