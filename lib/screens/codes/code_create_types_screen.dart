import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qration/models/code_social_model.dart';
import 'package:qration/screens/codes/code_create_social_screen.dart';
import 'package:qration/screens/codes/code_create_standard_screen.dart';
import 'package:qration/utils/code_type_icon.dart';
import 'package:qration/utils/code_type_text.dart';
import 'package:qration/utils/constants.dart';

class CodeCreateTypesScreen extends StatelessWidget {
  final List<BarcodeType> barcodeTypes = AppConstants.customOrderedBarcodeTypes;
  final List<CodeSocial> socialCodes = AppConstants.socialCodesList;

  CodeCreateTypesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(30.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildSectionTitle(
                context,
                AppLocalizations.of(context)!.code_create_types_screen_standard,
              ),
              SizedBox(height: 20.h),
              _buildGridView(barcodeTypes, context, (barcodeType) {
                HapticFeedback.lightImpact();
                Get.to(
                  () => CodeCreateStandardScreen(type: barcodeType),
                  transition: Transition.fade,
                  duration: const Duration(milliseconds: 500),
                );
              }),
              _buildSectionTitle(
                context,
                AppLocalizations.of(context)!.code_create_types_screen_social,
              ),
              SizedBox(height: 20.h),
              _buildGridView(socialCodes, context, (social) {
                HapticFeedback.lightImpact();
                Get.to(
                  () => CodeCreateSocialScreen(socialMedia: social),
                  transition: Transition.fade,
                  duration: const Duration(milliseconds: 500),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
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
        AppLocalizations.of(context)!.code_create_types_screen_title,
        style: GoogleFonts.montserrat(
          color: Theme.of(context).colorScheme.secondary,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.secondary,
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: GoogleFonts.montserrat(
        color: Theme.of(context).colorScheme.tertiary,
        fontWeight: FontWeight.w600,
        fontSize: 18.sp,
      ),
    );
  }

  Widget _buildGridView<T>(
      List<T> items, BuildContext context, Function(T) onTap) {
    return Expanded(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 5 : 4,
          childAspectRatio: 1.r,
          crossAxisSpacing: 8.r,
          mainAxisSpacing: 8.r,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];

          return GestureDetector(
            onTap: () => onTap(item),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.secondary,
                  width: 2.w,
                ),
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Card(
                elevation: 0,
                color: Theme.of(context).colorScheme.primary,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        item is BarcodeType
                            ? CodeTypeIcon.fromBarcodeType(item, item.name).icon
                            : (item as CodeSocial).icon,
                        size: 28.sp,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      Text(
                        item is BarcodeType
                            ? CodeTypeText.fromBarcodeType(item, item.name).type
                            : (item as CodeSocial).name,
                        style: GoogleFonts.montserrat(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
