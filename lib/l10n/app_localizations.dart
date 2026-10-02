import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('it')
  ];

  /// No description provided for @intro_title.
  ///
  /// In en, this message translates to:
  /// **'QRation'**
  String get intro_title;

  /// No description provided for @onboarding_first_title.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get onboarding_first_title;

  /// No description provided for @onboarding_first_description.
  ///
  /// In en, this message translates to:
  /// **'Quickly generate a customized QR code for any link or information. Just enter the desired data and create your QR code in seconds.'**
  String get onboarding_first_description;

  /// No description provided for @onboarding_second_title.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get onboarding_second_title;

  /// No description provided for @onboarding_second_description.
  ///
  /// In en, this message translates to:
  /// **'Easily scan any QR code with your device\'s camera. Access links, information, and content quickly and securely without having to type them out.'**
  String get onboarding_second_description;

  /// No description provided for @onboarding_third_title.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get onboarding_third_title;

  /// No description provided for @onboarding_third_description.
  ///
  /// In en, this message translates to:
  /// **'Save your favorite QR codes for future access. Create an account to organize and store your codes securely and use them whenever you need.'**
  String get onboarding_third_description;

  /// No description provided for @onboarding_skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboarding_skip;

  /// No description provided for @onboarding_next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboarding_next;

  /// No description provided for @password_show.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get password_show;

  /// No description provided for @password_hide.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get password_hide;

  /// No description provided for @onboarding_page_indicator.
  ///
  /// In en, this message translates to:
  /// **'Page {current} of {total}'**
  String onboarding_page_indicator(int current, int total);

  /// No description provided for @onboarding_finish.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboarding_finish;

  /// No description provided for @onboarding_get_started.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboarding_get_started;

  /// No description provided for @welcome_text.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get welcome_text;

  /// No description provided for @welcome_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Your QR code companion'**
  String get welcome_subtitle;

  /// No description provided for @welcome_tagline.
  ///
  /// In en, this message translates to:
  /// **'Create. Scan. Save.'**
  String get welcome_tagline;

  /// No description provided for @welcome_login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get welcome_login;

  /// No description provided for @welcome_signup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get welcome_signup;

  /// No description provided for @signup_screen_title.
  ///
  /// In en, this message translates to:
  /// **'Registration'**
  String get signup_screen_title;

  /// No description provided for @signup_screen_text.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signup_screen_text;

  /// No description provided for @signup_screen_account.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get signup_screen_account;

  /// No description provided for @signup_screen_login.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get signup_screen_login;

  /// No description provided for @signup_toast_success.
  ///
  /// In en, this message translates to:
  /// **'Successfully registered!'**
  String get signup_toast_success;

  /// No description provided for @signup_toast_error_email_already_register.
  ///
  /// In en, this message translates to:
  /// **'The email entered has already been registered'**
  String get signup_toast_error_email_already_register;

  /// No description provided for @signup_toast_error_generic.
  ///
  /// In en, this message translates to:
  /// **'Error during registration:'**
  String get signup_toast_error_generic;

  /// No description provided for @login_title.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get login_title;

  /// No description provided for @login_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get login_subtitle;

  /// No description provided for @login_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get login_email;

  /// No description provided for @login_password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get login_password;

  /// No description provided for @login_remember_me.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get login_remember_me;

  /// No description provided for @login_forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get login_forgot_password;

  /// No description provided for @login_button.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get login_button;

  /// No description provided for @login_or.
  ///
  /// In en, this message translates to:
  /// **'or continue with'**
  String get login_or;

  /// No description provided for @login_google.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get login_google;

  /// No description provided for @login_no_account.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get login_no_account;

  /// No description provided for @login_signup.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get login_signup;

  /// No description provided for @signup_title.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get signup_title;

  /// No description provided for @signup_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Join QRation today'**
  String get signup_subtitle;

  /// No description provided for @signup_name.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get signup_name;

  /// No description provided for @signup_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get signup_email;

  /// No description provided for @signup_password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get signup_password;

  /// No description provided for @signup_confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get signup_confirm_password;

  /// No description provided for @signup_button.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get signup_button;

  /// No description provided for @signup_have_account.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get signup_have_account;

  /// No description provided for @signup_login.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get signup_login;

  /// No description provided for @reset_password_title.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get reset_password_title;

  /// No description provided for @reset_password_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email to receive the reset link'**
  String get reset_password_subtitle;

  /// No description provided for @reset_password_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get reset_password_email;

  /// No description provided for @reset_password_button.
  ///
  /// In en, this message translates to:
  /// **'Send reset link'**
  String get reset_password_button;

  /// No description provided for @validator_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get validator_email;

  /// No description provided for @validator_password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get validator_password;

  /// No description provided for @validator_name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get validator_name;

  /// No description provided for @validator_confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get validator_confirm_password;

  /// No description provided for @login_screen_title.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login_screen_title;

  /// No description provided for @login_screen_text.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get login_screen_text;

  /// No description provided for @login_screen_remember.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get login_screen_remember;

  /// No description provided for @login_screen_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get login_screen_password;

  /// No description provided for @login_screen_account.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get login_screen_account;

  /// No description provided for @login_screen_signup.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get login_screen_signup;

  /// No description provided for @login_toast_success.
  ///
  /// In en, this message translates to:
  /// **'Login successful!'**
  String get login_toast_success;

  /// No description provided for @login_toast_error_email_not_found.
  ///
  /// In en, this message translates to:
  /// **'The email entered does not match any account'**
  String get login_toast_error_email_not_found;

  /// No description provided for @login_toast_error_invalid_password.
  ///
  /// In en, this message translates to:
  /// **'The password entered does not match any account'**
  String get login_toast_error_invalid_password;

  /// No description provided for @login_toast_error_generic.
  ///
  /// In en, this message translates to:
  /// **'Error during login:'**
  String get login_toast_error_generic;

  /// No description provided for @logout_toast_success.
  ///
  /// In en, this message translates to:
  /// **'See you soon!'**
  String get logout_toast_success;

  /// No description provided for @logout_toast_error_generic.
  ///
  /// In en, this message translates to:
  /// **'Error during logout'**
  String get logout_toast_error_generic;

  /// No description provided for @reset_password_screen_title.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get reset_password_screen_title;

  /// No description provided for @reset_password_screen_description.
  ///
  /// In en, this message translates to:
  /// **'Enter your email to receive the link with the procedure to reset your password'**
  String get reset_password_screen_description;

  /// No description provided for @reset_password_screen_text.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get reset_password_screen_text;

  /// No description provided for @reset_password_form_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get reset_password_form_email;

  /// No description provided for @reset_password_form_email_field.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get reset_password_form_email_field;

  /// No description provided for @reset_password_toast_success.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent to: '**
  String get reset_password_toast_success;

  /// No description provided for @reset_password_toast_error_email_not_found.
  ///
  /// In en, this message translates to:
  /// **'The email entered is not registered'**
  String get reset_password_toast_error_email_not_found;

  /// No description provided for @reset_password_toast_error_password.
  ///
  /// In en, this message translates to:
  /// **'Error during password reset'**
  String get reset_password_toast_error_password;

  /// No description provided for @toast_signup_welcome.
  ///
  /// In en, this message translates to:
  /// **'Hello, '**
  String get toast_signup_welcome;

  /// No description provided for @toast_signup_exist_email.
  ///
  /// In en, this message translates to:
  /// **'The email address is already in use by another account.'**
  String get toast_signup_exist_email;

  /// No description provided for @toast_signup_invalid_email.
  ///
  /// In en, this message translates to:
  /// **'The email address is not valid.'**
  String get toast_signup_invalid_email;

  /// No description provided for @toast_signup_operation.
  ///
  /// In en, this message translates to:
  /// **'Email/password accounts are not enabled.'**
  String get toast_signup_operation;

  /// No description provided for @toast_signup_password.
  ///
  /// In en, this message translates to:
  /// **'The password is too weak.'**
  String get toast_signup_password;

  /// No description provided for @toast_signup_generic_error.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again.'**
  String get toast_signup_generic_error;

  /// No description provided for @toast_login_welcome.
  ///
  /// In en, this message translates to:
  /// **'Hello, '**
  String get toast_login_welcome;

  /// No description provided for @toast_login_user.
  ///
  /// In en, this message translates to:
  /// **'No user found for that email.'**
  String get toast_login_user;

  /// No description provided for @toast_login_wrong_password.
  ///
  /// In en, this message translates to:
  /// **'Wrong password provided.'**
  String get toast_login_wrong_password;

  /// No description provided for @toast_login_invalid_email.
  ///
  /// In en, this message translates to:
  /// **'The email address is badly formatted.'**
  String get toast_login_invalid_email;

  /// No description provided for @toast_login_invalid_credential.
  ///
  /// In en, this message translates to:
  /// **'The supplied auth credential is incorrect, malformed or has expired.'**
  String get toast_login_invalid_credential;

  /// No description provided for @toast_login_generic_error.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again.'**
  String get toast_login_generic_error;

  /// No description provided for @toast_delete_success.
  ///
  /// In en, this message translates to:
  /// **'Account deleted successfully'**
  String get toast_delete_success;

  /// No description provided for @toast_delete_google.
  ///
  /// In en, this message translates to:
  /// **'Re-authentication with Google failed.'**
  String get toast_delete_google;

  /// No description provided for @toast_delete_user_data.
  ///
  /// In en, this message translates to:
  /// **'Error deleting user data: '**
  String get toast_delete_user_data;

  /// No description provided for @toast_delete_user_storage.
  ///
  /// In en, this message translates to:
  /// **'Error deleting user storage: '**
  String get toast_delete_user_storage;

  /// No description provided for @toast_delete_user_history.
  ///
  /// In en, this message translates to:
  /// **'Error deleting user history: '**
  String get toast_delete_user_history;

  /// No description provided for @toast_delete_generic_error.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again.'**
  String get toast_delete_generic_error;

  /// No description provided for @validator_name_empty.
  ///
  /// In en, this message translates to:
  /// **'Name cannot be empty'**
  String get validator_name_empty;

  /// No description provided for @validator_name_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get validator_name_hint;

  /// No description provided for @validator_name_required.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get validator_name_required;

  /// No description provided for @validator_name_error.
  ///
  /// In en, this message translates to:
  /// **'Invalid name: '**
  String get validator_name_error;

  /// No description provided for @validator_email_missing_special.
  ///
  /// In en, this message translates to:
  /// **'Missing @ symbol'**
  String get validator_email_missing_special;

  /// No description provided for @validator_email_missing_dot.
  ///
  /// In en, this message translates to:
  /// **'Missing . symbol'**
  String get validator_email_missing_dot;

  /// No description provided for @validator_email_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get validator_email_hint;

  /// No description provided for @validator_email_required.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get validator_email_required;

  /// No description provided for @validator_email_error.
  ///
  /// In en, this message translates to:
  /// **'Invalid email: '**
  String get validator_email_error;

  /// No description provided for @validator_password_missing_upper.
  ///
  /// In en, this message translates to:
  /// **'Missing uppercase letter'**
  String get validator_password_missing_upper;

  /// No description provided for @validator_password_missing_lower.
  ///
  /// In en, this message translates to:
  /// **'Missing lowercase letter'**
  String get validator_password_missing_lower;

  /// No description provided for @validator_password_missing_digit.
  ///
  /// In en, this message translates to:
  /// **'Missing digit'**
  String get validator_password_missing_digit;

  /// No description provided for @validator_password_missing_special.
  ///
  /// In en, this message translates to:
  /// **'Missing special character'**
  String get validator_password_missing_special;

  /// No description provided for @validator_password_missing_lenght.
  ///
  /// In en, this message translates to:
  /// **'Password should be at least 8 characters long'**
  String get validator_password_missing_lenght;

  /// No description provided for @validator_password_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get validator_password_hint;

  /// No description provided for @validator_password_required.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get validator_password_required;

  /// No description provided for @validator_password_error.
  ///
  /// In en, this message translates to:
  /// **'Invalid password: '**
  String get validator_password_error;

  /// No description provided for @permission_camera_denied.
  ///
  /// In en, this message translates to:
  /// **'Camera permission denied'**
  String get permission_camera_denied;

  /// No description provided for @permission_camera_toast.
  ///
  /// In en, this message translates to:
  /// **'Grant camera permission from settings'**
  String get permission_camera_toast;

  /// No description provided for @permission_contacts_denied.
  ///
  /// In en, this message translates to:
  /// **'Contacts permission denied'**
  String get permission_contacts_denied;

  /// No description provided for @permission_contacts_toast.
  ///
  /// In en, this message translates to:
  /// **'Grant contacts permission from settings'**
  String get permission_contacts_toast;

  /// No description provided for @permission_storage_denied.
  ///
  /// In en, this message translates to:
  /// **'Storage permission denied'**
  String get permission_storage_denied;

  /// No description provided for @permission_storage_toast.
  ///
  /// In en, this message translates to:
  /// **'Grant storage permission from settings'**
  String get permission_storage_toast;

  /// No description provided for @bottom_nav_item_scan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get bottom_nav_item_scan;

  /// No description provided for @bottom_nav_item_create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get bottom_nav_item_create;

  /// No description provided for @bottom_nav_item_favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get bottom_nav_item_favorites;

  /// No description provided for @bottom_nav_item_history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get bottom_nav_item_history;

  /// No description provided for @bottom_nav_item_settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get bottom_nav_item_settings;

  /// No description provided for @home_recent_qr_codes.
  ///
  /// In en, this message translates to:
  /// **'Recent QR codes'**
  String get home_recent_qr_codes;

  /// No description provided for @tab_created.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get tab_created;

  /// No description provided for @tab_scanned.
  ///
  /// In en, this message translates to:
  /// **'Scanned'**
  String get tab_scanned;

  /// No description provided for @code_create_types_screen_title.
  ///
  /// In en, this message translates to:
  /// **'Select QR Type'**
  String get code_create_types_screen_title;

  /// No description provided for @code_create_types_screen_standard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get code_create_types_screen_standard;

  /// No description provided for @code_create_types_screen_social.
  ///
  /// In en, this message translates to:
  /// **'Social'**
  String get code_create_types_screen_social;

  /// No description provided for @code_create_standard_screen_text_label.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get code_create_standard_screen_text_label;

  /// No description provided for @code_create_standard_screen_url_label.
  ///
  /// In en, this message translates to:
  /// **'URL'**
  String get code_create_standard_screen_url_label;

  /// No description provided for @code_create_standard_screen_email_address_label.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get code_create_standard_screen_email_address_label;

  /// No description provided for @code_create_standard_screen_email_subject_label.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get code_create_standard_screen_email_subject_label;

  /// No description provided for @code_create_standard_screen_email_body_label.
  ///
  /// In en, this message translates to:
  /// **'Body'**
  String get code_create_standard_screen_email_body_label;

  /// No description provided for @code_create_standard_screen_phone_label.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get code_create_standard_screen_phone_label;

  /// No description provided for @code_create_standard_screen_sms_phone_label.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get code_create_standard_screen_sms_phone_label;

  /// No description provided for @code_create_standard_screen_sms_message_label.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get code_create_standard_screen_sms_message_label;

  /// No description provided for @code_create_standard_screen_contact_name_label.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get code_create_standard_screen_contact_name_label;

  /// No description provided for @code_create_standard_screen_contact_surname_label.
  ///
  /// In en, this message translates to:
  /// **'Surname'**
  String get code_create_standard_screen_contact_surname_label;

  /// No description provided for @code_create_standard_screen_contact_phone_label.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get code_create_standard_screen_contact_phone_label;

  /// No description provided for @code_create_standard_screen_contact_email_label.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get code_create_standard_screen_contact_email_label;

  /// No description provided for @code_create_standard_screen_geo_latitude_label.
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get code_create_standard_screen_geo_latitude_label;

  /// No description provided for @code_create_standard_screen_geo_longitude_label.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get code_create_standard_screen_geo_longitude_label;

  /// No description provided for @code_create_standard_screen_geo_select_button.
  ///
  /// In en, this message translates to:
  /// **'Select Location'**
  String get code_create_standard_screen_geo_select_button;

  /// No description provided for @code_create_standard_screen_wifi_ssid_label.
  ///
  /// In en, this message translates to:
  /// **'SSID'**
  String get code_create_standard_screen_wifi_ssid_label;

  /// No description provided for @code_create_standard_screen_wifi_password_label.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get code_create_standard_screen_wifi_password_label;

  /// No description provided for @code_create_standard_screen_wifi_type_label.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get code_create_standard_screen_wifi_type_label;

  /// No description provided for @code_create_standard_screen_wifi_hidden_label.
  ///
  /// In en, this message translates to:
  /// **'Hidden'**
  String get code_create_standard_screen_wifi_hidden_label;

  /// No description provided for @code_create_standard_screen_calendar_title_label.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get code_create_standard_screen_calendar_title_label;

  /// No description provided for @code_create_standard_screen_calendar_start_date_label.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get code_create_standard_screen_calendar_start_date_label;

  /// No description provided for @code_create_standard_screen_calendar_end_date_label.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get code_create_standard_screen_calendar_end_date_label;

  /// No description provided for @code_create_standard_screen_calendar_location_label.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get code_create_standard_screen_calendar_location_label;

  /// No description provided for @code_create_standard_screen_product_label.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get code_create_standard_screen_product_label;

  /// No description provided for @code_create_standard_screen_isbn_label.
  ///
  /// In en, this message translates to:
  /// **'ISBN'**
  String get code_create_standard_screen_isbn_label;

  /// No description provided for @code_create_standard_screen_error_url_www.
  ///
  /// In en, this message translates to:
  /// **'The content must start with \'www\' or \'http\'.'**
  String get code_create_standard_screen_error_url_www;

  /// No description provided for @code_create_standard_screen_error_url_length.
  ///
  /// In en, this message translates to:
  /// **'The content must be at least 7 characters long.'**
  String get code_create_standard_screen_error_url_length;

  /// No description provided for @code_create_standard_screen_validator_field_a.
  ///
  /// In en, this message translates to:
  /// **'The field'**
  String get code_create_standard_screen_validator_field_a;

  /// No description provided for @code_create_standard_screen_validator_field_b.
  ///
  /// In en, this message translates to:
  /// **'can\'t be empty'**
  String get code_create_standard_screen_validator_field_b;

  /// No description provided for @code_create_standard_screen_validator_url.
  ///
  /// In en, this message translates to:
  /// **'URL field is empty'**
  String get code_create_standard_screen_validator_url;

  /// No description provided for @code_create_standard_screen_validator_number.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number'**
  String get code_create_standard_screen_validator_number;

  /// No description provided for @code_create_standard_screen_eye_title.
  ///
  /// In en, this message translates to:
  /// **'Eye'**
  String get code_create_standard_screen_eye_title;

  /// No description provided for @code_create_standard_screen_eye_color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get code_create_standard_screen_eye_color;

  /// No description provided for @code_create_standard_screen_eye_rounded.
  ///
  /// In en, this message translates to:
  /// **'Rounded'**
  String get code_create_standard_screen_eye_rounded;

  /// No description provided for @code_create_standard_screen_module_title.
  ///
  /// In en, this message translates to:
  /// **'Module'**
  String get code_create_standard_screen_module_title;

  /// No description provided for @code_create_standard_screen_module_color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get code_create_standard_screen_module_color;

  /// No description provided for @code_create_standard_screen_module_rounded.
  ///
  /// In en, this message translates to:
  /// **'Rounded'**
  String get code_create_standard_screen_module_rounded;

  /// No description provided for @code_create_standard_screen_logo_title.
  ///
  /// In en, this message translates to:
  /// **'Logo'**
  String get code_create_standard_screen_logo_title;

  /// No description provided for @qr_style_pick_logo.
  ///
  /// In en, this message translates to:
  /// **'Choose a logo'**
  String get qr_style_pick_logo;

  /// No description provided for @code_create_standard_screen_dialog_color_text.
  ///
  /// In en, this message translates to:
  /// **'Choose a color'**
  String get code_create_standard_screen_dialog_color_text;

  /// No description provided for @code_create_standard_screen_dialog_color_select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get code_create_standard_screen_dialog_color_select;

  /// No description provided for @code_create_standard_screen_create_button.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get code_create_standard_screen_create_button;

  /// No description provided for @code_create_preview_title.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get code_create_preview_title;

  /// No description provided for @qr_preview_semantics.
  ///
  /// In en, this message translates to:
  /// **'QR code preview'**
  String get qr_preview_semantics;

  /// No description provided for @code_create_style_title.
  ///
  /// In en, this message translates to:
  /// **'Style'**
  String get code_create_style_title;

  /// No description provided for @code_create_standard_screen_toast_success.
  ///
  /// In en, this message translates to:
  /// **'QR code successfully added!'**
  String get code_create_standard_screen_toast_success;

  /// No description provided for @code_create_standard_screen_toast_error.
  ///
  /// In en, this message translates to:
  /// **'Error saving QR code:'**
  String get code_create_standard_screen_toast_error;

  /// No description provided for @code_create_social_screen_url_label.
  ///
  /// In en, this message translates to:
  /// **'Insert URL'**
  String get code_create_social_screen_url_label;

  /// No description provided for @code_create_social_screen_url_validator.
  ///
  /// In en, this message translates to:
  /// **'Please enter a URL'**
  String get code_create_social_screen_url_validator;

  /// No description provided for @code_create_social_screen_url_details_validator.
  ///
  /// In en, this message translates to:
  /// **'Please enter more details to complete the URL'**
  String get code_create_social_screen_url_details_validator;

  /// No description provided for @code_create_social_screen_whatsapp_label.
  ///
  /// In en, this message translates to:
  /// **'Insert WhatsApp Number'**
  String get code_create_social_screen_whatsapp_label;

  /// No description provided for @code_create_social_screen_whatsapp_validator.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number'**
  String get code_create_social_screen_whatsapp_validator;

  /// No description provided for @code_create_social_screen_spotify_artist_label.
  ///
  /// In en, this message translates to:
  /// **'Insert Artist Name'**
  String get code_create_social_screen_spotify_artist_label;

  /// No description provided for @code_create_social_screen_spotify_artist_validator.
  ///
  /// In en, this message translates to:
  /// **'Please enter an artist name'**
  String get code_create_social_screen_spotify_artist_validator;

  /// No description provided for @code_create_social_screen_spotify_song_label.
  ///
  /// In en, this message translates to:
  /// **'Insert Song Name'**
  String get code_create_social_screen_spotify_song_label;

  /// No description provided for @code_create_social_screen_spotify_song_validator.
  ///
  /// In en, this message translates to:
  /// **'Please enter a song name'**
  String get code_create_social_screen_spotify_song_validator;

  /// No description provided for @code_create_social_screen_error_url.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get code_create_social_screen_error_url;

  /// No description provided for @code_create_social_screen_error_url_www.
  ///
  /// In en, this message translates to:
  /// **'The content must start with \'www\' or \'http\'.'**
  String get code_create_social_screen_error_url_www;

  /// No description provided for @code_create_social_screen_error_url_length.
  ///
  /// In en, this message translates to:
  /// **'The content must be at least 7 characters long.'**
  String get code_create_social_screen_error_url_length;

  /// No description provided for @code_create_social_screen_validator_url.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid URL'**
  String get code_create_social_screen_validator_url;

  /// No description provided for @code_create_social_screen_eye_title.
  ///
  /// In en, this message translates to:
  /// **'Eye'**
  String get code_create_social_screen_eye_title;

  /// No description provided for @code_create_social_screen_eye_color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get code_create_social_screen_eye_color;

  /// No description provided for @code_create_social_screen_eye_rounded.
  ///
  /// In en, this message translates to:
  /// **'Rounded'**
  String get code_create_social_screen_eye_rounded;

  /// No description provided for @code_create_social_screen_module_title.
  ///
  /// In en, this message translates to:
  /// **'Module'**
  String get code_create_social_screen_module_title;

  /// No description provided for @code_create_social_screen_module_color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get code_create_social_screen_module_color;

  /// No description provided for @code_create_social_screen_module_rounded.
  ///
  /// In en, this message translates to:
  /// **'Rounded'**
  String get code_create_social_screen_module_rounded;

  /// No description provided for @code_create_social_screen_logo_title.
  ///
  /// In en, this message translates to:
  /// **'Logo'**
  String get code_create_social_screen_logo_title;

  /// No description provided for @code_create_social_screen_dialog_color_text.
  ///
  /// In en, this message translates to:
  /// **'Choose a color'**
  String get code_create_social_screen_dialog_color_text;

  /// No description provided for @code_create_social_screen_dialog_color_select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get code_create_social_screen_dialog_color_select;

  /// No description provided for @code_create_social_screen_create_button.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get code_create_social_screen_create_button;

  /// No description provided for @code_create_social_screen_toast_success.
  ///
  /// In en, this message translates to:
  /// **'QR code successfully added!'**
  String get code_create_social_screen_toast_success;

  /// No description provided for @code_create_social_screen_toast_error.
  ///
  /// In en, this message translates to:
  /// **'Error saving QR code:'**
  String get code_create_social_screen_toast_error;

  /// No description provided for @code_scanner_screen_title.
  ///
  /// In en, this message translates to:
  /// **'QR Scanner'**
  String get code_scanner_screen_title;

  /// No description provided for @code_scanner_screen_camera_hint.
  ///
  /// In en, this message translates to:
  /// **'Scan the QR code'**
  String get code_scanner_screen_camera_hint;

  /// No description provided for @code_scanner_screen_tooltip_gallery.
  ///
  /// In en, this message translates to:
  /// **'Scan from an image'**
  String get code_scanner_screen_tooltip_gallery;

  /// No description provided for @code_scanner_screen_tooltip_torch_on.
  ///
  /// In en, this message translates to:
  /// **'Turn on the flashlight'**
  String get code_scanner_screen_tooltip_torch_on;

  /// No description provided for @code_scanner_screen_tooltip_torch_off.
  ///
  /// In en, this message translates to:
  /// **'Turn off the flashlight'**
  String get code_scanner_screen_tooltip_torch_off;

  /// No description provided for @code_scanner_screen_tooltip_switch_camera.
  ///
  /// In en, this message translates to:
  /// **'Switch camera'**
  String get code_scanner_screen_tooltip_switch_camera;

  /// No description provided for @code_scanner_screen_image_scan_toast_error.
  ///
  /// In en, this message translates to:
  /// **'Failed to scan QR code:'**
  String get code_scanner_screen_image_scan_toast_error;

  /// No description provided for @code_scanner_screen_image_empty_toast_error.
  ///
  /// In en, this message translates to:
  /// **'No image selected'**
  String get code_scanner_screen_image_empty_toast_error;

  /// No description provided for @code_scanner_screen_scan_qr_empty_toast_error.
  ///
  /// In en, this message translates to:
  /// **'No QR code found in the image'**
  String get code_scanner_screen_scan_qr_empty_toast_error;

  /// No description provided for @code_scanner_screen_scan_qr_read_toast_error.
  ///
  /// In en, this message translates to:
  /// **'Failed to read QR code:'**
  String get code_scanner_screen_scan_qr_read_toast_error;

  /// No description provided for @code_scanner_screen_scan_qr_decode_toast_error.
  ///
  /// In en, this message translates to:
  /// **'Failed to decode image'**
  String get code_scanner_screen_scan_qr_decode_toast_error;

  /// No description provided for @code_details_screen_title.
  ///
  /// In en, this message translates to:
  /// **'QR Code Details'**
  String get code_details_screen_title;

  /// No description provided for @code_details_screen_date_title.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get code_details_screen_date_title;

  /// No description provided for @code_details_screen_type_title.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get code_details_screen_type_title;

  /// No description provided for @code_details_screen_title_title.
  ///
  /// In en, this message translates to:
  /// **'QR Code'**
  String get code_details_screen_title_title;

  /// No description provided for @code_details_screen_content_title.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get code_details_screen_content_title;

  /// No description provided for @code_details_screen_action_text.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get code_details_screen_action_text;

  /// No description provided for @code_details_screen_action_url.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get code_details_screen_action_url;

  /// No description provided for @code_details_screen_action_email.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get code_details_screen_action_email;

  /// No description provided for @code_details_screen_action_phone.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get code_details_screen_action_phone;

  /// No description provided for @code_details_screen_action_sms.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get code_details_screen_action_sms;

  /// No description provided for @code_details_screen_action_contact.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get code_details_screen_action_contact;

  /// No description provided for @code_details_screen_action_geo.
  ///
  /// In en, this message translates to:
  /// **'Navigate'**
  String get code_details_screen_action_geo;

  /// No description provided for @code_details_screen_action_wifi.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get code_details_screen_action_wifi;

  /// No description provided for @code_details_screen_action_calendar.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get code_details_screen_action_calendar;

  /// No description provided for @code_details_screen_product.
  ///
  /// In en, this message translates to:
  /// **'Product Code'**
  String get code_details_screen_product;

  /// No description provided for @code_details_screen_action_product.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get code_details_screen_action_product;

  /// No description provided for @code_details_screen_isbn.
  ///
  /// In en, this message translates to:
  /// **'ISBN Code'**
  String get code_details_screen_isbn;

  /// No description provided for @code_details_screen_action_isbn.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get code_details_screen_action_isbn;

  /// No description provided for @code_details_screen_action_button_copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get code_details_screen_action_button_copy;

  /// No description provided for @code_details_screen_action_button_favorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get code_details_screen_action_button_favorite;

  /// No description provided for @code_details_screen_action_button_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get code_details_screen_action_button_save;

  /// No description provided for @code_details_screen_action_button_share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get code_details_screen_action_button_share;

  /// No description provided for @code_details_screen_result_copy.
  ///
  /// In en, this message translates to:
  /// **'Content copied to clipboard!'**
  String get code_details_screen_result_copy;

  /// No description provided for @code_details_screen_result_contact.
  ///
  /// In en, this message translates to:
  /// **'Contact added!'**
  String get code_details_screen_result_contact;

  /// No description provided for @code_details_screen_result_wifi.
  ///
  /// In en, this message translates to:
  /// **'WiFi saved and connected!'**
  String get code_details_screen_result_wifi;

  /// No description provided for @code_details_screen_result_product_amazon.
  ///
  /// In en, this message translates to:
  /// **'Search on Amazon'**
  String get code_details_screen_result_product_amazon;

  /// No description provided for @code_details_screen_result_product_ebay.
  ///
  /// In en, this message translates to:
  /// **'Search on Ebay'**
  String get code_details_screen_result_product_ebay;

  /// No description provided for @code_details_screen_result_product_google.
  ///
  /// In en, this message translates to:
  /// **'Search on Google'**
  String get code_details_screen_result_product_google;

  /// No description provided for @code_details_screen_result_isbn_google_books.
  ///
  /// In en, this message translates to:
  /// **'Search on Google Books'**
  String get code_details_screen_result_isbn_google_books;

  /// No description provided for @code_details_screen_result_isbn_amazon.
  ///
  /// In en, this message translates to:
  /// **'Search on Amazon'**
  String get code_details_screen_result_isbn_amazon;

  /// No description provided for @code_details_screen_result_isbn_goodreads.
  ///
  /// In en, this message translates to:
  /// **'Search on Goodreads'**
  String get code_details_screen_result_isbn_goodreads;

  /// No description provided for @code_details_screen_toast_success.
  ///
  /// In en, this message translates to:
  /// **'QR code saved to gallery'**
  String get code_details_screen_toast_success;

  /// No description provided for @code_details_screen_toast_error.
  ///
  /// In en, this message translates to:
  /// **'Error saving QR code'**
  String get code_details_screen_toast_error;

  /// No description provided for @code_details_screen_toast_error_link.
  ///
  /// In en, this message translates to:
  /// **'Unable to open link'**
  String get code_details_screen_toast_error_link;

  /// No description provided for @code_details_screen_menu_notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get code_details_screen_menu_notes;

  /// No description provided for @code_details_screen_menu_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get code_details_screen_menu_delete;

  /// No description provided for @code_details_screen_notes_title.
  ///
  /// In en, this message translates to:
  /// **'Add notes'**
  String get code_details_screen_notes_title;

  /// No description provided for @code_details_screen_notes_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter your notes here'**
  String get code_details_screen_notes_hint;

  /// No description provided for @code_details_screen_notes_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get code_details_screen_notes_cancel;

  /// No description provided for @code_details_screen_notes_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get code_details_screen_notes_save;

  /// No description provided for @code_details_screen_delete_title.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get code_details_screen_delete_title;

  /// No description provided for @code_details_screen_delete_description.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this code?'**
  String get code_details_screen_delete_description;

  /// No description provided for @code_details_screen_delete_toast_success.
  ///
  /// In en, this message translates to:
  /// **'Code deleted!'**
  String get code_details_screen_delete_toast_success;

  /// No description provided for @favorites_screen_tab_created.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get favorites_screen_tab_created;

  /// No description provided for @favorites_screen_tab_scanned.
  ///
  /// In en, this message translates to:
  /// **'Scanned'**
  String get favorites_screen_tab_scanned;

  /// No description provided for @favorites_screen_error_state.
  ///
  /// In en, this message translates to:
  /// **'Error:'**
  String get favorites_screen_error_state;

  /// No description provided for @favorites_screen_empty_state.
  ///
  /// In en, this message translates to:
  /// **'No favorites codes'**
  String get favorites_screen_empty_state;

  /// No description provided for @favorites_screen_empty_action.
  ///
  /// In en, this message translates to:
  /// **'Create your first code'**
  String get favorites_screen_empty_action;

  /// No description provided for @history_screen_search_label.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get history_screen_search_label;

  /// No description provided for @history_screen_filter_all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get history_screen_filter_all;

  /// No description provided for @history_screen_filter_created.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get history_screen_filter_created;

  /// No description provided for @history_screen_filter_scanned.
  ///
  /// In en, this message translates to:
  /// **'Scanned'**
  String get history_screen_filter_scanned;

  /// No description provided for @history_filter_sheet_title.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get history_filter_sheet_title;

  /// No description provided for @history_filter_sheet_source.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get history_filter_sheet_source;

  /// No description provided for @history_filter_sheet_types.
  ///
  /// In en, this message translates to:
  /// **'Code type'**
  String get history_filter_sheet_types;

  /// No description provided for @history_filter_sheet_social.
  ///
  /// In en, this message translates to:
  /// **'Social'**
  String get history_filter_sheet_social;

  /// No description provided for @history_filter_sheet_show_results.
  ///
  /// In en, this message translates to:
  /// **'Show results'**
  String get history_filter_sheet_show_results;

  /// No description provided for @history_screen_error_state.
  ///
  /// In en, this message translates to:
  /// **'Error:'**
  String get history_screen_error_state;

  /// No description provided for @history_screen_delete_title.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get history_screen_delete_title;

  /// No description provided for @sync_status_offline.
  ///
  /// In en, this message translates to:
  /// **'You are offline: showing codes saved on this device'**
  String get sync_status_offline;

  /// No description provided for @sync_status_pending.
  ///
  /// In en, this message translates to:
  /// **'Changes waiting to be synced'**
  String get sync_status_pending;

  /// No description provided for @sync_refresh_offline.
  ///
  /// In en, this message translates to:
  /// **'Can\'t refresh: no connection'**
  String get sync_refresh_offline;

  /// No description provided for @history_screen_empty_state.
  ///
  /// In en, this message translates to:
  /// **'No saved codes'**
  String get history_screen_empty_state;

  /// No description provided for @history_screen_empty_action.
  ///
  /// In en, this message translates to:
  /// **'Scan now'**
  String get history_screen_empty_action;

  /// No description provided for @history_screen_empty_filtered.
  ///
  /// In en, this message translates to:
  /// **'No results for the active filters'**
  String get history_screen_empty_filtered;

  /// No description provided for @history_screen_clear_filters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get history_screen_clear_filters;

  /// No description provided for @history_screen_selected_count.
  ///
  /// In en, this message translates to:
  /// **'selected'**
  String get history_screen_selected_count;

  /// No description provided for @history_screen_select_all.
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get history_screen_select_all;

  /// No description provided for @history_screen_deselect_all.
  ///
  /// In en, this message translates to:
  /// **'Deselect all'**
  String get history_screen_deselect_all;

  /// No description provided for @history_screen_delete_selected_description.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the selected codes?'**
  String get history_screen_delete_selected_description;

  /// No description provided for @history_screen_delete_selected_toast_success.
  ///
  /// In en, this message translates to:
  /// **'Selected codes have been successfully deleted!'**
  String get history_screen_delete_selected_toast_success;

  /// No description provided for @history_screen_deleted_count.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 code deleted} other{{count} codes deleted}}'**
  String history_screen_deleted_count(int count);

  /// No description provided for @history_screen_tooltip_close_selection.
  ///
  /// In en, this message translates to:
  /// **'Exit selection mode'**
  String get history_screen_tooltip_close_selection;

  /// No description provided for @history_screen_tooltip_clear_search.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get history_screen_tooltip_clear_search;

  /// No description provided for @history_screen_tooltip_filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get history_screen_tooltip_filter;

  /// No description provided for @history_screen_tooltip_select_mode.
  ///
  /// In en, this message translates to:
  /// **'Select codes'**
  String get history_screen_tooltip_select_mode;

  /// No description provided for @history_screen_tooltip_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get history_screen_tooltip_delete;

  /// No description provided for @history_screen_tooltip_details.
  ///
  /// In en, this message translates to:
  /// **'View details'**
  String get history_screen_tooltip_details;

  /// No description provided for @settings_title_general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get settings_title_general;

  /// No description provided for @settings_title_theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settings_title_theme;

  /// No description provided for @settings_subtitle_theme_option_light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settings_subtitle_theme_option_light;

  /// No description provided for @settings_subtitle_theme_option_dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settings_subtitle_theme_option_dark;

  /// No description provided for @settings_subtitle_theme_option_system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settings_subtitle_theme_option_system;

  /// No description provided for @settings_title_language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settings_title_language;

  /// No description provided for @settings_subtitle_language_option_english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settings_subtitle_language_option_english;

  /// No description provided for @settings_subtitle_language_option_italian.
  ///
  /// In en, this message translates to:
  /// **'Italian'**
  String get settings_subtitle_language_option_italian;

  /// No description provided for @settings_title_accent_color.
  ///
  /// In en, this message translates to:
  /// **'Accent color'**
  String get settings_title_accent_color;

  /// No description provided for @settings_accent_color_blue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get settings_accent_color_blue;

  /// No description provided for @settings_accent_color_green.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get settings_accent_color_green;

  /// No description provided for @settings_accent_color_purple.
  ///
  /// In en, this message translates to:
  /// **'Purple'**
  String get settings_accent_color_purple;

  /// No description provided for @settings_accent_color_red.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get settings_accent_color_red;

  /// No description provided for @settings_accent_color_teal.
  ///
  /// In en, this message translates to:
  /// **'Teal'**
  String get settings_accent_color_teal;

  /// No description provided for @settings_accent_color_orange.
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get settings_accent_color_orange;

  /// No description provided for @settings_accent_color_pink.
  ///
  /// In en, this message translates to:
  /// **'Pink'**
  String get settings_accent_color_pink;

  /// No description provided for @settings_accent_color_grey.
  ///
  /// In en, this message translates to:
  /// **'Grey'**
  String get settings_accent_color_grey;

  /// No description provided for @settings_title_scan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get settings_title_scan;

  /// No description provided for @settings_title_beep.
  ///
  /// In en, this message translates to:
  /// **'Beep'**
  String get settings_title_beep;

  /// No description provided for @settings_subtile_beep.
  ///
  /// In en, this message translates to:
  /// **'Enable a sound when scanning a code'**
  String get settings_subtile_beep;

  /// No description provided for @settings_title_vibrate.
  ///
  /// In en, this message translates to:
  /// **'Vibrate'**
  String get settings_title_vibrate;

  /// No description provided for @settings_subtile_vibrate.
  ///
  /// In en, this message translates to:
  /// **'Enable a vibration when scanning a code'**
  String get settings_subtile_vibrate;

  /// No description provided for @settings_title_account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settings_title_account;

  /// No description provided for @settings_tile_account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settings_tile_account;

  /// No description provided for @settings_tile_profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get settings_tile_profile;

  /// No description provided for @settings_tile_database.
  ///
  /// In en, this message translates to:
  /// **'Database'**
  String get settings_tile_database;

  /// No description provided for @settings_tile_log_out.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get settings_tile_log_out;

  /// No description provided for @settings_tile_delete_account.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get settings_tile_delete_account;

  /// No description provided for @settings_title_app.
  ///
  /// In en, this message translates to:
  /// **'App'**
  String get settings_title_app;

  /// No description provided for @settings_tile_info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get settings_tile_info;

  /// No description provided for @settings_tile_changelog.
  ///
  /// In en, this message translates to:
  /// **'Changelog'**
  String get settings_tile_changelog;

  /// No description provided for @settings_tile_support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get settings_tile_support;

  /// No description provided for @settings_tile_share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get settings_tile_share;

  /// No description provided for @database_screen_title.
  ///
  /// In en, this message translates to:
  /// **'Database'**
  String get database_screen_title;

  /// No description provided for @database_screen_account_title.
  ///
  /// In en, this message translates to:
  /// **'Account Info'**
  String get database_screen_account_title;

  /// No description provided for @database_screen_account_field_userid.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get database_screen_account_field_userid;

  /// No description provided for @database_screen_account_field_name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get database_screen_account_field_name;

  /// No description provided for @database_screen_account_field_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get database_screen_account_field_email;

  /// No description provided for @database_screen_account_field_date.
  ///
  /// In en, this message translates to:
  /// **'Account Created'**
  String get database_screen_account_field_date;

  /// No description provided for @database_screen_codes_field_total_title.
  ///
  /// In en, this message translates to:
  /// **'Codes Statistics'**
  String get database_screen_codes_field_total_title;

  /// No description provided for @database_screen_codes_field_total_saved.
  ///
  /// In en, this message translates to:
  /// **'Saved codes'**
  String get database_screen_codes_field_total_saved;

  /// No description provided for @database_screen_codes_field_created_title.
  ///
  /// In en, this message translates to:
  /// **'Created codes'**
  String get database_screen_codes_field_created_title;

  /// No description provided for @database_screen_codes_field_created_totals.
  ///
  /// In en, this message translates to:
  /// **'Totals'**
  String get database_screen_codes_field_created_totals;

  /// No description provided for @database_screen_codes_field_scanned_title.
  ///
  /// In en, this message translates to:
  /// **'Scanned codes'**
  String get database_screen_codes_field_scanned_title;

  /// No description provided for @database_screen_codes_field_scanned_totals.
  ///
  /// In en, this message translates to:
  /// **'Totals'**
  String get database_screen_codes_field_scanned_totals;

  /// No description provided for @database_screen_codes_field_standard_title.
  ///
  /// In en, this message translates to:
  /// **'Standard codes'**
  String get database_screen_codes_field_standard_title;

  /// No description provided for @database_screen_codes_field_social_title.
  ///
  /// In en, this message translates to:
  /// **'Social codes'**
  String get database_screen_codes_field_social_title;

  /// No description provided for @database_screen_codes_field_empty.
  ///
  /// In en, this message translates to:
  /// **'No codes available'**
  String get database_screen_codes_field_empty;

  /// No description provided for @database_screen_codes_dialog_standard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get database_screen_codes_dialog_standard;

  /// No description provided for @database_screen_codes_dialog_social.
  ///
  /// In en, this message translates to:
  /// **'Social'**
  String get database_screen_codes_dialog_social;

  /// No description provided for @database_screen_codes_dialog_close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get database_screen_codes_dialog_close;

  /// No description provided for @database_screen_export_title.
  ///
  /// In en, this message translates to:
  /// **'Export option'**
  String get database_screen_export_title;

  /// No description provided for @database_screen_pdf_download.
  ///
  /// In en, this message translates to:
  /// **'PDF'**
  String get database_screen_pdf_download;

  /// No description provided for @database_screen_pdf_confirm.
  ///
  /// In en, this message translates to:
  /// **'PDF saved in the Download folder'**
  String get database_screen_pdf_confirm;

  /// No description provided for @database_screen_pdf_error.
  ///
  /// In en, this message translates to:
  /// **'Unable to generate PDF'**
  String get database_screen_pdf_error;

  /// No description provided for @database_screen_excel_download.
  ///
  /// In en, this message translates to:
  /// **'Excel'**
  String get database_screen_excel_download;

  /// No description provided for @database_screen_excel_confirm.
  ///
  /// In en, this message translates to:
  /// **'Excel saved in the Download folder'**
  String get database_screen_excel_confirm;

  /// No description provided for @database_screen_excel_error.
  ///
  /// In en, this message translates to:
  /// **'Unable to generate Excel'**
  String get database_screen_excel_error;

  /// No description provided for @database_screen_csv_download.
  ///
  /// In en, this message translates to:
  /// **'CSV'**
  String get database_screen_csv_download;

  /// No description provided for @database_screen_csv_confirm.
  ///
  /// In en, this message translates to:
  /// **'CSV saved in the Download folder'**
  String get database_screen_csv_confirm;

  /// No description provided for @database_screen_csv_error.
  ///
  /// In en, this message translates to:
  /// **'Unable to generate CSV'**
  String get database_screen_csv_error;

  /// No description provided for @database_screen_export_menu.
  ///
  /// In en, this message translates to:
  /// **'Export JSON'**
  String get database_screen_export_menu;

  /// No description provided for @database_screen_import_menu.
  ///
  /// In en, this message translates to:
  /// **'Import JSON'**
  String get database_screen_import_menu;

  /// No description provided for @database_screen_backup_title.
  ///
  /// In en, this message translates to:
  /// **'JSON backup'**
  String get database_screen_backup_title;

  /// No description provided for @database_screen_backup_last_export.
  ///
  /// In en, this message translates to:
  /// **'Last export'**
  String get database_screen_backup_last_export;

  /// No description provided for @database_screen_backup_last_import.
  ///
  /// In en, this message translates to:
  /// **'Last import'**
  String get database_screen_backup_last_import;

  /// No description provided for @database_screen_backup_never.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get database_screen_backup_never;

  /// No description provided for @database_screen_export_success.
  ///
  /// In en, this message translates to:
  /// **'JSON exported in the Download folder'**
  String get database_screen_export_success;

  /// No description provided for @database_screen_export_error.
  ///
  /// In en, this message translates to:
  /// **'Error during export'**
  String get database_screen_export_error;

  /// No description provided for @database_screen_import_success.
  ///
  /// In en, this message translates to:
  /// **'JSON successfully imported!'**
  String get database_screen_import_success;

  /// No description provided for @database_screen_import_error.
  ///
  /// In en, this message translates to:
  /// **'Error during import'**
  String get database_screen_import_error;

  /// No description provided for @database_service_codes_field_id.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get database_service_codes_field_id;

  /// No description provided for @database_service_codes_field_date.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get database_service_codes_field_date;

  /// No description provided for @database_service_codes_field_source.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get database_service_codes_field_source;

  /// No description provided for @database_service_codes_field_type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get database_service_codes_field_type;

  /// No description provided for @database_service_codes_field_code.
  ///
  /// In en, this message translates to:
  /// **'QR code'**
  String get database_service_codes_field_code;

  /// No description provided for @database_service_codes_field_content.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get database_service_codes_field_content;

  /// No description provided for @database_service_codes_field_eye_color.
  ///
  /// In en, this message translates to:
  /// **'Eyes color'**
  String get database_service_codes_field_eye_color;

  /// No description provided for @database_service_codes_field_eye_rounded.
  ///
  /// In en, this message translates to:
  /// **'Rounded eyes'**
  String get database_service_codes_field_eye_rounded;

  /// No description provided for @database_service_codes_field_module_color.
  ///
  /// In en, this message translates to:
  /// **'Modules color'**
  String get database_service_codes_field_module_color;

  /// No description provided for @database_service_codes_field_module_rounded.
  ///
  /// In en, this message translates to:
  /// **'Rounded modules'**
  String get database_service_codes_field_module_rounded;

  /// No description provided for @database_service_codes_field_favorite.
  ///
  /// In en, this message translates to:
  /// **'Preferred'**
  String get database_service_codes_field_favorite;

  /// No description provided for @database_service_codes_field_social.
  ///
  /// In en, this message translates to:
  /// **'Social'**
  String get database_service_codes_field_social;

  /// No description provided for @database_pdf_field_user_title.
  ///
  /// In en, this message translates to:
  /// **'User Information'**
  String get database_pdf_field_user_title;

  /// No description provided for @database_pdf_field_user_id.
  ///
  /// In en, this message translates to:
  /// **'User ID'**
  String get database_pdf_field_user_id;

  /// No description provided for @database_pdf_field_user_name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get database_pdf_field_user_name;

  /// No description provided for @database_pdf_field_user_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get database_pdf_field_user_email;

  /// No description provided for @database_pdf_field_user_date.
  ///
  /// In en, this message translates to:
  /// **'Account Created'**
  String get database_pdf_field_user_date;

  /// No description provided for @database_pdf_field_code_title.
  ///
  /// In en, this message translates to:
  /// **'Codes Statistics'**
  String get database_pdf_field_code_title;

  /// No description provided for @database_pdf_field_code_saved.
  ///
  /// In en, this message translates to:
  /// **'Saved Codes'**
  String get database_pdf_field_code_saved;

  /// No description provided for @database_pdf_field_code_created.
  ///
  /// In en, this message translates to:
  /// **'Created Codes'**
  String get database_pdf_field_code_created;

  /// No description provided for @database_pdf_field_code_created_standard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get database_pdf_field_code_created_standard;

  /// No description provided for @database_pdf_field_code_created_social.
  ///
  /// In en, this message translates to:
  /// **'Social'**
  String get database_pdf_field_code_created_social;

  /// No description provided for @database_pdf_field_code_scanned.
  ///
  /// In en, this message translates to:
  /// **'Scanned Codes'**
  String get database_pdf_field_code_scanned;

  /// No description provided for @database_pdf_field_code_scanned_standard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get database_pdf_field_code_scanned_standard;

  /// No description provided for @database_pdf_field_code_scanned_social.
  ///
  /// In en, this message translates to:
  /// **'Social'**
  String get database_pdf_field_code_scanned_social;

  /// No description provided for @database_pdf_page.
  ///
  /// In en, this message translates to:
  /// **'Page'**
  String get database_pdf_page;

  /// No description provided for @user_screen_title.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get user_screen_title;

  /// No description provided for @user_screen_name_label.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get user_screen_name_label;

  /// No description provided for @user_screen_email_label.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get user_screen_email_label;

  /// No description provided for @user_screen_date_label.
  ///
  /// In en, this message translates to:
  /// **'Joined'**
  String get user_screen_date_label;

  /// No description provided for @user_screen_logout_button.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get user_screen_logout_button;

  /// No description provided for @info_screen_title.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info_screen_title;

  /// No description provided for @info_screen_tagline.
  ///
  /// In en, this message translates to:
  /// **'Scan, create and keep your codes'**
  String get info_screen_tagline;

  /// No description provided for @info_screen_version_text.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get info_screen_version_text;

  /// No description provided for @info_screen_about_title.
  ///
  /// In en, this message translates to:
  /// **'What is QRation'**
  String get info_screen_about_title;

  /// No description provided for @info_screen_about_text.
  ///
  /// In en, this message translates to:
  /// **'QRation lets you scan and create QR codes and barcodes and keeps them in your personal account, always at hand. Every code comes with the action that fits its type: open a link, add a contact or an event, connect to a Wi-Fi network and much more.'**
  String get info_screen_about_text;

  /// No description provided for @info_screen_origin_description.
  ///
  /// In en, this message translates to:
  /// **'The name blends \'QR\' and \'Creation\', the two things the app does: scanning and creating QR codes.'**
  String get info_screen_origin_description;

  /// No description provided for @info_screen_features_title.
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get info_screen_features_title;

  /// No description provided for @info_screen_feature_scan_title.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get info_screen_feature_scan_title;

  /// No description provided for @info_screen_feature_scan_text.
  ///
  /// In en, this message translates to:
  /// **'QR codes and barcodes from the camera or from an image in your gallery.'**
  String get info_screen_feature_scan_text;

  /// No description provided for @info_screen_feature_create_title.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get info_screen_feature_create_title;

  /// No description provided for @info_screen_feature_create_text.
  ///
  /// In en, this message translates to:
  /// **'Codes for links, Wi-Fi, contacts, events and socials, with your own colors and shapes.'**
  String get info_screen_feature_create_text;

  /// No description provided for @info_screen_feature_library_title.
  ///
  /// In en, this message translates to:
  /// **'Organize'**
  String get info_screen_feature_library_title;

  /// No description provided for @info_screen_feature_library_text.
  ///
  /// In en, this message translates to:
  /// **'History and favorites synced with your account, with search and filters.'**
  String get info_screen_feature_library_text;

  /// No description provided for @info_screen_feature_export_title.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get info_screen_feature_export_title;

  /// No description provided for @info_screen_feature_export_text.
  ///
  /// In en, this message translates to:
  /// **'Your codes as PDF, Excel or CSV, plus JSON backup and restore.'**
  String get info_screen_feature_export_text;

  /// No description provided for @info_screen_links_title.
  ///
  /// In en, this message translates to:
  /// **'Useful links'**
  String get info_screen_links_title;

  /// No description provided for @info_screen_link_source.
  ///
  /// In en, this message translates to:
  /// **'Source code'**
  String get info_screen_link_source;

  /// No description provided for @info_screen_link_website.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get info_screen_link_website;

  /// No description provided for @info_screen_link_contact.
  ///
  /// In en, this message translates to:
  /// **'Contact me'**
  String get info_screen_link_contact;

  /// No description provided for @info_screen_link_licenses.
  ///
  /// In en, this message translates to:
  /// **'Open source licenses'**
  String get info_screen_link_licenses;

  /// No description provided for @info_screen_made_by.
  ///
  /// In en, this message translates to:
  /// **'Designed and developed by {name}'**
  String info_screen_made_by(String name);

  /// No description provided for @policy_screen_title.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get policy_screen_title;

  /// No description provided for @policy_screen_intro.
  ///
  /// In en, this message translates to:
  /// **'This policy explains which data QRation processes, why, and how you can manage it. QRation shows no ads, uses no analytics tools and does not sell or share your data.'**
  String get policy_screen_intro;

  /// No description provided for @policy_screen_updated.
  ///
  /// In en, this message translates to:
  /// **'Last updated: {date}'**
  String policy_screen_updated(String date);

  /// No description provided for @policy_screen_online.
  ///
  /// In en, this message translates to:
  /// **'Online version'**
  String get policy_screen_online;

  /// No description provided for @policy_section_controller_title.
  ///
  /// In en, this message translates to:
  /// **'Data controller'**
  String get policy_section_controller_title;

  /// No description provided for @policy_section_controller_text.
  ///
  /// In en, this message translates to:
  /// **'The controller is the app developer, {name}. For any privacy request you can write to {email}.'**
  String policy_section_controller_text(String name, String email);

  /// No description provided for @policy_section_data_title.
  ///
  /// In en, this message translates to:
  /// **'Data we collect'**
  String get policy_section_data_title;

  /// No description provided for @policy_section_data_text.
  ///
  /// In en, this message translates to:
  /// **'• Account: email, name and registration date. With Google sign-in we receive the name, email and profile photo of your Google account. Your password is handled by Firebase Authentication and is never visible to the developer.\n• Codes: for each scanned or created code we save its content (which may include personal data such as contacts, locations, events or Wi-Fi passwords), type, date, source (scanned or created), favorite flag, notes, graphic style and linked social network. The logo chosen for a code stays on your device: only the file path is saved to your account.\n• Crash reports: if the app closes because of an error, Firebase Crashlytics receives a technical report with the error details, device model, system and app version and a random installation identifier.\n• On your device: preferences such as language, theme and accent color, scanner sound and vibration, “remember me”, the screens and release notes you have already seen and the date of your last backup.'**
  String get policy_section_data_text;

  /// No description provided for @policy_section_use_title.
  ///
  /// In en, this message translates to:
  /// **'How we use data'**
  String get policy_section_use_title;

  /// No description provided for @policy_section_use_text.
  ///
  /// In en, this message translates to:
  /// **'Data is used only to make the app work: sign you in, save and sync your codes, show them in History and Favorites and generate the files you export. Crash reports are used only to fix problems in the app. We do not use data for profiling or advertising.'**
  String get policy_section_use_text;

  /// No description provided for @policy_section_storage_title.
  ///
  /// In en, this message translates to:
  /// **'Where it is stored'**
  String get policy_section_storage_title;

  /// No description provided for @policy_section_storage_text.
  ///
  /// In en, this message translates to:
  /// **'Account and codes are stored on Google Firebase (Authentication and Cloud Firestore), crash reports on Firebase Crashlytics: services by Google LLC that may process data outside the European Union with the safeguards set out in their terms. Your data is tied to your account and is not visible to other users. To allow offline use, a copy of your codes is also kept on your device. The map used to pick a location loads its images from OpenStreetMap, which receives your device\'s IP address but no account data.'**
  String get policy_section_storage_text;

  /// No description provided for @policy_section_device_title.
  ///
  /// In en, this message translates to:
  /// **'On-device processing'**
  String get policy_section_device_title;

  /// No description provided for @policy_section_device_text.
  ///
  /// In en, this message translates to:
  /// **'Code reading, from the camera or from a gallery image, runs entirely on your phone: images are not sent to external services. Generated QR codes and the PDF, Excel, CSV and JSON files you export are also created on your device and shared only if you choose to. Code actions (adding a contact or a calendar event, joining a Wi-Fi network, opening a link or a map) start only when you tap them; links and maps open in external apps, which follow their own privacy policies.'**
  String get policy_section_device_text;

  /// No description provided for @policy_section_permissions_title.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get policy_section_permissions_title;

  /// No description provided for @policy_section_permissions_text.
  ///
  /// In en, this message translates to:
  /// **'• Camera: to scan codes.\n• Photos and storage: to pick an image to scan or a code logo, and to save QR codes to the gallery and exported files to the Downloads folder.\n• Contacts: to save the contact read from a code to your address book; your address book is never read or sent.\n• Location: declared by the Wi-Fi library, which needs it on some Android versions to join the network of a Wi-Fi code. The app never reads, saves or sends your location: you pick the point of a location code by tapping the map.\n• Wi-Fi and network: to join the network of a Wi-Fi code and check the connection status.\n• Internet: to sync your account and codes.'**
  String get policy_section_permissions_text;

  /// No description provided for @policy_section_retention_title.
  ///
  /// In en, this message translates to:
  /// **'Retention and deletion'**
  String get policy_section_retention_title;

  /// No description provided for @policy_section_retention_text.
  ///
  /// In en, this message translates to:
  /// **'We keep your account and codes as long as your account exists; you can delete single codes at any time from History. From Settings > Profile > Delete account you can delete the account and all codes; you can export a copy first from Settings > Database. Crash reports are deleted automatically after 90 days. Preferences and logos on your device are removed when you uninstall the app.'**
  String get policy_section_retention_text;

  /// No description provided for @policy_section_rights_title.
  ///
  /// In en, this message translates to:
  /// **'Your rights'**
  String get policy_section_rights_title;

  /// No description provided for @policy_section_rights_text.
  ///
  /// In en, this message translates to:
  /// **'You can access and export your data (PDF, Excel, CSV and JSON), erase it by deleting single codes or your whole account, and ask for corrections or any information by writing to the controller. You can also lodge a complaint with the data protection authority of your country.'**
  String get policy_section_rights_text;

  /// No description provided for @policy_section_children_title.
  ///
  /// In en, this message translates to:
  /// **'Children'**
  String get policy_section_children_title;

  /// No description provided for @policy_section_children_text.
  ///
  /// In en, this message translates to:
  /// **'QRation is not intended for children under 14 and does not knowingly collect their data.'**
  String get policy_section_children_text;

  /// No description provided for @policy_section_changes_title.
  ///
  /// In en, this message translates to:
  /// **'Changes'**
  String get policy_section_changes_title;

  /// No description provided for @policy_section_changes_text.
  ///
  /// In en, this message translates to:
  /// **'If this policy changes, the new version will be available in the app and online, with its update date.'**
  String get policy_section_changes_text;

  /// No description provided for @support_screen_title.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support_screen_title;

  /// No description provided for @support_screen_contacts_text.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get support_screen_contacts_text;

  /// No description provided for @support_screen_contacts_decription.
  ///
  /// In en, this message translates to:
  /// **'For any problems or questions, write to:'**
  String get support_screen_contacts_decription;

  /// No description provided for @support_screen_contacts_info.
  ///
  /// In en, this message translates to:
  /// **'ndn21dev@gmail.com'**
  String get support_screen_contacts_info;

  /// No description provided for @support_screen_faq_text.
  ///
  /// In en, this message translates to:
  /// **'FAq'**
  String get support_screen_faq_text;

  /// No description provided for @support_screen_faq_decription.
  ///
  /// In en, this message translates to:
  /// **'Find answers to the most frequently asked questions.'**
  String get support_screen_faq_decription;

  /// No description provided for @support_screen_faq_q1.
  ///
  /// In en, this message translates to:
  /// **'How to scan a QR code?'**
  String get support_screen_faq_q1;

  /// No description provided for @support_screen_faq_a1.
  ///
  /// In en, this message translates to:
  /// **'Tap \'Scan\' in the bottom bar and point the camera at the code, or pick an image from the gallery: the code is read and saved to History automatically.'**
  String get support_screen_faq_a1;

  /// No description provided for @support_screen_faq_q2.
  ///
  /// In en, this message translates to:
  /// **'How to create a QR code?'**
  String get support_screen_faq_q2;

  /// No description provided for @support_screen_faq_a2.
  ///
  /// In en, this message translates to:
  /// **'Tap \'Create\' in the bottom bar, choose the code type, fill in the required data and customize its style if you like, then generate the code.'**
  String get support_screen_faq_a2;

  /// No description provided for @support_screen_faq_q3.
  ///
  /// In en, this message translates to:
  /// **'How to delete a QR code?'**
  String get support_screen_faq_q3;

  /// No description provided for @support_screen_faq_a3.
  ///
  /// In en, this message translates to:
  /// **'In History, long-press a code (or tap the trash icon at the top) to start selecting, choose the codes and tap the trash icon in the selection bar. You can also delete a single code from its detail screen.'**
  String get support_screen_faq_a3;

  /// No description provided for @support_screen_faq_q4.
  ///
  /// In en, this message translates to:
  /// **'Can I save codes in a favorites list?'**
  String get support_screen_faq_q4;

  /// No description provided for @support_screen_faq_a4.
  ///
  /// In en, this message translates to:
  /// **'Yes, you can add codes to your favorites by clicking on the heart-shaped icon on the code detail screen.'**
  String get support_screen_faq_a4;

  /// No description provided for @support_screen_faq_q5.
  ///
  /// In en, this message translates to:
  /// **'Can I download a file containing all saved codes?'**
  String get support_screen_faq_q5;

  /// No description provided for @support_screen_faq_a5.
  ///
  /// In en, this message translates to:
  /// **'Yes, from Settings > Database you can export all your codes as PDF, Excel, CSV or JSON. A JSON backup can be imported again later.'**
  String get support_screen_faq_a5;

  /// No description provided for @support_screen_faq_q7.
  ///
  /// In en, this message translates to:
  /// **'What can I do if the app doesn\'t work properly?'**
  String get support_screen_faq_q7;

  /// No description provided for @support_screen_faq_a7.
  ///
  /// In en, this message translates to:
  /// **'If you encounter problems, try restarting the app. If the problem persists, contact technical support through the \'Contact Us\' section.'**
  String get support_screen_faq_a7;

  /// No description provided for @support_screen_documentation_text.
  ///
  /// In en, this message translates to:
  /// **'Documentation'**
  String get support_screen_documentation_text;

  /// No description provided for @support_screen_documentation_decription.
  ///
  /// In en, this message translates to:
  /// **'See the full documentation for more details.'**
  String get support_screen_documentation_decription;

  /// No description provided for @support_screen_documentation_info.
  ///
  /// In en, this message translates to:
  /// **'Go to the documentation on GitHub'**
  String get support_screen_documentation_info;

  /// No description provided for @delete_title.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get delete_title;

  /// No description provided for @delete_description.
  ///
  /// In en, this message translates to:
  /// **'On this page you can permanently delete your Account.\n\nConfirming the cancellation will also delete all the Database linked to the Account.\n\nRemember that the process is irreversible.\n\nIf you want to proceed click on the Button below:'**
  String get delete_description;

  /// No description provided for @delete_d_title.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete_d_title;

  /// No description provided for @delete_d_description.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account?'**
  String get delete_d_description;

  /// No description provided for @custom_picker_field_date_text.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get custom_picker_field_date_text;

  /// No description provided for @custom_picker_field_time_text.
  ///
  /// In en, this message translates to:
  /// **'Select Time'**
  String get custom_picker_field_time_text;

  /// No description provided for @custom_delete_dialog_confirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get custom_delete_dialog_confirm;

  /// No description provided for @custom_delete_dialog_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get custom_delete_dialog_cancel;

  /// No description provided for @full_screen_map_title.
  ///
  /// In en, this message translates to:
  /// **'Select the position'**
  String get full_screen_map_title;

  /// No description provided for @discard_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'Discard changes?'**
  String get discard_dialog_title;

  /// No description provided for @discard_dialog_message.
  ///
  /// In en, this message translates to:
  /// **'All entered information will be lost.'**
  String get discard_dialog_message;

  /// No description provided for @discard_dialog_confirm.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard_dialog_confirm;

  /// No description provided for @discard_dialog_cancel.
  ///
  /// In en, this message translates to:
  /// **'Keep editing'**
  String get discard_dialog_cancel;

  /// No description provided for @code_type_text_text.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get code_type_text_text;

  /// No description provided for @code_type_text_url.
  ///
  /// In en, this message translates to:
  /// **'URL'**
  String get code_type_text_url;

  /// No description provided for @code_type_text_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get code_type_text_email;

  /// No description provided for @code_type_text_phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get code_type_text_phone;

  /// No description provided for @code_type_text_sms.
  ///
  /// In en, this message translates to:
  /// **'SMS'**
  String get code_type_text_sms;

  /// No description provided for @code_type_text_contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get code_type_text_contact;

  /// No description provided for @code_type_text_location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get code_type_text_location;

  /// No description provided for @code_type_text_wifi.
  ///
  /// In en, this message translates to:
  /// **'WiFi'**
  String get code_type_text_wifi;

  /// No description provided for @code_type_text_event.
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get code_type_text_event;

  /// No description provided for @code_type_text_product.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get code_type_text_product;

  /// No description provided for @code_type_text_isbn.
  ///
  /// In en, this message translates to:
  /// **'ISBN'**
  String get code_type_text_isbn;

  /// No description provided for @code_type_text_license.
  ///
  /// In en, this message translates to:
  /// **'License'**
  String get code_type_text_license;

  /// No description provided for @code_type_text_unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get code_type_text_unknown;

  /// No description provided for @app_error_state_retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get app_error_state_retry;

  /// No description provided for @database_screen_load_error.
  ///
  /// In en, this message translates to:
  /// **'Unable to load your data. Please try again.'**
  String get database_screen_load_error;

  /// No description provided for @code_scanner_screen_permission_error.
  ///
  /// In en, this message translates to:
  /// **'Camera access is required to scan codes.'**
  String get code_scanner_screen_permission_error;

  /// No description provided for @changelog_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'Changelog'**
  String get changelog_dialog_title;

  /// No description provided for @changelog_dialog_close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get changelog_dialog_close;

  /// No description provided for @changelog_v2_0_0_bullet_1.
  ///
  /// In en, this message translates to:
  /// **'Scanner: it is the first screen at launch and has a new look (torch with state, animated scan line, dimmed outer area, touch feedback). A loading indicator appears after a scan and the same code can be scanned again without restarting the app. Fixed the scanner getting stuck after the first scan, when offline or when sound and vibration failed to play.'**
  String get changelog_v2_0_0_bullet_1;

  /// No description provided for @changelog_v2_0_0_bullet_2.
  ///
  /// In en, this message translates to:
  /// **'Creating codes: Home opens code creation directly, the preview updates live for every type (socials included) and you can put a logo in the middle of the QR. QR codes with a logo saved as images are recognized, and the map for picking a location no longer asks for the location permission.'**
  String get changelog_v2_0_0_bullet_2;

  /// No description provided for @changelog_v2_0_0_bullet_3.
  ///
  /// In en, this message translates to:
  /// **'History and Favorites: cards share the same style, filters are in a single panel showing how many are active, and search is smoother. Long-press a code to select several and delete them with a single Trash button. Pull down to refresh, with a notice when you are offline. Empty screens suggest what to do, and no black screen is left after a deletion.'**
  String get changelog_v2_0_0_bullet_3;

  /// No description provided for @changelog_v2_0_0_bullet_4.
  ///
  /// In en, this message translates to:
  /// **'Code details: new layout with labeled quick actions, an animated opening from the list and notes in a bottom panel (which previously could fail to open).'**
  String get changelog_v2_0_0_bullet_4;

  /// No description provided for @changelog_v2_0_0_bullet_5.
  ///
  /// In en, this message translates to:
  /// **'Database and export: new page with actions in the top bar and clearer statistics. PDF, Excel, CSV and JSON backups are also saved to the Download folder, and the date of the last backup is shown. Fixed the permission error when exporting and an overflow in the statistics.'**
  String get changelog_v2_0_0_bullet_5;

  /// No description provided for @changelog_v2_0_0_bullet_6.
  ///
  /// In en, this message translates to:
  /// **'Account: Google sign-in uses the new Android account picker and is also available from the sign-up screen. With Google the session always stays active and is restored at launch, even offline. Account details and account deletion are now in Profile, reachable from Settings.'**
  String get changelog_v2_0_0_bullet_6;

  /// No description provided for @changelog_v2_0_0_bullet_7.
  ///
  /// In en, this message translates to:
  /// **'Settings: pick the main color among 8 palettes and a light, dark or system theme, with new segmented buttons. The chosen language applies from launch, scan sound and vibration take effect immediately and the Changelog shows what\'s new after every update.'**
  String get changelog_v2_0_0_bullet_7;

  /// No description provided for @changelog_v2_0_0_bullet_8.
  ///
  /// In en, this message translates to:
  /// **'Look and feel: new app logo and icon (with Android 13+ themed icons), consistently redesigned screens, a new Info screen, lighter bold text and a single scale for text sizes and corners.'**
  String get changelog_v2_0_0_bullet_8;

  /// No description provided for @changelog_v2_0_0_bullet_9.
  ///
  /// In en, this message translates to:
  /// **'Accessibility: higher-contrast secondary text in the light theme, touch targets of at least 48 dp, screens that adapt to a larger system text size and labels for screen readers. The onboarding \"Skip\" button is now translated.'**
  String get changelog_v2_0_0_bullet_9;

  /// No description provided for @changelog_v2_0_0_bullet_10.
  ///
  /// In en, this message translates to:
  /// **'Privacy and performance: privacy policy readable in the app even offline, faster startup, updated scanning and QR generation engines and the latest Firebase libraries.'**
  String get changelog_v2_0_0_bullet_10;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
