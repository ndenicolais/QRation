import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as contacts;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:logger/logger.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qration/models/code_model.dart';
import 'package:qration/services/codes_service.dart';
import 'package:qration/models/code_types.dart';
import 'package:qration/utils/code_type_icon.dart';
import 'package:qration/utils/code_type_text.dart';
import 'package:qration/utils/permission_helper.dart';
import 'package:qration/widgets/custom_delete_dialog.dart';
import 'package:qration/widgets/custom_toast.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:wifi_iot/wifi_iot.dart';

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
  var logger = Logger();
  late CodeModel code;
  late CodeTypeIcon _contentIcon;
  late CodeTypeText _contentType;
  final CodesService _codesService = CodesService();
  bool _isExpanded = false;
  bool isCodeDeleted = false;
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  spacing: 12.h,
                  children: [
                    _buildCodeDate(
                        AppLocalizations.of(context)!
                            .code_details_screen_date_title,
                        code.date.toString()),
                    _buildCodeType(
                      AppLocalizations.of(context)!
                          .code_details_screen_type_title,
                      _contentIcon.icon,
                      _contentType.type,
                    ),
                    _buildCode(
                      AppLocalizations.of(context)!
                          .code_details_screen_title_title,
                    ),
                    _buildCodeContent(
                      AppLocalizations.of(context)!
                          .code_details_screen_content_title,
                      code.barcode.rawValue ?? '',
                    ),
                    SizedBox(height: 12.h),
                    _buildActionButtons(context)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    code = widget.code;
    final BarcodeType barcodeType = code.barcode.type;
    final String rawValue = code.barcode.rawValue ?? '';
    _contentIcon = CodeTypeIcon.fromBarcodeType(barcodeType, rawValue);
    _contentType = CodeTypeText.fromBarcodeType(barcodeType, rawValue);
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
        AppLocalizations.of(context)!.code_details_screen_title,
        style: GoogleFonts.montserrat(
          color: Theme.of(context).colorScheme.secondary,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.secondary,
      actions: [
        _buildPopupMenu(context, code),
      ],
    );
  }

  Widget _buildPopupMenu(BuildContext context, CodeModel code) {
    return PopupMenuButton<String>(
      color: Theme.of(context).colorScheme.primary,
      icon: Icon(
        MingCuteIcons.mgc_more_2_fill,
        color: Theme.of(context).colorScheme.secondary,
      ),
      onSelected: (value) {
        if (value == 'notes') {
          _showNotesDialog();
        } else if (value == 'delete') {
          _confirmDeleteCode(context, code);
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          _buildPopupMenuItem(
            context,
            'notes',
            MingCuteIcons.mgc_edit_4_fill,
            AppLocalizations.of(context)!.code_details_screen_menu_notes,
          ),
          _buildPopupMenuItem(
            context,
            'delete',
            MingCuteIcons.mgc_delete_3_fill,
            AppLocalizations.of(context)!.code_details_screen_menu_delete,
          ),
        ];
      },
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem(
    BuildContext context,
    String value,
    IconData icon,
    String text,
  ) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.secondary,
          ),
          SizedBox(width: 10.w),
          Text(
            text,
            style: GoogleFonts.montserrat(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeType(String title, IconData? icon, String content) {
    return Column(
      children: [
        Text(
          title,
          style: GoogleFonts.montserrat(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24.sp),
            SizedBox(width: 8.w),
            Text(
              content,
              style: GoogleFonts.montserrat(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 18.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCode(String title) {
    return Column(
      children: [
        Text(
          title,
          style: GoogleFonts.montserrat(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 4.h),
        _buildQRCode(code.barcode.rawValue ?? ''),
      ],
    );
  }

  Widget _buildQRCode(String content) {
    return SizedBox(
      width: 220.w,
      height: 220.h,
      child: Screenshot(
        controller: screenshotController,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImageView(
              data: content,
              size: 220.sp,
              backgroundColor: Colors.white,
              version: QrVersions.auto,
              errorCorrectionLevel: QrErrorCorrectLevel.M,
              eyeStyle: QrEyeStyle(
                eyeShape: widget.code.eyeRounded == 1
                    ? QrEyeShape.circle
                    : QrEyeShape.square,
                color: widget.code.eyeColor,
              ),
              dataModuleStyle: QrDataModuleStyle(
                dataModuleShape: widget.code.moduleRounded == 1
                    ? QrDataModuleShape.circle
                    : QrDataModuleShape.square,
                color: widget.code.moduleColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeContent(String title, String content) {
    return Column(
      children: [
        Text(
          title,
          style: GoogleFonts.montserrat(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        _buildContentWidget(),
      ],
    );
  }

  Widget _buildContentWidget() {
    final barcode = widget.code.barcode;

    switch (barcode.type) {
      case BarcodeType.text:
        return _buildCard(
          content: Text(
            barcode.rawValue ?? '',
            style: GoogleFonts.montserrat(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 16.sp,
            ),
            textAlign: TextAlign.center,
            maxLines: _isExpanded ? null : 3,
            overflow:
                _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          ),
          buttonText:
              AppLocalizations.of(context)!.code_details_screen_action_text,
          buttonIcon: MingCuteIcons.mgc_copy_2_line,
          onButtonPressed: () =>
              _copyToClipboard(context, barcode.rawValue ?? ''),
        );

      case BarcodeType.url:
        return _buildCard(
          content: Text(
            CodeUrl.fromRawValue(barcode.rawValue ?? '').displayValue,
            style: GoogleFonts.montserrat(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 16.sp,
            ),
            textAlign: TextAlign.center,
            maxLines: _isExpanded ? null : 3,
            overflow:
                _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          ),
          buttonText:
              AppLocalizations.of(context)!.code_details_screen_action_url,
          buttonIcon: MingCuteIcons.mgc_external_link_line,
          onButtonPressed: () => _launchURL(barcode.rawValue ?? ''),
        );

      case BarcodeType.email:
        CodeEmail email = CodeEmail.fromRawValue(barcode.rawValue ?? '');
        return _buildCard(
          content: Column(
            children: [
              Text(
                email.address,
                style: GoogleFonts.montserrat(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 16.sp,
                ),
              ),
              if (email.subject != null && email.subject!.isNotEmpty)
                Text(
                  email.subject!,
                  style: GoogleFonts.montserrat(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 16.sp,
                  ),
                ),
              if (email.body != null && email.body!.isNotEmpty)
                Text(
                  email.body!,
                  style: GoogleFonts.montserrat(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 16.sp,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: _isExpanded ? null : 3,
                  overflow: _isExpanded
                      ? TextOverflow.visible
                      : TextOverflow.ellipsis,
                ),
            ],
          ),
          buttonText:
              AppLocalizations.of(context)!.code_details_screen_action_email,
          buttonIcon: MingCuteIcons.mgc_mail_send_line,
          onButtonPressed: () =>
              _sendEmail(email.address, email.subject, email.body),
        );

      case BarcodeType.phone:
        CodePhoneNumber phoneNumber =
            CodePhoneNumber.fromRawValue(barcode.rawValue ?? '');
        return _buildCard(
          content: Text(
            phoneNumber.number,
            style: GoogleFonts.montserrat(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 16.sp,
            ),
          ),
          buttonText:
              AppLocalizations.of(context)!.code_details_screen_action_phone,
          buttonIcon: MingCuteIcons.mgc_phone_call_line,
          onButtonPressed: () => _makePhoneCall(phoneNumber.number),
        );

      case BarcodeType.sms:
        CodeSms sms = CodeSms.fromRawValue(barcode.rawValue ?? '');
        return _buildCard(
          content: Column(
            children: [
              Text(
                sms.phoneNumber,
                style: GoogleFonts.montserrat(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 16.sp,
                ),
              ),
              Text(
                sms.message,
                style: GoogleFonts.montserrat(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 16.sp,
                ),
                textAlign: TextAlign.center,
                maxLines: _isExpanded ? null : 3,
                overflow:
                    _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
              ),
            ],
          ),
          buttonText:
              AppLocalizations.of(context)!.code_details_screen_action_sms,
          buttonIcon: MingCuteIcons.mgc_chat_1_line,
          onButtonPressed: () => sendSms(sms.phoneNumber, sms.message),
        );

      case BarcodeType.contactInfo:
        CodeContact contact = CodeContact.fromRawValue(barcode.rawValue ?? '');
        return _buildCard(
          content: Column(
            children: [
              Text(
                '${contact.name} ${contact.surname}',
                style: GoogleFonts.montserrat(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 16.sp,
                ),
              ),
              if (contact.phoneNumber.isNotEmpty)
                Text(
                  contact.phoneNumber,
                  style: GoogleFonts.montserrat(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 16.sp,
                  ),
                ),
              if (contact.email.isNotEmpty)
                Text(
                  contact.email,
                  style: GoogleFonts.montserrat(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 16.sp,
                  ),
                ),
            ],
          ),
          buttonText:
              AppLocalizations.of(context)!.code_details_screen_action_contact,
          buttonIcon: MingCuteIcons.mgc_user_add_2_line,
          onButtonPressed: () => addContact(contact.name, contact.surname,
              contact.phoneNumber, contact.email),
        );

      case BarcodeType.geo:
        CodeGeo geoInfo = CodeGeo.fromRawValue(barcode.rawValue ?? '');
        return _buildCard(
          content: Column(
            children: [
              Text(
                geoInfo.latitude.toString(),
                style: GoogleFonts.montserrat(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 16.sp,
                ),
              ),
              Text(
                geoInfo.longitude.toString(),
                style: GoogleFonts.montserrat(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
          buttonText:
              AppLocalizations.of(context)!.code_details_screen_action_geo,
          buttonIcon: MingCuteIcons.mgc_map_line,
          onButtonPressed: () => _openMap(geoInfo.latitude, geoInfo.longitude),
        );

      case BarcodeType.wifi:
        CodeWifi wifiInfo = CodeWifi.fromRawValue(barcode.rawValue ?? '');
        return _buildCard(
          content: Column(
            children: [
              Text(
                wifiInfo.ssid,
                style: GoogleFonts.montserrat(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 16.sp,
                ),
              ),
              Text(
                wifiInfo.password,
                style: GoogleFonts.montserrat(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 16.sp,
                ),
              ),
              Text(
                wifiInfo.authenticationType,
                style: GoogleFonts.montserrat(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 16.sp,
                ),
              ),
              Text(
                wifiInfo.hidden.toString(),
                style: GoogleFonts.montserrat(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
          buttonText:
              AppLocalizations.of(context)!.code_details_screen_action_wifi,
          buttonIcon: MingCuteIcons.mgc_wifi_line,
          onButtonPressed: () =>
              _connectToWifi(wifiInfo.ssid, wifiInfo.password),
        );

      case BarcodeType.calendarEvent:
        CodeEvent eventInfo = CodeEvent.fromRawValue(barcode.rawValue ?? '');
        return _buildCard(
          content: Text(
            eventInfo.toString(),
            style: GoogleFonts.montserrat(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 16.sp,
            ),
          ),
          buttonText:
              AppLocalizations.of(context)!.code_details_screen_action_calendar,
          buttonIcon: MingCuteIcons.mgc_calendar_add_line,
          onButtonPressed: () => _addEventToCalendar(eventInfo.toRawValue()),
        );

      case BarcodeType.product:
        CodeProduct productInfo =
            CodeProduct.fromRawValue(barcode.rawValue ?? '');
        return _buildCard(
          content: Column(
            children: [
              Text(
                AppLocalizations.of(context)!.code_details_screen_product,
                style: GoogleFonts.montserrat(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                productInfo.toString(),
                style: GoogleFonts.montserrat(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
          buttonText:
              AppLocalizations.of(context)!.code_details_screen_action_product,
          buttonIcon: MingCuteIcons.mgc_list_search_line,
          onButtonPressed: () => _searchProductOnline(productInfo.barcode),
        );

      case BarcodeType.isbn:
        CodeISBN isbnInfo = CodeISBN.fromRawValue(barcode.rawValue ?? '');
        return _buildCard(
          content: Column(
            children: [
              Text(
                AppLocalizations.of(context)!.code_details_screen_isbn,
                style: GoogleFonts.montserrat(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                isbnInfo.toString(),
                style: GoogleFonts.montserrat(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
          buttonText:
              AppLocalizations.of(context)!.code_details_screen_action_isbn,
          buttonIcon: MingCuteIcons.mgc_book_2_line,
          onButtonPressed: () => _searchBookOnline(isbnInfo.isbn),
        );

      default:
        return SelectableText(
          barcode.rawValue ?? '',
          style: GoogleFonts.montserrat(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 18.sp,
          ),
        );
    }
  }

  Widget _buildCard({
    required Widget content,
    required String buttonText,
    required IconData buttonIcon,
    required VoidCallback onButtonPressed,
  }) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.symmetric(horizontal: 28.r),
      color: Theme.of(context).colorScheme.primary,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 28.r, vertical: 8.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            content,
            if ((widget.code.barcode.rawValue?.length ?? 0) > 200)
              IconButton(
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                icon: Icon(
                  _isExpanded
                      ? MingCuteIcons.mgc_arrows_up_line
                      : MingCuteIcons.mgc_arrows_down_line,
                  color: Theme.of(context).colorScheme.secondary,
                  size: 30.sp,
                ),
              ),
            SizedBox(height: 10.h),
            SizedBox(
              width: 140.w,
              height: 60.h,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                  foregroundColor: Theme.of(context).colorScheme.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                onPressed: onButtonPressed,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      buttonIcon,
                      color: Theme.of(context).colorScheme.secondary,
                      size: 28.sp,
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      buttonText,
                      style: GoogleFonts.montserrat(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeDate(String title, String date) {
    DateTime? parsedDate;
    try {
      parsedDate = DateTime.parse(date);
    } catch (e) {
      parsedDate = null;
    }

    final formattedDate = parsedDate != null
        ? DateFormat('yyyy-MM-dd HH:mm').format(parsedDate)
        : date;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: GoogleFonts.montserrat(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          formattedDate,
          style: GoogleFonts.montserrat(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 18.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    VoidCallback onPressed,
    String heroTag,
  ) {
    return SizedBox(
      width: 52.w,
      height: 52.h,
      child: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        heroTag: heroTag,
        onPressed: onPressed,
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(
          context,
          MingCuteIcons.mgc_copy_fill,
          () {
            _copyToClipboard(context, code.barcode.rawValue ?? '');
          },
          "btnCopy",
        ),
        _buildActionButton(
          context,
          code.isFavorite ? Icons.favorite : Icons.favorite_border,
          _toggleFavorite,
          "btnFavorites",
        ),
        _buildActionButton(
          context,
          MingCuteIcons.mgc_download_2_fill,
          () async {
            await _saveQRCode();
          },
          "btnSave",
        ),
        _buildActionButton(
          context,
          MingCuteIcons.mgc_share_2_fill,
          () {
            Share.share(code.barcode.rawValue ?? '');
          },
          "btnShare",
        ),
      ],
    );
  }

  void _toggleFavorite() {
    setState(() {
      code.isFavorite = !code.isFavorite;
    });
    _codesService.toggleFavoriteStatus(code.id, code.isFavorite);
  }

  Future<void> _saveQRCode() async {
    try {
      final image = await screenshotController.capture();

      if (image != null) {
        Uint8List pngBytes = image;

        String timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
        final result = await ImageGallerySaverPlus.saveImage(
          pngBytes,
          name: "qration_$timestamp",
          quality: 100,
        );

        if (result['isSuccess']) {
          if (mounted) {
            showSuccessToast(
              context,
              AppLocalizations.of(context)!.code_details_screen_toast_success,
            );
          }
        } else {
          if (mounted) {
            showErrorToast(
              context,
              AppLocalizations.of(context)!.code_details_screen_toast_error,
            );
          }
        }
      } else {
        if (mounted) {
          showErrorToast(
            context,
            AppLocalizations.of(context)!.code_details_screen_toast_error,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        showErrorToast(
          context,
          AppLocalizations.of(context)!.code_details_screen_toast_error,
        );
      }
    }
  }

  void _copyToClipboard(BuildContext context, String content) {
    Clipboard.setData(ClipboardData(text: content));
    if (mounted) {
      showSuccessToast(
        context,
        AppLocalizations.of(context)!.code_details_screen_result_copy,
      );
    }
  }

  void _showNotesDialog() {
    TextEditingController notesController =
        TextEditingController(text: widget.code.notes);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title: Text(
            AppLocalizations.of(context)!.code_details_screen_notes_title,
            style: GoogleFonts.montserrat(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: TextField(
            controller: notesController,
            decoration: InputDecoration(
              hintText:
                  AppLocalizations.of(context)!.code_details_screen_notes_hint,
              hintStyle: GoogleFonts.montserrat(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 14.sp,
              ),
            ),
            style: GoogleFonts.montserrat(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 14.sp,
            ),
            maxLines: 5,
            maxLength: 160,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Get.back();
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                  Theme.of(context).colorScheme.tertiary,
                ),
              ),
              child: Text(
                AppLocalizations.of(context)!.code_details_screen_notes_cancel,
                style: GoogleFonts.montserrat(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 14.sp,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                await _codesService.updateCodeNotes(
                  widget.code.id,
                  notesController.text,
                );
                setState(() {
                  widget.code.notes = notesController.text;
                });
                Get.back();
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
              child: Text(
                AppLocalizations.of(context)!.code_details_screen_notes_save,
                style: GoogleFonts.montserrat(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteCode(BuildContext context, CodeModel code) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDeleteDialog(
          title: AppLocalizations.of(context)!.code_details_screen_delete_title,
          content: AppLocalizations.of(context)!
              .code_details_screen_delete_description,
          onCancelPressed: () {
            Get.back();
          },
          onConfirmPressed: () {
            _codesService.deleteCode(code.id);
            showSuccessToast(
              context,
              AppLocalizations.of(context)!
                  .code_details_screen_delete_toast_success,
            );
            setState(() {
              isCodeDeleted = true;
            });
            Get.back();
            Get.back();
          },
        );
      },
    );
  }

  void _launchURL(String url) async {
    Uri uri;

    if (url.startsWith('spotify:search:')) {
      uri = Uri.parse('https://open.spotify.com/${url.substring(8)}');
    } else if (url.startsWith('whatsapp:') || url.startsWith('spotify:')) {
      uri = Uri.parse(url);
    } else {
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        url = 'http://$url';
      }
      uri = Uri.parse(url);
    }

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        showErrorToast(context,
            AppLocalizations.of(context)!.code_details_screen_toast_error_link);
      }
    }
  }

  Future<void> _sendEmail(String email, String? subject, String? body) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: (subject != null
              ? 'subject=${Uri.encodeComponent(subject)}'
              : '') +
          (body != null
              ? '${subject != null ? '&' : ''}body=${Uri.encodeComponent(body)}'
              : ''),
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        throw Exception('Could not launch $emailUri');
      }
    } catch (e) {
      throw ('Error: $e');
    }
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $launchUri';
    }
  }

  Future<void> sendSms(String phoneNumber, String? message) async {
    final Uri smsUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: message != null ? {'body': message} : null,
    );

    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      throw ('Could not launch SMS: $smsUri');
    }
  }

  Future<void> addContact(
      String name, String surname, String phoneNumber, String email) async {
    try {
      await requestContactsPermission(context);
      final contact = contacts.Contact()
        ..name.first = name
        ..name.last = surname
        ..phones = [contacts.Phone(phoneNumber)];

      if (email.isNotEmpty) {
        contact.emails = [contacts.Email(email)];
      }

      try {
        await contacts.FlutterContacts.insertContact(contact);
        if (mounted) {
          showSuccessToast(context,
              AppLocalizations.of(context)!.code_details_screen_result_contact);
        }
      } catch (e) {
        logger.e('Error while adding contact: $e');
      }
    } catch (e) {
      logger.e('Error while requesting permissions: $e');
    }
  }

  void _openMap(String latitude, String longitude) async {
    final String url =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _connectToWifi(String ssid, String password) async {
    logger.i('Trying to connect to WiFi');
    logger.i('SSID: $ssid, Password: $password');

    try {
      bool result = await WiFiForIoTPlugin.findAndConnect(
        ssid,
        password: password,
        joinOnce: false,
        withInternet: true,
      );
      if (mounted) {
        showSuccessToast(context,
            AppLocalizations.of(context)!.code_details_screen_result_wifi);
      }

      if (result) {
        logger.i('Connected to $ssid');
      } else {
        logger.e('Error connecting to $ssid: Connection failed.');
      }
    } catch (e) {
      logger.e('Error connecting to WiFi: $e');
    }
  }

  void _addEventToCalendar(String rawValue) {
    String title = '';
    String startDate = '';
    String endDate = '';
    String location = '';
    List<String> lines = rawValue.split('\n');
    for (String line in lines) {
      if (line.startsWith('SUMMARY:')) {
        title = line.replaceFirst('SUMMARY:', '').trim();
      } else if (line.startsWith('DTSTART:')) {
        String datetime = line.replaceFirst('DTSTART:', '').trim();
        startDate = convertToCustomFormat(datetime);
      } else if (line.startsWith('DTEND:')) {
        String datetime = line.replaceFirst('DTEND:', '').trim();
        endDate = convertToCustomFormat(datetime);
      } else if (line.startsWith('LOCATION:')) {
        location = line.replaceFirst('LOCATION:', '').trim();
      }
    }

    if (title.isNotEmpty && startDate.isNotEmpty) {
      DateTime eventStartDateTime = DateTime.parse(startDate);
      DateTime eventEndDateTime;

      if (endDate.isNotEmpty) {
        eventEndDateTime = DateTime.parse(endDate);
      } else {
        eventEndDateTime = eventStartDateTime.add(Duration(hours: 1));
      }

      Event event = Event(
        title: title,
        description: '',
        location: location,
        startDate: eventStartDateTime,
        endDate: eventEndDateTime,
        androidParams: AndroidParams(emailInvites: ['example@example.com']),
      );
      Add2Calendar.addEvent2Cal(event);
    }
  }

  ListTile _buildSearchOption(
      String label, IconData icon, String url, BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Text(
        label,
        style: GoogleFonts.montserrat(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 14.r,
        ),
      ),
      onTap: () async {
        if (await canLaunchUrlString(url)) {
          await launchUrlString(url);
        } else {
          logger.e('Cannot open $url');
        }
        Get.back();
      },
    );
  }

  void _showSearchBottomSheet(List<String> urls, List<IconData> icons,
      List<String> labels, BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(urls.length, (index) {
            return _buildSearchOption(
                labels[index], icons[index], urls[index], context);
          }),
        );
      },
    );
  }

  Future<void> _searchProductOnline(String barcode) async {
    final urls = [
      'https://www.amazon.com/s?k=$barcode',
      'https://www.ebay.com/sch/i.html?_nkw=$barcode',
      'https://www.google.com/search?q=$barcode',
    ];
    final icons = [
      LineAwesomeIcons.amazon,
      LineAwesomeIcons.ebay,
      LineAwesomeIcons.google
    ];
    final labels = [
      AppLocalizations.of(context)!.code_details_screen_result_product_amazon,
      AppLocalizations.of(context)!.code_details_screen_result_product_ebay,
      AppLocalizations.of(context)!.code_details_screen_result_product_google,
    ];
    _showSearchBottomSheet(urls, icons, labels, context);
  }

  Future<void> _searchBookOnline(String isbn) async {
    final urls = [
      'https://books.google.com/books?vid=ISBN$isbn',
      'https://www.amazon.com/s?k=$isbn',
      'https://www.goodreads.com/search?q=$isbn',
    ];
    final icons = [
      LineAwesomeIcons.book_solid,
      LineAwesomeIcons.amazon,
      LineAwesomeIcons.goodreads
    ];
    final labels = [
      AppLocalizations.of(context)!
          .code_details_screen_result_isbn_google_books,
      AppLocalizations.of(context)!.code_details_screen_result_isbn_amazon,
      AppLocalizations.of(context)!.code_details_screen_result_isbn_goodreads,
    ];
    _showSearchBottomSheet(urls, icons, labels, context);
  }
}
