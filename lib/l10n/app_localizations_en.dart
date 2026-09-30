// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get intro_title => 'QRation';

  @override
  String get onboarding_first_title => 'Create';

  @override
  String get onboarding_first_description =>
      'Quickly generate a customized QR code for any link or information. Just enter the desired data and create your QR code in seconds.';

  @override
  String get onboarding_second_title => 'Scan';

  @override
  String get onboarding_second_description =>
      'Easily scan any QR code with your device\'s camera. Access links, information, and content quickly and securely without having to type them out.';

  @override
  String get onboarding_third_title => 'Save';

  @override
  String get onboarding_third_description =>
      'Save your favorite QR codes for future access. Create an account to organize and store your codes securely and use them whenever you need.';

  @override
  String get onboarding_skip => 'Skip';

  @override
  String get onboarding_next => 'Next';

  @override
  String get onboarding_finish => 'Get started';

  @override
  String get onboarding_get_started => 'Get started';

  @override
  String get welcome_text => 'Hello';

  @override
  String get welcome_subtitle => 'Your QR code companion';

  @override
  String get welcome_tagline => 'Create. Scan. Save.';

  @override
  String get welcome_login => 'Login';

  @override
  String get welcome_signup => 'Sign Up';

  @override
  String get signup_screen_title => 'Registration';

  @override
  String get signup_screen_text => 'Sign Up';

  @override
  String get signup_screen_account => 'Already have an account? ';

  @override
  String get signup_screen_login => 'Log In';

  @override
  String get signup_toast_success => 'Successfully registered!';

  @override
  String get signup_toast_error_email_already_register =>
      'The email entered has already been registered';

  @override
  String get signup_toast_error_generic => 'Error during registration:';

  @override
  String get login_title => 'Welcome back';

  @override
  String get login_subtitle => 'Sign in to continue';

  @override
  String get login_email => 'Email';

  @override
  String get login_password => 'Password';

  @override
  String get login_remember_me => 'Remember me';

  @override
  String get login_forgot_password => 'Forgot password?';

  @override
  String get login_button => 'Log In';

  @override
  String get login_or => 'or continue with';

  @override
  String get login_google => 'Continue with Google';

  @override
  String get login_no_account => 'Don\'t have an account?';

  @override
  String get login_signup => 'Sign up';

  @override
  String get signup_title => 'Create account';

  @override
  String get signup_subtitle => 'Join QRation today';

  @override
  String get signup_name => 'Full name';

  @override
  String get signup_email => 'Email';

  @override
  String get signup_password => 'Password';

  @override
  String get signup_confirm_password => 'Confirm password';

  @override
  String get signup_button => 'Create Account';

  @override
  String get signup_have_account => 'Already have an account?';

  @override
  String get signup_login => 'Log in';

  @override
  String get reset_password_title => 'Reset password';

  @override
  String get reset_password_subtitle =>
      'Enter your email to receive the reset link';

  @override
  String get reset_password_email => 'Email';

  @override
  String get reset_password_button => 'Send reset link';

  @override
  String get validator_email => 'Email';

  @override
  String get validator_password => 'Password';

  @override
  String get validator_name => 'Name';

  @override
  String get validator_confirm_password => 'Passwords do not match';

  @override
  String get login_screen_title => 'Login';

  @override
  String get login_screen_text => 'Log in';

  @override
  String get login_screen_remember => 'Remember me';

  @override
  String get login_screen_password => 'Forgot password?';

  @override
  String get login_screen_account => 'Don\'t have an account? ';

  @override
  String get login_screen_signup => 'Sign up';

  @override
  String get login_toast_success => 'Login successful!';

  @override
  String get login_toast_error_email_not_found =>
      'The email entered does not match any account';

  @override
  String get login_toast_error_invalid_password =>
      'The password entered does not match any account';

  @override
  String get login_toast_error_generic => 'Error during login:';

  @override
  String get logout_toast_success => 'See you soon!';

  @override
  String get logout_toast_error_generic => 'Error during logout';

  @override
  String get reset_password_screen_title => 'Reset Password';

  @override
  String get reset_password_screen_description =>
      'Enter your email to receive the link with the procedure to reset your password';

  @override
  String get reset_password_screen_text => 'Reset Password';

  @override
  String get reset_password_form_email => 'Email';

  @override
  String get reset_password_form_email_field => 'Enter your email';

  @override
  String get reset_password_toast_success => 'Password reset email sent to: ';

  @override
  String get reset_password_toast_error_email_not_found =>
      'The email entered is not registered';

  @override
  String get reset_password_toast_error_password =>
      'Error during password reset';

  @override
  String get toast_signup_welcome => 'Hello, ';

  @override
  String get toast_signup_exist_email =>
      'The email address is already in use by another account.';

  @override
  String get toast_signup_invalid_email => 'The email address is not valid.';

  @override
  String get toast_signup_operation =>
      'Email/password accounts are not enabled.';

  @override
  String get toast_signup_password => 'The password is too weak.';

  @override
  String get toast_signup_generic_error =>
      'An error occurred. Please try again.';

  @override
  String get toast_login_welcome => 'Hello, ';

  @override
  String get toast_login_user => 'No user found for that email.';

  @override
  String get toast_login_wrong_password => 'Wrong password provided.';

  @override
  String get toast_login_invalid_email =>
      'The email address is badly formatted.';

  @override
  String get toast_login_invalid_credential =>
      'The supplied auth credential is incorrect, malformed or has expired.';

  @override
  String get toast_login_generic_error =>
      'An error occurred. Please try again.';

  @override
  String get toast_delete_success => 'Account deleted successfully';

  @override
  String get toast_delete_google => 'Re-authentication with Google failed.';

  @override
  String get toast_delete_user_data => 'Error deleting user data: ';

  @override
  String get toast_delete_user_storage => 'Error deleting user storage: ';

  @override
  String get toast_delete_user_history => 'Error deleting user history: ';

  @override
  String get toast_delete_generic_error =>
      'An unexpected error occurred. Please try again.';

  @override
  String get validator_name_empty => 'Name cannot be empty';

  @override
  String get validator_name_hint => 'Enter your name';

  @override
  String get validator_name_required => 'Name is required';

  @override
  String get validator_name_error => 'Invalid name: ';

  @override
  String get validator_email_missing_special => 'Missing @ symbol';

  @override
  String get validator_email_missing_dot => 'Missing . symbol';

  @override
  String get validator_email_hint => 'Enter your email';

  @override
  String get validator_email_required => 'Email is required';

  @override
  String get validator_email_error => 'Invalid email: ';

  @override
  String get validator_password_missing_upper => 'Missing uppercase letter';

  @override
  String get validator_password_missing_lower => 'Missing lowercase letter';

  @override
  String get validator_password_missing_digit => 'Missing digit';

  @override
  String get validator_password_missing_special => 'Missing special character';

  @override
  String get validator_password_missing_lenght =>
      'Password should be at least 8 characters long';

  @override
  String get validator_password_hint => 'Enter your password';

  @override
  String get validator_password_required => 'Password is required';

  @override
  String get validator_password_error => 'Invalid password: ';

  @override
  String get permission_camera_denied => 'Camera permission denied';

  @override
  String get permission_camera_toast => 'Grant camera permission from settings';

  @override
  String get permission_contacts_denied => 'Contacts permission denied';

  @override
  String get permission_contacts_toast =>
      'Grant contacts permission from settings';

  @override
  String get permission_location_denied => 'Location permission denied';

  @override
  String get permission_location_toast =>
      'Grant location permission from settings';

  @override
  String get permission_storage_denied => 'Storage permission denied';

  @override
  String get permission_storage_toast =>
      'Grant storage permission from settings';

  @override
  String get bottom_nav_item_scan => 'Scan';

  @override
  String get bottom_nav_item_create => 'Create';

  @override
  String get bottom_nav_item_favorites => 'Favorites';

  @override
  String get bottom_nav_item_history => 'History';

  @override
  String get bottom_nav_item_settings => 'Settings';

  @override
  String get home_recent_qr_codes => 'Recent QR codes';

  @override
  String get tab_created => 'Created';

  @override
  String get tab_scanned => 'Scanned';

  @override
  String get code_create_types_screen_title => 'Select QR Type';

  @override
  String get code_create_types_screen_standard => 'Standard';

  @override
  String get code_create_types_screen_social => 'Social';

  @override
  String get code_create_standard_screen_text_label => 'Text';

  @override
  String get code_create_standard_screen_url_label => 'URL';

  @override
  String get code_create_standard_screen_email_address_label => 'Email';

  @override
  String get code_create_standard_screen_email_subject_label => 'Subject';

  @override
  String get code_create_standard_screen_email_body_label => 'Body';

  @override
  String get code_create_standard_screen_phone_label => 'Phone';

  @override
  String get code_create_standard_screen_sms_phone_label => 'Phone';

  @override
  String get code_create_standard_screen_sms_message_label => 'Message';

  @override
  String get code_create_standard_screen_contact_name_label => 'Name';

  @override
  String get code_create_standard_screen_contact_surname_label => 'Surname';

  @override
  String get code_create_standard_screen_contact_phone_label => 'Phone';

  @override
  String get code_create_standard_screen_contact_email_label => 'Email';

  @override
  String get code_create_standard_screen_geo_latitude_label => 'Latitude';

  @override
  String get code_create_standard_screen_geo_longitude_label => 'Longitude';

  @override
  String get code_create_standard_screen_geo_select_button => 'Select Location';

  @override
  String get code_create_standard_screen_wifi_ssid_label => 'SSID';

  @override
  String get code_create_standard_screen_wifi_password_label => 'Password';

  @override
  String get code_create_standard_screen_wifi_type_label => 'Type';

  @override
  String get code_create_standard_screen_wifi_hidden_label => 'Hidden';

  @override
  String get code_create_standard_screen_calendar_title_label => 'Title';

  @override
  String get code_create_standard_screen_calendar_start_date_label =>
      'Start Date';

  @override
  String get code_create_standard_screen_calendar_end_date_label => 'End Date';

  @override
  String get code_create_standard_screen_calendar_location_label => 'Location';

  @override
  String get code_create_standard_screen_product_label => 'Product';

  @override
  String get code_create_standard_screen_isbn_label => 'ISBN';

  @override
  String get code_create_standard_screen_error_url_www =>
      'The content must start with \'www\' or \'http\'.';

  @override
  String get code_create_standard_screen_error_url_length =>
      'The content must be at least 7 characters long.';

  @override
  String get code_create_standard_screen_validator_field_a => 'The field';

  @override
  String get code_create_standard_screen_validator_field_b => 'can\'t be empty';

  @override
  String get code_create_standard_screen_validator_url => 'URL field is empty';

  @override
  String get code_create_standard_screen_validator_number =>
      'Please enter a valid number';

  @override
  String get code_create_standard_screen_eye_title => 'Eye';

  @override
  String get code_create_standard_screen_eye_color => 'Color';

  @override
  String get code_create_standard_screen_eye_rounded => 'Rounded';

  @override
  String get code_create_standard_screen_module_title => 'Module';

  @override
  String get code_create_standard_screen_module_color => 'Color';

  @override
  String get code_create_standard_screen_module_rounded => 'Rounded';

  @override
  String get code_create_standard_screen_logo_title => 'Logo';

  @override
  String get code_create_standard_screen_dialog_color_text => 'Choose a color';

  @override
  String get code_create_standard_screen_dialog_color_select => 'Select';

  @override
  String get code_create_standard_screen_create_button => 'Create';

  @override
  String get code_create_preview_title => 'Preview';

  @override
  String get code_create_style_title => 'Style';

  @override
  String get code_create_standard_screen_toast_success =>
      'QR code successfully added!';

  @override
  String get code_create_standard_screen_toast_error => 'Error saving QR code:';

  @override
  String get code_create_social_screen_url_label => 'Insert URL';

  @override
  String get code_create_social_screen_url_validator => 'Please enter a URL';

  @override
  String get code_create_social_screen_url_details_validator =>
      'Please enter more details to complete the URL';

  @override
  String get code_create_social_screen_whatsapp_label =>
      'Insert WhatsApp Number';

  @override
  String get code_create_social_screen_whatsapp_validator =>
      'Please enter a valid number';

  @override
  String get code_create_social_screen_spotify_artist_label =>
      'Insert Artist Name';

  @override
  String get code_create_social_screen_spotify_artist_validator =>
      'Please enter an artist name';

  @override
  String get code_create_social_screen_spotify_song_label => 'Insert Song Name';

  @override
  String get code_create_social_screen_spotify_song_validator =>
      'Please enter a song name';

  @override
  String get code_create_social_screen_error_url => 'This field is required';

  @override
  String get code_create_social_screen_error_url_www =>
      'The content must start with \'www\' or \'http\'.';

  @override
  String get code_create_social_screen_error_url_length =>
      'The content must be at least 7 characters long.';

  @override
  String get code_create_social_screen_validator_url =>
      'Please enter a valid URL';

  @override
  String get code_create_social_screen_eye_title => 'Eye';

  @override
  String get code_create_social_screen_eye_color => 'Color';

  @override
  String get code_create_social_screen_eye_rounded => 'Rounded';

  @override
  String get code_create_social_screen_module_title => 'Module';

  @override
  String get code_create_social_screen_module_color => 'Color';

  @override
  String get code_create_social_screen_module_rounded => 'Rounded';

  @override
  String get code_create_social_screen_logo_title => 'Logo';

  @override
  String get code_create_social_screen_dialog_color_text => 'Choose a color';

  @override
  String get code_create_social_screen_dialog_color_select => 'Select';

  @override
  String get code_create_social_screen_create_button => 'Create';

  @override
  String get code_create_social_screen_toast_success =>
      'QR code successfully added!';

  @override
  String get code_create_social_screen_toast_error => 'Error saving QR code:';

  @override
  String get code_scanner_screen_title => 'QR Scanner';

  @override
  String get code_scanner_screen_camera_hint => 'Scan the QR code';

  @override
  String get code_scanner_screen_tooltip_gallery => 'Scan from an image';

  @override
  String get code_scanner_screen_tooltip_torch_on => 'Turn on the flashlight';

  @override
  String get code_scanner_screen_tooltip_torch_off => 'Turn off the flashlight';

  @override
  String get code_scanner_screen_tooltip_switch_camera => 'Switch camera';

  @override
  String get code_scanner_screen_image_scan_toast_error =>
      'Failed to scan QR code:';

  @override
  String get code_scanner_screen_image_empty_toast_error => 'No image selected';

  @override
  String get code_scanner_screen_scan_qr_empty_toast_error =>
      'No QR code found in the image';

  @override
  String get code_scanner_screen_scan_qr_read_toast_error =>
      'Failed to read QR code:';

  @override
  String get code_scanner_screen_scan_qr_decode_toast_error =>
      'Failed to decode image';

  @override
  String get code_details_screen_title => 'QR Code Details';

  @override
  String get code_details_screen_date_title => 'Date';

  @override
  String get code_details_screen_type_title => 'Type';

  @override
  String get code_details_screen_title_title => 'QR Code';

  @override
  String get code_details_screen_content_title => 'Content';

  @override
  String get code_details_screen_action_text => 'Copy';

  @override
  String get code_details_screen_action_url => 'Open';

  @override
  String get code_details_screen_action_email => 'Send';

  @override
  String get code_details_screen_action_phone => 'Call';

  @override
  String get code_details_screen_action_sms => 'Message';

  @override
  String get code_details_screen_action_contact => 'Add';

  @override
  String get code_details_screen_action_geo => 'Navigate';

  @override
  String get code_details_screen_action_wifi => 'Connect';

  @override
  String get code_details_screen_action_calendar => 'Add';

  @override
  String get code_details_screen_product => 'Product Code';

  @override
  String get code_details_screen_action_product => 'Search';

  @override
  String get code_details_screen_isbn => 'ISBN Code';

  @override
  String get code_details_screen_action_isbn => 'Search';

  @override
  String get code_details_screen_action_button_copy => 'Copy';

  @override
  String get code_details_screen_action_button_favorite => 'Favorite';

  @override
  String get code_details_screen_action_button_save => 'Save';

  @override
  String get code_details_screen_action_button_share => 'Share';

  @override
  String get code_details_screen_result_copy => 'Content copied to clipboard!';

  @override
  String get code_details_screen_result_contact => 'Contact added!';

  @override
  String get code_details_screen_result_wifi => 'WiFi saved and connected!';

  @override
  String get code_details_screen_result_product_amazon => 'Search on Amazon';

  @override
  String get code_details_screen_result_product_ebay => 'Search on Ebay';

  @override
  String get code_details_screen_result_product_google => 'Search on Google';

  @override
  String get code_details_screen_result_isbn_google_books =>
      'Search on Google Books';

  @override
  String get code_details_screen_result_isbn_amazon => 'Search on Amazon';

  @override
  String get code_details_screen_result_isbn_goodreads => 'Search on Goodreads';

  @override
  String get code_details_screen_toast_success => 'QR code saved to gallery';

  @override
  String get code_details_screen_toast_error => 'Error saving QR code';

  @override
  String get code_details_screen_toast_error_link => 'Unable to open link';

  @override
  String get code_details_screen_menu_notes => 'Notes';

  @override
  String get code_details_screen_menu_delete => 'Delete';

  @override
  String get code_details_screen_notes_title => 'Add notes';

  @override
  String get code_details_screen_notes_hint => 'Enter your notes here';

  @override
  String get code_details_screen_notes_cancel => 'Cancel';

  @override
  String get code_details_screen_notes_save => 'Save';

  @override
  String get code_details_screen_delete_title => 'Delete';

  @override
  String get code_details_screen_delete_description =>
      'Are you sure you want to delete this code?';

  @override
  String get code_details_screen_delete_toast_success => 'Code deleted!';

  @override
  String get favorites_screen_tab_created => 'Created';

  @override
  String get favorites_screen_tab_scanned => 'Scanned';

  @override
  String get favorites_screen_error_state => 'Error:';

  @override
  String get favorites_screen_empty_state => 'No favorites codes';

  @override
  String get favorites_screen_empty_action => 'Create your first code';

  @override
  String get history_screen_search_label => 'Search';

  @override
  String get history_screen_filter_all => 'All';

  @override
  String get history_screen_filter_created => 'Created';

  @override
  String get history_screen_filter_scanned => 'Scanned';

  @override
  String get history_filter_sheet_title => 'Filters';

  @override
  String get history_filter_sheet_source => 'Source';

  @override
  String get history_filter_sheet_types => 'Code type';

  @override
  String get history_filter_sheet_social => 'Social';

  @override
  String get history_filter_sheet_show_results => 'Show results';

  @override
  String get history_screen_error_state => 'Error:';

  @override
  String get history_screen_delete_title => 'Delete';

  @override
  String get sync_status_offline =>
      'You are offline: showing codes saved on this device';

  @override
  String get sync_status_pending => 'Changes waiting to be synced';

  @override
  String get sync_refresh_offline => 'Can\'t refresh: no connection';

  @override
  String get history_screen_empty_state => 'No saved codes';

  @override
  String get history_screen_empty_action => 'Scan now';

  @override
  String get history_screen_empty_filtered =>
      'No results for the active filters';

  @override
  String get history_screen_clear_filters => 'Clear filters';

  @override
  String get history_screen_selected_count => 'selected';

  @override
  String get history_screen_select_all => 'Select all';

  @override
  String get history_screen_deselect_all => 'Deselect all';

  @override
  String get history_screen_delete_selected_description =>
      'Are you sure you want to delete the selected codes?';

  @override
  String get history_screen_delete_selected_toast_success =>
      'Selected codes have been successfully deleted!';

  @override
  String history_screen_deleted_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count codes deleted',
      one: '1 code deleted',
    );
    return '$_temp0';
  }

  @override
  String get history_screen_tooltip_close_selection => 'Exit selection mode';

  @override
  String get history_screen_tooltip_clear_search => 'Clear search';

  @override
  String get history_screen_tooltip_filter => 'Filter';

  @override
  String get history_screen_tooltip_select_mode => 'Select codes';

  @override
  String get history_screen_tooltip_delete => 'Delete';

  @override
  String get history_screen_tooltip_details => 'View details';

  @override
  String get settings_title_general => 'General';

  @override
  String get settings_title_theme => 'Theme';

  @override
  String get settings_subtitle_theme_option_light => 'Light';

  @override
  String get settings_subtitle_theme_option_dark => 'Dark';

  @override
  String get settings_subtitle_theme_option_system => 'System';

  @override
  String get settings_title_language => 'Language';

  @override
  String get settings_subtitle_language_option_english => 'English';

  @override
  String get settings_subtitle_language_option_italian => 'Italian';

  @override
  String get settings_title_accent_color => 'Accent color';

  @override
  String get settings_accent_color_blue => 'Blue';

  @override
  String get settings_accent_color_green => 'Green';

  @override
  String get settings_accent_color_purple => 'Purple';

  @override
  String get settings_accent_color_red => 'Red';

  @override
  String get settings_accent_color_teal => 'Teal';

  @override
  String get settings_accent_color_orange => 'Orange';

  @override
  String get settings_accent_color_pink => 'Pink';

  @override
  String get settings_accent_color_grey => 'Grey';

  @override
  String get settings_title_scan => 'Scan';

  @override
  String get settings_title_beep => 'Beep';

  @override
  String get settings_subtile_beep => 'Enable a sound when scanning a code';

  @override
  String get settings_title_vibrate => 'Vibrate';

  @override
  String get settings_subtile_vibrate =>
      'Enable a vibration when scanning a code';

  @override
  String get settings_title_account => 'Account';

  @override
  String get settings_tile_account => 'Account';

  @override
  String get settings_tile_profile => 'Profile';

  @override
  String get settings_tile_database => 'Database';

  @override
  String get settings_tile_log_out => 'Log Out';

  @override
  String get settings_tile_delete_account => 'Delete Account';

  @override
  String get settings_title_app => 'App';

  @override
  String get settings_tile_info => 'Info';

  @override
  String get settings_tile_changelog => 'What\'s new';

  @override
  String get settings_tile_privacy_policy => 'Privacy Policy';

  @override
  String get settings_tile_support => 'Support';

  @override
  String get settings_tile_share => 'Share';

  @override
  String get database_screen_title => 'Database';

  @override
  String get database_screen_account_title => 'Account Info';

  @override
  String get database_screen_account_field_userid => 'ID';

  @override
  String get database_screen_account_field_name => 'Name';

  @override
  String get database_screen_account_field_email => 'Email';

  @override
  String get database_screen_account_field_date => 'Account Created';

  @override
  String get database_screen_codes_field_total_title => 'Codes Statistics';

  @override
  String get database_screen_codes_field_total_saved => 'Saved codes';

  @override
  String get database_screen_codes_field_created_title => 'Created codes';

  @override
  String get database_screen_codes_field_created_totals => 'Totals';

  @override
  String get database_screen_codes_field_scanned_title => 'Scanned codes';

  @override
  String get database_screen_codes_field_scanned_totals => 'Totals';

  @override
  String get database_screen_codes_field_standard_title => 'Standard codes';

  @override
  String get database_screen_codes_field_social_title => 'Social codes';

  @override
  String get database_screen_codes_field_empty => 'No codes available';

  @override
  String get database_screen_codes_dialog_standard => 'Standard';

  @override
  String get database_screen_codes_dialog_social => 'Social';

  @override
  String get database_screen_codes_dialog_close => 'Close';

  @override
  String get database_screen_export_title => 'Export option';

  @override
  String get database_screen_pdf_download => 'PDF';

  @override
  String get database_screen_pdf_confirm => 'PDF saved in the Download folder';

  @override
  String get database_screen_pdf_error => 'Unable to generate PDF';

  @override
  String get database_screen_excel_download => 'Excel';

  @override
  String get database_screen_excel_confirm =>
      'Excel saved in the Download folder';

  @override
  String get database_screen_excel_error => 'Unable to generate Excel';

  @override
  String get database_screen_csv_download => 'CSV';

  @override
  String get database_screen_csv_confirm => 'CSV saved in the Download folder';

  @override
  String get database_screen_csv_error => 'Unable to generate CSV';

  @override
  String get database_screen_export_menu => 'Export JSON';

  @override
  String get database_screen_import_menu => 'Import JSON';

  @override
  String get database_screen_backup_title => 'JSON backup';

  @override
  String get database_screen_backup_last_export => 'Last export';

  @override
  String get database_screen_backup_last_import => 'Last import';

  @override
  String get database_screen_backup_never => 'Never';

  @override
  String get database_screen_export_success =>
      'JSON exported in the Download folder';

  @override
  String get database_screen_export_error => 'Error during export';

  @override
  String get database_screen_import_success => 'JSON successfully imported!';

  @override
  String get database_screen_import_error => 'Error during import';

  @override
  String get database_service_codes_field_id => 'ID';

  @override
  String get database_service_codes_field_date => 'Data';

  @override
  String get database_service_codes_field_source => 'Source';

  @override
  String get database_service_codes_field_type => 'Type';

  @override
  String get database_service_codes_field_code => 'QR code';

  @override
  String get database_service_codes_field_content => 'Content';

  @override
  String get database_service_codes_field_eye_color => 'Eyes color';

  @override
  String get database_service_codes_field_eye_rounded => 'Rounded eyes';

  @override
  String get database_service_codes_field_module_color => 'Modules color';

  @override
  String get database_service_codes_field_module_rounded => 'Rounded modules';

  @override
  String get database_service_codes_field_favorite => 'Preferred';

  @override
  String get database_service_codes_field_social => 'Social';

  @override
  String get database_pdf_field_user_title => 'User Information';

  @override
  String get database_pdf_field_user_id => 'User ID';

  @override
  String get database_pdf_field_user_name => 'Name';

  @override
  String get database_pdf_field_user_email => 'Email';

  @override
  String get database_pdf_field_user_date => 'Account Created';

  @override
  String get database_pdf_field_code_title => 'Codes Statistics';

  @override
  String get database_pdf_field_code_saved => 'Saved Codes';

  @override
  String get database_pdf_field_code_created => 'Created Codes';

  @override
  String get database_pdf_field_code_created_standard => 'Standard';

  @override
  String get database_pdf_field_code_created_social => 'Social';

  @override
  String get database_pdf_field_code_scanned => 'Scanned Codes';

  @override
  String get database_pdf_field_code_scanned_standard => 'Standard';

  @override
  String get database_pdf_field_code_scanned_social => 'Social';

  @override
  String get database_pdf_page => 'Page';

  @override
  String get user_screen_title => 'Profile';

  @override
  String get user_screen_name_label => 'Name';

  @override
  String get user_screen_email_label => 'Email';

  @override
  String get user_screen_date_label => 'Joined';

  @override
  String get user_screen_logout_button => 'Log Out';

  @override
  String get info_screen_title => 'Info';

  @override
  String get info_screen_origin_text => 'Origin';

  @override
  String get info_screen_origin_description =>
      'The name of the app is a fusion between \'QR\' and \'Creation\', just to specify the two main features of the application and, that is, scanning and creating QR Codes.';

  @override
  String get info_screen_description_text => 'Description';

  @override
  String get info_screen_description_description =>
      'This app allows you to scan and generate QR codes, which can be saved in your personal account for easy and safe management. You can access all saved QR codes at any time. In addition, each code allows a different function to be performed according to its type.';

  @override
  String get info_screen_credits_text => 'Credits';

  @override
  String get info_screen_credits_a_text => 'Idea';

  @override
  String get info_screen_credits_a_value => 'Nicola De Nicolais';

  @override
  String get info_screen_credits_b_text => 'Development';

  @override
  String get info_screen_credits_b_value => 'Nicola De Nicolais';

  @override
  String get info_screen_credits_c_text => 'Design';

  @override
  String get info_screen_credits_c_value => 'Nicola De Nicolais';

  @override
  String get info_screen_version_text => 'Version';

  @override
  String get policy_screen_title => 'Privacy Policy';

  @override
  String get support_screen_title => 'Support';

  @override
  String get support_screen_contacts_text => 'Contact Us';

  @override
  String get support_screen_contacts_decription =>
      'For any problems or questions, write to:';

  @override
  String get support_screen_contacts_info => 'ndn21dev@gmail.com';

  @override
  String get support_screen_faq_text => 'FAq';

  @override
  String get support_screen_faq_decription =>
      'Find answers to the most frequently asked questions.';

  @override
  String get support_screen_faq_q1 => 'How to scan a QR code?';

  @override
  String get support_screen_faq_a1 =>
      'To scan a QR code, go to Home and click the \'Create\' button. Choose the type of code to create and enter all the necessary details before generating.';

  @override
  String get support_screen_faq_q2 => 'How to create a QR code?';

  @override
  String get support_screen_faq_a2 =>
      'To scan a QR code, go to Home and click the \'Scan\' button. Once opened, point the camera at the code to be scanned and it will be saved.';

  @override
  String get support_screen_faq_q3 => 'How to delete a QR code?';

  @override
  String get support_screen_faq_a3 =>
      'To delete a QR code, click on the \'History\' icon on the bottom bar and click on the trash can icon at the top. Then check the code to delete and click the trash can icon again to delete it.';

  @override
  String get support_screen_faq_q4 => 'Can I save codes in a favorites list?';

  @override
  String get support_screen_faq_a4 =>
      'Yes, you can add codes to your favorites by clicking on the heart-shaped icon on the code detail screen.';

  @override
  String get support_screen_faq_q5 =>
      'Can I download a file containing all saved codes?';

  @override
  String get support_screen_faq_a5 =>
      'Yes, you can export a file containing all saved codes in three different formats (CSV, Excel, PDF). Click on the \'Settings\' icon on the bottom bar, go to the \'Database\' section, and choose the format to export the file.';

  @override
  String get support_screen_faq_q7 =>
      'What can I do if the app doesn\'t work properly?';

  @override
  String get support_screen_faq_a7 =>
      'If you encounter problems, try restarting the app. If the problem persists, contact technical support through the \'Contact Us\' section.';

  @override
  String get support_screen_documentation_text => 'Documentation';

  @override
  String get support_screen_documentation_decription =>
      'See the full documentation for more details.';

  @override
  String get support_screen_documentation_info =>
      'Go to the documentation on GitHub';

  @override
  String get delete_title => 'Delete Account';

  @override
  String get delete_description =>
      'On this page you can permanently delete your Account.\n\nConfirming the cancellation will also delete all the Database linked to the Account.\n\nRemember that the process is irreversible.\n\nIf you want to proceed click on the Button below:';

  @override
  String get delete_d_title => 'Delete';

  @override
  String get delete_d_description =>
      'Are you sure you want to delete your account?';

  @override
  String get custom_picker_field_date_text => 'Select Date';

  @override
  String get custom_picker_field_time_text => 'Select Time';

  @override
  String get custom_delete_dialog_confirm => 'Delete';

  @override
  String get custom_delete_dialog_cancel => 'Cancel';

  @override
  String get full_screen_map_title => 'Select the position';

  @override
  String get discard_dialog_title => 'Discard changes?';

  @override
  String get discard_dialog_message => 'All entered information will be lost.';

  @override
  String get discard_dialog_confirm => 'Discard';

  @override
  String get discard_dialog_cancel => 'Keep editing';

  @override
  String get code_type_text_text => 'Text';

  @override
  String get code_type_text_url => 'URL';

  @override
  String get code_type_text_email => 'Email';

  @override
  String get code_type_text_phone => 'Phone';

  @override
  String get code_type_text_sms => 'SMS';

  @override
  String get code_type_text_contact => 'Contact';

  @override
  String get code_type_text_location => 'Location';

  @override
  String get code_type_text_wifi => 'WiFi';

  @override
  String get code_type_text_event => 'Event';

  @override
  String get code_type_text_product => 'Product';

  @override
  String get code_type_text_isbn => 'ISBN';

  @override
  String get code_type_text_license => 'License';

  @override
  String get code_type_text_unknown => 'Unknown';

  @override
  String get app_error_state_retry => 'Retry';

  @override
  String get database_screen_load_error =>
      'Unable to load your data. Please try again.';

  @override
  String get code_scanner_screen_permission_error =>
      'Camera access is required to scan codes.';

  @override
  String get changelog_dialog_title => 'What\'s new';

  @override
  String get changelog_dialog_close => 'Close';

  @override
  String get changelog_v1_1_0_bullet_1 =>
      'Added the \"What\'s new\" dialog: shows the app\'s updates after every update and can be opened anytime from Settings.';

  @override
  String get changelog_v1_1_0_bullet_2 =>
      'Fixed a graphical overflow in the Database screen\'s statistics section.';

  @override
  String get changelog_v2_0_0_bullet_3 =>
      '\"Remember me\" is now automatically enabled when signing in with Google.';

  @override
  String get changelog_v2_0_0_bullet_4 =>
      'Moved the account info section and account deletion from the Database screen to the Profile screen.';

  @override
  String get changelog_v2_0_0_bullet_5 =>
      'Improved the code detail page layout and the notes editor, now a bottom sheet instead of the old popup.';

  @override
  String get changelog_v2_0_0_bullet_6 =>
      'Fixed a layout crash that prevented the notes bottom sheet in the code detail page from opening (only the keyboard would show).';

  @override
  String get changelog_v2_0_0_bullet_7 =>
      'Reduced excessive text boldness across the app.';

  @override
  String get changelog_v2_0_0_bullet_8 =>
      'The QR scanner is now the first screen you see, so you can scan right after opening the app.';

  @override
  String get changelog_v2_0_0_bullet_9 =>
      'Fixed a bug where, after the first scan, the scanner would stop recognizing further codes if the confirmation sound or vibration failed to start.';

  @override
  String get changelog_v2_0_0_bullet_10 =>
      'Fixed a bug where, after scanning a code with no or unstable connectivity, the app stayed stuck on the scanner instead of opening the detail page (the code was still saved and visible in History).';

  @override
  String get changelog_v2_0_0_bullet_11 =>
      'Added a loading indicator after scanning a code, so the save delay doesn\'t look like the app froze.';

  @override
  String get changelog_v2_0_0_bullet_12 =>
      'Shortened the wait time on the splash screen at app startup.';

  @override
  String get changelog_v2_0_0_bullet_13 =>
      'Home now shows the code-creation screen directly instead of an extra intermediate step; profile access has been moved to Settings.';

  @override
  String get changelog_v2_0_0_bullet_14 =>
      'Updated the icon and label of the \"Create\" navigation tab, no longer labeled \"Home\" since it now opens code creation directly.';

  @override
  String get changelog_v2_0_0_bullet_15 =>
      'Fixed a bug where confirming a code deletion (in History or account deletion) left a black screen afterward: the confirmation dialog already closed itself, but an extra close right after it also removed the screen underneath. Bulk deletes in History now also run in parallel instead of one at a time, cutting the wait.';

  @override
  String get changelog_v2_0_0_bullet_16 =>
      'Updated the scanning engine and modernized the QR code generation engine, keeping the existing color and shape customizations unchanged.';

  @override
  String get changelog_v2_0_0_bullet_17 =>
      'Fixed a bug where exporting the database to PDF, Excel, or CSV failed with a storage permission denied error that was never actually requested from the user.';

  @override
  String get changelog_v2_0_0_bullet_18 =>
      'The exported PDF, Excel, or CSV file is now also automatically saved to the device\'s Download folder, so it can be found later even without sharing it right away.';

  @override
  String get changelog_v2_0_0_bullet_19 =>
      'Simplified deleting codes in History: a single Trash icon now starts multi-selection and deletes the chosen codes, replacing the two icons that previously did the same thing.';

  @override
  String get changelog_v2_0_0_bullet_20 =>
      'Refreshed the Database page layout: import/export actions are now directly accessible from the top app bar, and statistics are easier to read thanks to summary cards for total, created, and scanned codes.';

  @override
  String get changelog_v2_0_0_bullet_21 =>
      'Added the option to embed a custom logo at the center of generated QR codes.';

  @override
  String get changelog_v2_0_0_bullet_22 =>
      'Added the ability to customize the app\'s accent color from Settings, choosing among 8 preset palettes, in addition to the existing light/dark theme.';

  @override
  String get changelog_v2_0_0_bullet_23 =>
      'Fixed an issue where a QR code, especially with an embedded logo, could fail to be recognized when scanned from a saved image.';

  @override
  String get changelog_v2_0_0_bullet_24 =>
      'Refreshed the theme, language, and accent color selectors in Settings with a new segmented-button layout.';

  @override
  String get changelog_v2_0_0_bullet_25 =>
      'Sped up the transition from the splash screen to scanning and lightened bold text weight throughout the app.';

  @override
  String get changelog_v2_0_0_bullet_26 =>
      'Added a \"System\" theme option that automatically follows the device\'s light/dark setting.';

  @override
  String get changelog_v2_0_0_bullet_27 =>
      'Fixed an issue where changing the scan beep or vibration in Settings only took effect after restarting the app.';

  @override
  String get changelog_v2_0_0_bullet_28 =>
      'Fixed an issue where the same code could not be scanned again without restarting the app: it can now be rescanned by moving the camera away and back.';

  @override
  String get changelog_v2_0_0_bullet_29 =>
      'Smoother search in History: the list no longer reloads on every keystroke and filters are applied as soon as you stop typing.';

  @override
  String get changelog_v2_0_0_bullet_30 =>
      'History and Favorites now share the same card style, and tapping a code anywhere on its card in History opens its details.';

  @override
  String get changelog_v2_0_0_bullet_31 =>
      'Faster, smoother opening of code details, with the type icon animating from the list into the details screen.';

  @override
  String get changelog_v2_0_0_bullet_32 =>
      'Empty screens now suggest what to do next: create your first code from Favorites, scan from History, or clear the filters when a search finds nothing.';

  @override
  String get changelog_v2_0_0_bullet_33 =>
      'The chosen app language is applied right from startup, without a brief flash in the device language.';

  @override
  String get changelog_v2_0_0_bullet_34 =>
      'Refreshed scanner: the flashlight button shows whether it is on, the scan line is animated, the area outside the frame is dimmed, and the buttons give touch and haptic feedback.';

  @override
  String get changelog_v2_0_0_bullet_35 =>
      'History filters are now grouped in a single panel with labeled chips, and the filter icon shows how many filters are active.';

  @override
  String get changelog_v2_0_0_bullet_36 =>
      'You can now sign up with Google directly from the registration screen.';

  @override
  String get changelog_v2_0_0_bullet_37 =>
      'Signing in with Google now always keeps you logged in, and the saved session is restored reliably at startup, even offline or after reinstalling the app from a backup.';

  @override
  String get changelog_v2_0_0_bullet_38 =>
      'The Database page shows when the JSON backup was last exported and imported, and exported backups are now also saved to the public Download folder, so they are not lost if the app is uninstalled.';

  @override
  String get changelog_v2_0_0_bullet_39 =>
      'Refreshed look for Code details, Create code, Info and Profile, consistent with the rest of the app: more readable text, labeled quick actions in code details and a clearer layout.';

  @override
  String get changelog_v2_0_0_bullet_40 =>
      'The QR preview while creating a code now updates live for every code type, including social codes.';

  @override
  String get changelog_v2_0_0_bullet_41 =>
      'Settings now show the language actually in use, and switches that are off no longer look switched on.';

  @override
  String get changelog_v2_0_0_bullet_42 =>
      'Pull down History and Favorites to refresh them, and a small banner now tells you when you are offline or when changes are still waiting to be synced.';

  @override
  String get changelog_v2_0_0_bullet_43 =>
      'Selecting codes in History is smoother: long-press a code to start selecting, the search bar turns into an animated selection bar, and the confirmation tells you how many codes were deleted.';

  @override
  String get changelog_v2_0_0_bullet_44 =>
      'Updated the Firebase libraries used for sign-in, cloud sync and crash reporting to their latest versions.';
}
