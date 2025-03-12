import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qration/models/code_model.dart';
import 'package:qration/models/code_social_model.dart';
import 'package:qration/services/codes_service.dart';
import 'package:qration/screens/codes/code_details_screen.dart';
import 'package:qration/utils/code_type_body.dart';
import 'package:qration/utils/code_type_icon.dart';
import 'package:qration/utils/constants.dart';
import 'package:qration/widgets/custom_delete_dialog.dart';
import 'package:qration/widgets/custom_loader.dart';
import 'package:qration/widgets/custom_toast.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  HistoryScreenState createState() => HistoryScreenState();
}

class HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  final CodesService _codesService = CodesService();
  late List<CodeModel> historyCodes = [];
  late AnimationController _loadingController;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String searchKeyword = '';
  bool _isSelecting = false;
  bool _isLoading = false;
  List<BarcodeType> selectedStandardTypes = [];
  final Set<String> selectedSocialTypes = {};
  CodeSource? selectedSource;
  late List<CodeModel> filteredCodes;
  CodeTypeIcon getContentIcon(BarcodeType type, String rawValue) {
    return CodeTypeIcon.fromBarcodeType(type, rawValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildSearchBar(context),
                SizedBox(height: 10.h),
                _buildStandardFilterOptions(),
                _buildSocialFilterOptions(),
                _buildCodesList(context),
              ],
            ),
            if (_isLoading)
              Positioned.fill(
                child: _buildDeleteLoading(context),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadingController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();

    _searchController.addListener(() {
      setState(() {
        searchKeyword = _searchController.text;
      });
    });
  }

  void _filterDrawerCodes() {
    setState(() {
      if (selectedSource == null) {
        filteredCodes = List.from(historyCodes);
      } else {
        filteredCodes = historyCodes
            .where((code) => code.source == selectedSource)
            .toList();
      }
    });
  }

  void _resetFocus() {
    setState(() {
      searchKeyword = '';
      _searchController.clear();
      _searchFocusNode.unfocus();
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }

  @override
  void dispose() {
    _loadingController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CustomLoader(
        width: 50.w,
        height: 50.h,
      ),
    );
  }

  Widget _buildDeleteLoading(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.5),
      child: Center(child: _buildLoadingIndicator()),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.r),
      child: Row(
        children: [
          if (_isSelecting)
            IconButton(
              icon: Icon(
                MingCuteIcons.mgc_close_fill,
                color: Theme.of(context).colorScheme.secondary,
              ),
              onPressed: () {
                setState(() {
                  _isSelecting = false;
                  selectedSocialTypes.clear();
                });
              },
            ),
          Expanded(
            child: TextField(
              controller: _searchController,
              onTapOutside: (event) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              style: GoogleFonts.montserrat(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 14.sp,
              ),
              cursorColor: Theme.of(context).colorScheme.tertiary,
              onChanged: (value) {
                setState(() {
                  searchKeyword = value.trim().toLowerCase();
                });
              },
              decoration: InputDecoration(
                prefixIcon: Icon(
                  MingCuteIcons.mgc_search_2_fill,
                  size: 18.sp,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        onPressed: () {
                          setState(() {
                            _resetFocus();
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
                labelText:
                    AppLocalizations.of(context)!.history_screen_search_label,
                labelStyle: GoogleFonts.montserrat(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontSize: 14.sp,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              MingCuteIcons.mgc_filter_fill,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: () {
              _openFilterDrawer(context);
            },
          ),
          _buildDeleteButton(context),
        ],
      ),
    );
  }

  void _openFilterDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.primary,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(
                MingCuteIcons.mgc_rows_4_line,
                color: Theme.of(context).colorScheme.secondary,
              ),
              title: Text(
                AppLocalizations.of(context)!.history_screen_filter_all,
                style: GoogleFonts.montserrat(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 14.sp,
                ),
              ),
              onTap: () {
                setState(() {
                  selectedSource = null;
                  _filterDrawerCodes();
                });
                Get.back();
              },
            ),
            ListTile(
              leading: Icon(
                MingCuteIcons.mgc_qrcode_line,
                color: Theme.of(context).colorScheme.secondary,
              ),
              title: Text(
                AppLocalizations.of(context)!.history_screen_filter_created,
                style: GoogleFonts.montserrat(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 14.sp,
                ),
              ),
              onTap: () {
                setState(() {
                  selectedSource = CodeSource.created;
                  _filterDrawerCodes();
                });
                Get.back();
              },
            ),
            ListTile(
              leading: Icon(
                MingCuteIcons.mgc_scan_line,
                color: Theme.of(context).colorScheme.secondary,
              ),
              title: Text(
                AppLocalizations.of(context)!.history_screen_filter_scanned,
                style: GoogleFonts.montserrat(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 14.sp,
                ),
              ),
              onTap: () {
                setState(() {
                  selectedSource = CodeSource.scanned;
                  _filterDrawerCodes();
                });
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return StreamBuilder<List<CodeModel>>(
      stream: _codesService.getCodesStream(),
      builder: (context, snapshot) {
        bool isDisabled = !snapshot.hasData || snapshot.data!.isEmpty;
        return IconButton(
          icon: Icon(
            MingCuteIcons.mgc_delete_3_fill,
            color: isDisabled
                ? Theme.of(context).colorScheme.secondary.withAlpha(100)
                : Theme.of(context).colorScheme.secondary,
          ),
          onPressed: isDisabled
              ? null
              : () {
                  _showDeleteConfirmationDialog(context);
                },
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDeleteDialog(
          title: AppLocalizations.of(context)!.history_screen_delete_title,
          content:
              AppLocalizations.of(context)!.history_screen_delete_description,
          onCancelPressed: () {
            Get.back();
          },
          onConfirmPressed: () async {
            Get.back();
            setState(() {
              _isLoading = true;
            });
            await _codesService.deleteAllCodes();
            setState(() {
              _isLoading = false;
            });
            if (context.mounted) {
              showSuccessToast(
                context,
                AppLocalizations.of(context)!
                    .history_screen_delete_toast_success,
              );
            }
          },
        );
      },
    );
  }

  Widget _buildStandardFilterOptions() {
    final List<BarcodeType> barcodeTypes =
        AppConstants.customOrderedBarcodeTypes;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: barcodeTypes.map((type) {
              CodeTypeIcon contentIcon = CodeTypeIcon.fromBarcodeType(type, '');
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.r),
                child: FilterChip(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  selectedColor: Theme.of(context).colorScheme.tertiary,
                  label: Icon(
                    contentIcon.icon,
                    size: 18.sp,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  showCheckmark: false,
                  selected: selectedStandardTypes.contains(type),
                  onSelected: (isSelected) {
                    setState(() {
                      if (isSelected) {
                        selectedStandardTypes.add(type);
                      } else {
                        selectedStandardTypes.remove(type);
                      }
                    });
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialFilterOptions() {
    final List<CodeSocial> socialCodes = AppConstants.socialCodesList;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: socialCodes.map((social) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.r),
                child: FilterChip(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  selectedColor: Theme.of(context).colorScheme.tertiary,
                  label: Icon(
                    social.icon,
                    size: 18.sp,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  showCheckmark: false,
                  selected: selectedSocialTypes.contains(social.name),
                  onSelected: (isSelected) {
                    setState(() {
                      if (isSelected) {
                        selectedSocialTypes.add(social.name);
                      } else {
                        selectedSocialTypes.remove(social.name);
                      }
                    });
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context, Object? error) {
    return Center(
      child: SizedBox(
        width: 320.w,
        child: Text(
          '${AppLocalizations.of(context)!.history_screen_error_state} $error',
          style: GoogleFonts.montserrat(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: 18.sp,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 320.w,
        child: Text(
          AppLocalizations.of(context)!.history_screen_empty_state,
          style: GoogleFonts.montserrat(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 22.sp,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildCodesList(BuildContext context) {
    return StreamBuilder<List<CodeModel>>(
      stream: _codesService.getCodesStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !_isSelecting) {
          return _buildLoadingIndicator();
        }

        if (snapshot.hasError) {
          return _buildErrorState(context, snapshot.error);
        }

        List<CodeModel> historyCodes = snapshot.data ?? [];
        List<CodeModel> filteredCodes = _filterCodes(historyCodes);

        filteredCodes.sort((a, b) => b.date.compareTo(a.date));

        return Expanded(
          child: filteredCodes.isEmpty && !_isSelecting
              ? _buildEmptyState(context)
              : _buildCodesListView(filteredCodes, context),
        );
      },
    );
  }

  List<CodeModel> _filterCodes(List<CodeModel> historyCodes) {
    final Set<BarcodeType> combinedSelectedTypes =
        Set.from(selectedStandardTypes);
    final Set<String> combinedSelectedSocialTypes =
        Set.from(selectedSocialTypes);

    return historyCodes.where((code) {
      bool matchStandardTypeSelected =
          combinedSelectedTypes.contains(code.barcode.type);
      bool matchSocialTypeSelected =
          combinedSelectedSocialTypes.contains(code.socialMedia?.name);

      bool matchesSearchFilter = code.barcode.rawValue != null &&
          code.barcode.rawValue!
              .toLowerCase()
              .contains(searchKeyword.toLowerCase());
      bool matchesSourceFilter =
          selectedSource == null || code.source == selectedSource;

      return (combinedSelectedTypes.isEmpty &&
                  combinedSelectedSocialTypes.isEmpty ||
              matchStandardTypeSelected ||
              matchSocialTypeSelected) &&
          matchesSearchFilter &&
          matchesSourceFilter;
    }).toList();
  }

  Widget _buildCodesListView(
      List<CodeModel> filteredCodes, BuildContext context) {
    return ListView.builder(
      itemCount: filteredCodes.length,
      itemBuilder: (context, index) {
        final code = filteredCodes[index];
        final DateTime date = code.date;
        final String formattedDate =
            DateFormat('dd/MM/yyyy HH:mm').format(date);
        final barcode = code.barcode;
        final barcodeType = barcode.type;
        final rawValue = barcode.rawValue ?? '';
        final contentIcon = getContentIcon(barcodeType, rawValue);
        final contentFormatter = getContentBody(code);
        final displayContent = contentFormatter.formattedContent;

        return _buildCodeCard(
          context,
          code,
          formattedDate,
          contentIcon,
          displayContent,
        );
      },
    );
  }

  Widget _buildCodeCard(
    BuildContext context,
    CodeModel code,
    String formattedDate,
    CodeTypeIcon contentIcon,
    String displayContent,
  ) {
    return Card(
      color: Theme.of(context).colorScheme.primary,
      margin: EdgeInsets.symmetric(horizontal: 12.r, vertical: 8.r),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
          width: 1.w,
        ),
      ),
      child: ListTile(
        leading: Icon(
          contentIcon.icon,
          color: Theme.of(context).colorScheme.secondary,
        ),
        title: _buildCardTitle(context, code, displayContent),
        subtitle: Text(
          formattedDate,
          style: GoogleFonts.montserrat(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 12.sp,
          ),
        ),
        trailing: _buildCardTrailing(context, code),
      ),
    );
  }

  Widget _buildCardTitle(
    BuildContext context,
    CodeModel code,
    String displayContent,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          code.source.toString().split('.').last.capitalize!,
          style: GoogleFonts.montserrat(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          displayContent,
          style: GoogleFonts.montserrat(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 4.h),
      ],
    );
  }

  Widget _buildCardTrailing(BuildContext context, CodeModel code) {
    return IconButton(
      icon: Icon(MingCuteIcons.mgc_right_fill,
          color: Theme.of(context).colorScheme.secondary),
      onPressed: () {
        Get.to(
          () => CodeDetailsScreen(code: code),
          transition: Transition.fade,
          duration: const Duration(milliseconds: 500),
        );
      },
    );
  }
}
