// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get onboarding_first_title => 'Crea';

  @override
  String get onboarding_first_description =>
      'Genera rapidamente un codice QR personalizzato per qualsiasi link o informazione. Basta inserire i dati desiderati e creare il tuo codice QR in pochi secondi.';

  @override
  String get onboarding_second_title => 'Scansiona';

  @override
  String get onboarding_second_description =>
      'Scansiona facilmente qualsiasi codice QR con la fotocamera del tuo dispositivo. Accedi a link, informazioni e contenuti in modo rapido e sicuro senza doverli digitare.';

  @override
  String get onboarding_third_title => 'Salva';

  @override
  String get onboarding_third_description =>
      'Salva i tuoi codici QR preferiti per un accesso futuro. Crea un account per organizzare e conservare i tuoi codici in modo sicuro e utilizzarli ogni volta che ne hai bisogno.';

  @override
  String get onboarding_skip => 'Salta';

  @override
  String get onboarding_next => 'Avanti';

  @override
  String get password_show => 'Mostra password';

  @override
  String get password_hide => 'Nascondi password';

  @override
  String onboarding_page_indicator(int current, int total) {
    return 'Pagina $current di $total';
  }

  @override
  String get onboarding_get_started => 'Inizia';

  @override
  String get welcome_subtitle => 'Il tuo compagno per i QR code';

  @override
  String get welcome_tagline => 'Crea. Scansiona. Salva.';

  @override
  String get welcome_login => 'Accedi';

  @override
  String get welcome_signup => 'Registrati';

  @override
  String get login_title => 'Bentornato';

  @override
  String get login_subtitle => 'Accedi per continuare';

  @override
  String get login_email => 'Email';

  @override
  String get login_password => 'Password';

  @override
  String get login_remember_me => 'Ricordami';

  @override
  String get login_forgot_password => 'Password dimenticata?';

  @override
  String get login_button => 'Accedi';

  @override
  String get login_or => 'oppure continua con';

  @override
  String get login_google => 'Continua con Google';

  @override
  String get login_no_account => 'Non hai un account?';

  @override
  String get login_signup => 'Registrati';

  @override
  String get signup_title => 'Crea account';

  @override
  String get signup_subtitle => 'Unisciti a QRation oggi';

  @override
  String get signup_name => 'Nome completo';

  @override
  String get signup_email => 'Email';

  @override
  String get signup_password => 'Password';

  @override
  String get signup_confirm_password => 'Conferma password';

  @override
  String get signup_button => 'Crea Account';

  @override
  String get signup_have_account => 'Hai già un account?';

  @override
  String get signup_login => 'Accedi';

  @override
  String get reset_password_title => 'Reset password';

  @override
  String get reset_password_subtitle =>
      'Inserisci la tua email per ricevere il link di reset';

  @override
  String get reset_password_email => 'Email';

  @override
  String get reset_password_button => 'Invia link di reset';

  @override
  String get validator_email => 'Email';

  @override
  String get validator_password => 'Password';

  @override
  String get validator_name => 'Nome';

  @override
  String get validator_confirm_password => 'Le password non coincidono';

  @override
  String get toast_delete_success => 'Account eliminato con successo';

  @override
  String get validator_name_empty => 'Il nome non può essere vuoto';

  @override
  String get validator_email_missing_special => 'Simbolo @ mancante';

  @override
  String get validator_email_missing_dot => 'Simbolo . mancante';

  @override
  String get validator_email_required => 'Email è richiesta';

  @override
  String get validator_email_error => 'Email non valida: ';

  @override
  String get validator_password_missing_upper => 'Lettera maiuscola mancante';

  @override
  String get validator_password_missing_lower => 'Lettera minuscola mancante';

  @override
  String get validator_password_missing_digit => 'Numero mancante';

  @override
  String get validator_password_missing_special =>
      'Carattere speciale mancante';

  @override
  String get validator_password_missing_lenght =>
      'La password deve avere una lunghezza di almeno 8 caratteri';

  @override
  String get permission_camera_denied => 'Permesso fotocamera negato';

  @override
  String get permission_camera_toast =>
      'Concedi il permesso della fotocamera dalle impostazioni';

  @override
  String get permission_contacts_denied => 'Permesso contatti negato';

  @override
  String get permission_contacts_toast =>
      'Concedi il permesso dei contatti dalle impostazioni';

  @override
  String get bottom_nav_item_scan => 'Scansiona';

  @override
  String get bottom_nav_item_create => 'Crea';

  @override
  String get bottom_nav_item_favorites => 'Preferiti';

  @override
  String get bottom_nav_item_history => 'Cronologia';

  @override
  String get bottom_nav_item_settings => 'Impostazioni';

  @override
  String get tab_created => 'Creato';

  @override
  String get tab_scanned => 'Scansionato';

  @override
  String get code_create_types_screen_title => 'Seleziona Tipo QR';

  @override
  String get code_create_types_screen_standard => 'Standard';

  @override
  String get code_create_types_screen_social => 'Social';

  @override
  String get code_create_standard_screen_text_label => 'Testo';

  @override
  String get code_create_standard_screen_url_label => 'URL';

  @override
  String get code_create_standard_screen_email_address_label => 'Email';

  @override
  String get code_create_standard_screen_email_subject_label => 'Soggetto';

  @override
  String get code_create_standard_screen_email_body_label => 'Contenuto';

  @override
  String get code_create_standard_screen_phone_label => 'Telefono';

  @override
  String get code_create_standard_screen_sms_phone_label => 'Telefono';

  @override
  String get code_create_standard_screen_sms_message_label => 'Messaggio';

  @override
  String get code_create_standard_screen_contact_name_label => 'Nome';

  @override
  String get code_create_standard_screen_contact_surname_label => 'Cognome';

  @override
  String get code_create_standard_screen_contact_phone_label => 'Telefono';

  @override
  String get code_create_standard_screen_contact_email_label => 'Email';

  @override
  String get code_create_standard_screen_geo_latitude_label => 'Latitudine';

  @override
  String get code_create_standard_screen_geo_longitude_label => 'Longitudine';

  @override
  String get code_create_standard_screen_geo_select_button =>
      'Seleziona Posizione';

  @override
  String get code_create_standard_screen_wifi_ssid_label => 'SSID';

  @override
  String get code_create_standard_screen_wifi_password_label => 'Password';

  @override
  String get code_create_standard_screen_wifi_type_label => 'Tipo';

  @override
  String get code_create_standard_screen_wifi_hidden_label => 'Nascondi';

  @override
  String get code_create_standard_screen_calendar_title_label => 'Titolo';

  @override
  String get code_create_standard_screen_calendar_start_date_label =>
      'Data Inizio';

  @override
  String get code_create_standard_screen_calendar_end_date_label => 'Data Fine';

  @override
  String get code_create_standard_screen_calendar_location_label => 'Posizione';

  @override
  String get code_create_standard_screen_product_label => 'Prodotto';

  @override
  String get code_create_standard_screen_isbn_label => 'ISBN';

  @override
  String get code_create_standard_screen_error_url_length =>
      'Il contenuto deve essere di almeno 7 caratteri.';

  @override
  String get code_create_standard_screen_validator_field_a => 'Il campo';

  @override
  String get code_create_standard_screen_validator_field_b =>
      'non può essere vuoto';

  @override
  String get code_create_standard_screen_validator_url =>
      'Il campo URL è vuoto';

  @override
  String get code_create_standard_screen_validator_number =>
      'Per favore inserisci un numero valido';

  @override
  String get code_create_standard_screen_eye_title => 'Occhi';

  @override
  String get code_create_standard_screen_eye_color => 'Colore';

  @override
  String get code_create_standard_screen_eye_rounded => 'Arrotondati';

  @override
  String get code_create_standard_screen_module_title => 'Moduli';

  @override
  String get code_create_standard_screen_module_color => 'Colore';

  @override
  String get code_create_standard_screen_module_rounded => 'Arrotondati';

  @override
  String get code_create_standard_screen_logo_title => 'Logo';

  @override
  String get qr_style_pick_logo => 'Scegli un logo';

  @override
  String get code_create_standard_screen_dialog_color_text =>
      'Scegli un colore';

  @override
  String get code_create_standard_screen_dialog_color_select => 'Seleziona';

  @override
  String get code_create_standard_screen_create_button => 'Crea';

  @override
  String get code_create_preview_title => 'Anteprima';

  @override
  String get qr_preview_semantics => 'Anteprima del codice QR';

  @override
  String get code_create_style_title => 'Stile';

  @override
  String get code_create_standard_screen_toast_success =>
      'Codice QR aggiunto con successo!';

  @override
  String get code_create_standard_screen_toast_error =>
      'Errore nel salvataggio del codice QR:';

  @override
  String get code_create_social_screen_url_label => 'Inserisci URL';

  @override
  String get code_create_social_screen_url_validator =>
      'Per favore inserisci un URL';

  @override
  String get code_create_social_screen_url_details_validator =>
      'Per favore inserisci più dettagli per completare l\'URL';

  @override
  String get code_create_social_screen_whatsapp_label =>
      'Inserisci numero WhatsApp';

  @override
  String get code_create_social_screen_whatsapp_validator =>
      'Per favore inserisci un numero valido';

  @override
  String get code_create_social_screen_spotify_artist_label =>
      'Inserisci nome artista';

  @override
  String get code_create_social_screen_spotify_artist_validator =>
      'Per favore inserisci il nome dell\'artista';

  @override
  String get code_create_social_screen_spotify_song_label =>
      'Inserisci nome canzone';

  @override
  String get code_create_social_screen_spotify_song_validator =>
      'Per favore inserisci il nome della canzone';

  @override
  String get code_create_social_screen_error_url =>
      'Questo campo è obbligatorio';

  @override
  String get code_create_social_screen_error_url_www =>
      'Il contenuto deve iniziare con \'www\' o \'http\'.';

  @override
  String get code_create_social_screen_error_url_length =>
      'Il contenuto deve essere di almeno 7 caratteri.';

  @override
  String get code_create_social_screen_validator_url =>
      'Per favore inserisci un URL valido';

  @override
  String get code_create_social_screen_create_button => 'Crea';

  @override
  String get code_create_social_screen_toast_success =>
      'Codice QR aggiunto con successo!';

  @override
  String get code_create_social_screen_toast_error =>
      'Errore nel salvare il codice QR:';

  @override
  String get code_scanner_screen_title => 'Scanner QR';

  @override
  String get code_scanner_screen_camera_hint => 'Inquadra il codice QR';

  @override
  String get code_scanner_screen_tooltip_gallery => 'Scansiona da un\'immagine';

  @override
  String get code_scanner_screen_tooltip_torch_on => 'Accendi la torcia';

  @override
  String get code_scanner_screen_tooltip_torch_off => 'Spegni la torcia';

  @override
  String get code_scanner_screen_tooltip_switch_camera => 'Cambia fotocamera';

  @override
  String get code_scanner_screen_scan_qr_empty_toast_error =>
      'Nessun codice QR trovato nell\'immagine';

  @override
  String get code_scanner_screen_scan_qr_read_toast_error =>
      'Impossibile leggere il codice QR:';

  @override
  String get code_details_screen_title => 'Dettagli Codice QR';

  @override
  String get code_details_screen_date_title => 'Data';

  @override
  String get code_details_screen_type_title => 'Tipo';

  @override
  String get code_details_screen_title_title => 'Codice QR';

  @override
  String get code_details_screen_content_title => 'Contenuto';

  @override
  String get code_details_screen_action_text => 'Copia';

  @override
  String get code_details_screen_action_url => 'Apri';

  @override
  String get code_details_screen_action_email => 'Invia';

  @override
  String get code_details_screen_action_phone => 'Chiama';

  @override
  String get code_details_screen_action_sms => 'Messaggio';

  @override
  String get code_details_screen_action_contact => 'Aggiungi';

  @override
  String get code_details_screen_action_geo => 'Naviga';

  @override
  String get code_details_screen_action_wifi => 'Connetti';

  @override
  String get code_details_screen_action_calendar => 'Aggiungi';

  @override
  String get code_details_screen_product => 'Codice Prodotto';

  @override
  String get code_details_screen_action_product => 'Cerca';

  @override
  String get code_details_screen_isbn => 'Codice ISBN';

  @override
  String get code_details_screen_action_isbn => 'Cerca';

  @override
  String get code_details_screen_action_button_copy => 'Copia';

  @override
  String get code_details_screen_action_button_favorite => 'Preferito';

  @override
  String get code_details_screen_action_button_save => 'Salva';

  @override
  String get code_details_screen_action_button_share => 'Condividi';

  @override
  String get code_details_screen_result_copy =>
      'Contenuto copiato negli appunti!';

  @override
  String get code_details_screen_result_contact => 'Contatto aggiunto!';

  @override
  String get code_details_screen_result_wifi => 'WiFi salvato e connesso!';

  @override
  String get code_details_screen_result_product_amazon => 'Cerca su Amazon';

  @override
  String get code_details_screen_result_product_ebay => 'Cerca su Ebay';

  @override
  String get code_details_screen_result_product_google => 'Cerca su Google';

  @override
  String get code_details_screen_result_isbn_google_books =>
      'Cerca su Google Books';

  @override
  String get code_details_screen_result_isbn_amazon => 'Cerca su Amazon';

  @override
  String get code_details_screen_result_isbn_goodreads => 'Cerca su Goodreads';

  @override
  String get code_details_screen_toast_success =>
      'Codice QR salvato nella galleria';

  @override
  String get code_details_screen_toast_error =>
      'Errore nel salvare il codice QR';

  @override
  String get code_details_screen_toast_error_link =>
      'Impossibile aprire il link';

  @override
  String get code_details_screen_menu_notes => 'Note';

  @override
  String get code_details_screen_menu_delete => 'Elimina';

  @override
  String get code_details_screen_notes_title => 'Aggiungi note';

  @override
  String get code_details_screen_notes_hint => 'Inserisci qui le tue note';

  @override
  String get code_details_screen_notes_cancel => 'Cancella';

  @override
  String get code_details_screen_notes_save => 'Salva';

  @override
  String get code_details_screen_delete_title => 'Elimina';

  @override
  String get code_details_screen_delete_description =>
      'Sei sicuro di voler eliminare questo codice?';

  @override
  String get code_details_screen_delete_toast_success => 'Codice eliminato!';

  @override
  String get favorites_screen_tab_created => 'Creati';

  @override
  String get favorites_screen_tab_scanned => 'Scansionati';

  @override
  String get favorites_screen_error_state => 'Errore:';

  @override
  String get favorites_screen_empty_state => 'Nessun codice preferito';

  @override
  String get favorites_screen_empty_action => 'Crea il tuo primo codice';

  @override
  String get history_screen_search_label => 'Cerca';

  @override
  String get history_screen_filter_all => 'Tutti';

  @override
  String get history_screen_filter_created => 'Creati';

  @override
  String get history_screen_filter_scanned => 'Scansionati';

  @override
  String get history_filter_sheet_title => 'Filtri';

  @override
  String get history_filter_sheet_source => 'Origine';

  @override
  String get history_filter_sheet_types => 'Tipo di codice';

  @override
  String get history_filter_sheet_social => 'Social';

  @override
  String get history_filter_sheet_show_results => 'Mostra risultati';

  @override
  String get history_screen_error_state => 'Errore:';

  @override
  String get history_screen_delete_title => 'Elimina';

  @override
  String get sync_status_offline =>
      'Sei offline: vedi i codici salvati sul dispositivo';

  @override
  String get sync_status_pending => 'Modifiche in attesa di sincronizzazione';

  @override
  String get sync_refresh_offline =>
      'Impossibile aggiornare: nessuna connessione';

  @override
  String get history_screen_empty_state => 'Nessun codice salvato';

  @override
  String get history_screen_empty_action => 'Scansiona ora';

  @override
  String get history_screen_empty_filtered =>
      'Nessun risultato per i filtri attivi';

  @override
  String get history_screen_clear_filters => 'Azzera i filtri';

  @override
  String get history_screen_selected_count => 'selezionati';

  @override
  String get history_screen_select_all => 'Seleziona tutto';

  @override
  String get history_screen_deselect_all => 'Deseleziona tutto';

  @override
  String get history_screen_delete_selected_description =>
      'Sei sicuro di voler eliminare i codici selezionati?';

  @override
  String history_screen_deleted_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count codici eliminati',
      one: '1 codice eliminato',
    );
    return '$_temp0';
  }

  @override
  String get history_screen_tooltip_close_selection => 'Esci dalla selezione';

  @override
  String get history_screen_tooltip_clear_search => 'Cancella ricerca';

  @override
  String get history_screen_tooltip_filter => 'Filtra';

  @override
  String get history_screen_tooltip_select_mode => 'Seleziona codici';

  @override
  String get history_screen_tooltip_delete => 'Elimina';

  @override
  String get history_screen_tooltip_details => 'Vedi dettagli';

  @override
  String get settings_title_general => 'Generale';

  @override
  String get settings_title_theme => 'Tema';

  @override
  String get settings_subtitle_theme_option_light => 'Chiaro';

  @override
  String get settings_subtitle_theme_option_dark => 'Scuro';

  @override
  String get settings_subtitle_theme_option_system => 'Sistema';

  @override
  String get settings_title_language => 'Lingua';

  @override
  String get settings_subtitle_language_option_english => 'Inglese';

  @override
  String get settings_subtitle_language_option_italian => 'Italiano';

  @override
  String get settings_title_accent_color => 'Colore principale';

  @override
  String get settings_accent_color_blue => 'Blu';

  @override
  String get settings_accent_color_green => 'Verde';

  @override
  String get settings_accent_color_purple => 'Viola';

  @override
  String get settings_accent_color_red => 'Rosso';

  @override
  String get settings_accent_color_teal => 'Verde acqua';

  @override
  String get settings_accent_color_orange => 'Arancione';

  @override
  String get settings_accent_color_pink => 'Rosa';

  @override
  String get settings_accent_color_grey => 'Grigio';

  @override
  String get settings_title_scan => 'Scansione';

  @override
  String get settings_title_beep => 'Bip';

  @override
  String get settings_subtile_beep =>
      'Abilita un suono quando scansioni un codice';

  @override
  String get settings_title_vibrate => 'Vibra';

  @override
  String get settings_subtile_vibrate =>
      'Abilita una vibrazione quando scansioni un codice';

  @override
  String get settings_title_account => 'Account';

  @override
  String get settings_tile_profile => 'Profilo';

  @override
  String get settings_tile_database => 'Database';

  @override
  String get settings_tile_log_out => 'Esci';

  @override
  String get settings_tile_delete_account => 'Elimina Account';

  @override
  String get settings_title_app => 'App';

  @override
  String get settings_tile_info => 'Info';

  @override
  String get settings_tile_changelog => 'Changelog';

  @override
  String get settings_tile_support => 'Supporto';

  @override
  String get settings_tile_share => 'Condividi';

  @override
  String get database_screen_title => 'Database';

  @override
  String get database_screen_account_title => 'Info Account';

  @override
  String get database_screen_account_field_userid => 'ID';

  @override
  String get database_screen_account_field_name => 'Nome';

  @override
  String get database_screen_account_field_email => 'Email';

  @override
  String get database_screen_account_field_date => 'Account Creato';

  @override
  String get database_screen_codes_field_total_title => 'Statistiche codici';

  @override
  String get database_screen_codes_field_total_saved => 'Codici salvati';

  @override
  String get database_screen_codes_field_created_title => 'Codici creati';

  @override
  String get database_screen_codes_field_scanned_title => 'Codici scansionati';

  @override
  String get database_screen_codes_field_standard_title => 'Codici standard';

  @override
  String get database_screen_codes_field_social_title => 'Codici social';

  @override
  String get database_screen_codes_field_empty => 'Non sono presenti codici';

  @override
  String get database_screen_codes_dialog_standard => 'Standard';

  @override
  String get database_screen_codes_dialog_social => 'Social';

  @override
  String get database_screen_codes_dialog_close => 'Chiudi';

  @override
  String get database_screen_transfer_title => 'Esporta e importa';

  @override
  String get database_screen_documents_title => 'Documenti';

  @override
  String get database_screen_documents_description =>
      'Crea un file con l\'elenco dei tuoi codici, da leggere, stampare o condividere.';

  @override
  String get database_screen_backup_description =>
      'Salva tutti i tuoi codici in un file JSON nella cartella Download, per ripristinarli in seguito anche su un altro telefono. Ripristinando un backup, i suoi codici si aggiungono a quelli già presenti.';

  @override
  String get database_screen_backup_create => 'Crea backup';

  @override
  String get database_screen_backup_restore => 'Ripristina';

  @override
  String get database_screen_pdf_download => 'PDF';

  @override
  String get database_screen_pdf_confirm =>
      'PDF salvato nella cartella Download';

  @override
  String get database_screen_pdf_error => 'Impossibile generare il PDF';

  @override
  String get database_screen_excel_download => 'Excel';

  @override
  String get database_screen_excel_confirm =>
      'Excel salvato nella cartella Download';

  @override
  String get database_screen_excel_error => 'Impossibile generare il Excel';

  @override
  String get database_screen_csv_download => 'CSV';

  @override
  String get database_screen_csv_confirm =>
      'CSV salvato nella cartella Download';

  @override
  String get database_screen_csv_error => 'Impossibile generare il CSV';

  @override
  String get database_screen_backup_title => 'Backup';

  @override
  String get database_screen_backup_last_export => 'Ultimo backup';

  @override
  String get database_screen_backup_last_import => 'Ultimo ripristino';

  @override
  String get database_screen_backup_never => 'Mai';

  @override
  String get database_screen_export_success =>
      'Backup salvato nella cartella Download';

  @override
  String get database_screen_export_error => 'Errore durante il backup';

  @override
  String get database_screen_import_success => 'Backup ripristinato';

  @override
  String get database_screen_import_error => 'Errore durante il ripristino';

  @override
  String get database_service_codes_field_id => 'ID';

  @override
  String get database_service_codes_field_date => 'Data';

  @override
  String get database_service_codes_field_source => 'Fonte';

  @override
  String get database_service_codes_field_type => 'Tipo';

  @override
  String get database_service_codes_field_content => 'Contenuto';

  @override
  String get database_service_codes_field_eye_color => 'Colore Occhi';

  @override
  String get database_service_codes_field_eye_rounded => 'Occhi Arrotondati';

  @override
  String get database_service_codes_field_module_color => 'Colore Moduli';

  @override
  String get database_service_codes_field_module_rounded =>
      'Moduli Arrotondati';

  @override
  String get database_service_codes_field_favorite => 'Preferito';

  @override
  String get database_service_codes_field_social => 'Social';

  @override
  String get database_pdf_field_user_title => 'Informazioni Utente';

  @override
  String get database_pdf_field_user_id => 'ID Utente';

  @override
  String get database_pdf_field_user_name => 'Nome';

  @override
  String get database_pdf_field_user_email => 'Email';

  @override
  String get database_pdf_field_user_date => 'Account Creato';

  @override
  String get database_pdf_field_code_title => 'Statistiche Codici';

  @override
  String get database_pdf_field_code_saved => 'Codici Salvati';

  @override
  String get database_pdf_field_code_created => 'Codici Creati';

  @override
  String get database_pdf_field_code_created_standard => 'Standard';

  @override
  String get database_pdf_field_code_created_social => 'Social';

  @override
  String get database_pdf_field_code_scanned => 'Codici Scansionati';

  @override
  String get pdf_report_subtitle => 'La mia collezione di codici';

  @override
  String get pdf_report_rights => 'Tutti i diritti riservati.';

  @override
  String pdf_report_codes_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count codici',
      one: '1 codice',
    );
    return '$_temp0';
  }

  @override
  String pdf_report_page(int current, int total) {
    return 'Pagina $current di $total';
  }

  @override
  String get pdf_report_codes => 'Codici';

  @override
  String get pdf_report_none => 'Nessuno';

  @override
  String get pdf_report_notes => 'Note';

  @override
  String get pdf_report_eyes => 'Occhi';

  @override
  String get pdf_report_modules => 'Moduli';

  @override
  String get pdf_report_rounded => 'arrotondati';

  @override
  String get pdf_report_square => 'squadrati';

  @override
  String get user_screen_title => 'Profilo';

  @override
  String get user_screen_logout_button => 'Esci';

  @override
  String get info_screen_title => 'Info';

  @override
  String get info_screen_tagline => 'Scansiona, crea e conserva i tuoi codici';

  @override
  String get info_screen_version_text => 'Versione';

  @override
  String get info_screen_about_title => 'Cos\'è QRation';

  @override
  String get info_screen_about_text =>
      'QRation ti permette di scansionare e creare codici QR e codici a barre e li conserva nel tuo account personale, sempre a portata di mano. Ogni codice offre l\'azione adatta al suo tipo: aprire un link, aggiungere un contatto o un evento, connettersi a una rete Wi-Fi e molto altro.';

  @override
  String get info_screen_origin_description =>
      'Il nome unisce \'QR\' e \'Creation\', le due cose che l\'app fa: scansionare e creare codici QR.';

  @override
  String get info_screen_features_title => 'Funzionalità';

  @override
  String get info_screen_feature_scan_title => 'Scansiona';

  @override
  String get info_screen_feature_scan_text =>
      'Codici QR e a barre dalla fotocamera o da un\'immagine della galleria.';

  @override
  String get info_screen_feature_create_title => 'Crea';

  @override
  String get info_screen_feature_create_text =>
      'Codici per link, Wi-Fi, contatti, eventi e social, con colori e forme a tua scelta.';

  @override
  String get info_screen_feature_library_title => 'Organizza';

  @override
  String get info_screen_feature_library_text =>
      'Cronologia e preferiti sincronizzati con il tuo account, con ricerca e filtri.';

  @override
  String get info_screen_feature_export_title => 'Esporta';

  @override
  String get info_screen_feature_export_text =>
      'I tuoi codici in PDF, Excel o CSV, più backup e ripristino in JSON.';

  @override
  String get info_screen_links_title => 'Link utili';

  @override
  String get info_screen_link_source => 'Codice sorgente';

  @override
  String get info_screen_link_website => 'Sito web';

  @override
  String get info_screen_link_contact => 'Contattami';

  @override
  String get info_screen_link_licenses => 'Licenze open source';

  @override
  String info_screen_made_by(String name) {
    return 'Ideata e sviluppata da $name';
  }

  @override
  String get policy_screen_title => 'Privacy Policy';

  @override
  String get policy_screen_intro =>
      'Questa informativa spiega quali dati tratta QRation, perché e come puoi gestirli. QRation non mostra pubblicità, non usa strumenti di analisi e non vende né cede i tuoi dati.';

  @override
  String policy_screen_updated(String date) {
    return 'Ultimo aggiornamento: $date';
  }

  @override
  String get policy_screen_online => 'Versione online';

  @override
  String get policy_section_controller_title => 'Titolare del trattamento';

  @override
  String policy_section_controller_text(String name, String email) {
    return 'Il titolare è lo sviluppatore dell\'app, $name. Per qualsiasi richiesta sulla privacy puoi scrivere a $email.';
  }

  @override
  String get policy_section_data_title => 'Dati che raccogliamo';

  @override
  String get policy_section_data_text =>
      '• Account: email, nome e data di registrazione. Con l\'accesso Google riceviamo nome, email e foto del profilo del tuo account Google. La password è gestita da Firebase Authentication e non è mai visibile allo sviluppatore.\n• Codici: per ogni codice scansionato o creato salviamo il contenuto (che può includere dati personali come contatti, posizioni, eventi o password Wi-Fi), il tipo, la data, l\'origine (scansionato o creato), il preferito, le note, lo stile grafico e il social associato. Il logo scelto per un codice resta sul dispositivo: nell\'account viene salvato solo il percorso del file.\n• Segnalazioni di errore: se l\'app si chiude per un errore, Firebase Crashlytics riceve un rapporto tecnico con il dettaglio dell\'errore, il modello del dispositivo, la versione del sistema e dell\'app e un identificativo casuale dell\'installazione.\n• Sul dispositivo: preferenze come lingua, tema e colore principale, suono e vibrazione dello scanner, «ricordami», le schermate e le novità già viste e la data dell\'ultimo backup.';

  @override
  String get policy_section_use_title => 'Come usiamo i dati';

  @override
  String get policy_section_use_text =>
      'I dati servono solo a far funzionare l\'app: accedere al tuo account, salvare e sincronizzare i tuoi codici, mostrarli in Cronologia e Preferiti e generare i file che esporti. Le segnalazioni di errore servono solo a correggere i problemi dell\'app. Non usiamo i dati per profilazione o pubblicità.';

  @override
  String get policy_section_storage_title => 'Dove sono conservati';

  @override
  String get policy_section_storage_text =>
      'Account e codici sono conservati su Google Firebase (Authentication e Cloud Firestore), le segnalazioni di errore su Firebase Crashlytics: servizi di Google LLC che possono trattare i dati anche fuori dall\'Unione Europea con le garanzie previste dalle loro condizioni. I dati sono collegati al tuo account e non sono visibili ad altri utenti. Per consentire l\'uso offline, una copia dei codici resta anche sul dispositivo. La mappa per scegliere una posizione carica le immagini da OpenStreetMap, che riceve l\'indirizzo IP del dispositivo ma nessun dato del tuo account.';

  @override
  String get policy_section_device_title => 'Elaborazione sul dispositivo';

  @override
  String get policy_section_device_text =>
      'La lettura dei codici, dalla fotocamera o da un\'immagine della galleria, avviene interamente sul telefono: le immagini non vengono inviate a servizi esterni. Anche i QR generati e i file PDF, Excel, CSV e JSON che esporti vengono creati sul dispositivo e condivisi solo se lo scegli tu. Le azioni dei codici (aggiungere un contatto o un evento al calendario, connettersi a una rete Wi-Fi, aprire un link o una mappa) partono solo quando le tocchi; link e mappe si aprono in app esterne, che seguono le proprie informative.';

  @override
  String get policy_section_permissions_title => 'Permessi';

  @override
  String get policy_section_permissions_text =>
      '• Fotocamera: per scansionare i codici.\n• Foto e memoria: per scegliere un\'immagine da scansionare o il logo di un codice, e per salvare i QR in galleria e i file esportati nella cartella Download.\n• Contatti: per salvare in rubrica il contatto letto da un codice; la rubrica non viene letta né inviata.\n• Posizione: dichiarata dalla libreria Wi-Fi, che su alcune versioni di Android ne ha bisogno per connettersi alla rete di un codice Wi-Fi. L\'app non legge, non salva e non invia la tua posizione: il punto di un codice posizione lo scegli tu toccando la mappa.\n• Wi-Fi e rete: per connetterti alla rete di un codice Wi-Fi e verificare lo stato della connessione.\n• Internet: per sincronizzare account e codici.';

  @override
  String get policy_section_retention_title => 'Conservazione e cancellazione';

  @override
  String get policy_section_retention_text =>
      'Conserviamo account e codici finché il tuo account esiste; puoi eliminare singoli codici in qualsiasi momento dalla Cronologia. Da Impostazioni > Profilo > Elimina account puoi cancellare l\'account e tutti i codici; prima puoi esportarne una copia da Impostazioni > Database. Le segnalazioni di errore vengono cancellate automaticamente dopo 90 giorni. Le preferenze e i loghi sul dispositivo vengono rimossi disinstallando l\'app.';

  @override
  String get policy_section_rights_title => 'I tuoi diritti';

  @override
  String get policy_section_rights_text =>
      'Puoi accedere ai tuoi dati ed esportarli (PDF, Excel, CSV e JSON), cancellarli eliminando singoli codici o l\'intero account, e chiedere la rettifica o qualsiasi informazione scrivendo al titolare. Puoi anche presentare reclamo all\'autorità per la protezione dei dati del tuo paese.';

  @override
  String get policy_section_children_title => 'Minori';

  @override
  String get policy_section_children_text =>
      'QRation non è rivolta a minori di 14 anni e non raccoglie consapevolmente i loro dati.';

  @override
  String get policy_section_changes_title => 'Modifiche';

  @override
  String get policy_section_changes_text =>
      'Se questa informativa cambia, la nuova versione sarà disponibile nell\'app e online, con la data di aggiornamento.';

  @override
  String get support_screen_title => 'Supporto';

  @override
  String get support_screen_contacts_text => 'Contattaci';

  @override
  String get support_screen_contacts_decription =>
      'Per qualsiasi problema o domanda, scrivi a:';

  @override
  String get support_screen_contacts_info => 'ndn21dev@gmail.com';

  @override
  String get support_screen_faq_text => 'FAQ';

  @override
  String get support_screen_faq_decription =>
      'Trova risposte alle domande più frequenti.';

  @override
  String get support_screen_faq_q1 => 'Come scansionare un codice QR?';

  @override
  String get support_screen_faq_a1 =>
      'Tocca \'Scansiona\' nella barra inferiore e inquadra il codice con la fotocamera, oppure scegli un\'immagine dalla galleria: il codice viene letto e salvato automaticamente nella Cronologia.';

  @override
  String get support_screen_faq_q2 => 'Come creare un codice QR?';

  @override
  String get support_screen_faq_a2 =>
      'Tocca \'Crea\' nella barra inferiore, scegli il tipo di codice, inserisci i dati richiesti e personalizzane lo stile se vuoi, poi genera il codice.';

  @override
  String get support_screen_faq_q3 => 'Come eliminare un codice QR?';

  @override
  String get support_screen_faq_a3 =>
      'In Cronologia tieni premuto un codice (oppure tocca l\'icona del cestino in alto) per iniziare la selezione, scegli i codici e tocca il cestino nella barra di selezione. Puoi eliminare un singolo codice anche dalla sua schermata di dettaglio.';

  @override
  String get support_screen_faq_q4 =>
      'Posso salvare dei codici in una lista preferiti?';

  @override
  String get support_screen_faq_a4 =>
      'Si è possibile aggiungere ai preferiti i codici cliccando sull\'icona a forma di cuore presente nella schermata di dettaglio del codice.';

  @override
  String get support_screen_faq_q5 =>
      'Posso scaricare un file contenente tutti i codici salvati?';

  @override
  String get support_screen_faq_a5 =>
      'Sì, da Impostazioni > Database puoi esportare tutti i codici in PDF, Excel, CSV o JSON. Il backup JSON può essere reimportato in seguito.';

  @override
  String get support_screen_faq_q7 =>
      'Cosa posso fare se l\'app non funziona correttamente?';

  @override
  String get support_screen_faq_a7 =>
      'Se riscontri problemi, prova a riavviare l\'app. Se il problema persiste, contatta il supporto tecnico tramite la sezione \'Contattaci\'.';

  @override
  String get support_screen_documentation_text => 'Documentazione';

  @override
  String get support_screen_documentation_decription =>
      'Consulta la documentazione completa per maggiori dettagli.';

  @override
  String get support_screen_documentation_info =>
      'Vai alla documentazione su GitHub';

  @override
  String get delete_title => 'Elimina Account';

  @override
  String get delete_description =>
      'In questa pagina puoi cancellare definitivamente il tuo account.\n\nLa conferma della cancellazione comporterà anche l\'eliminazione di tutti i database collegati all\'account.\n\nRicorda che il processo è irreversibile.\n\nSe desideri procedere clicca sul pulsante qui sotto:';

  @override
  String get delete_d_title => 'Elimina';

  @override
  String get delete_d_description =>
      'Sei sicuro di voler eliminare il tuo account?';

  @override
  String get custom_picker_field_date_text => 'Seleziona Data';

  @override
  String get custom_picker_field_time_text => 'Seleziona Ora';

  @override
  String get custom_delete_dialog_confirm => 'Elimina';

  @override
  String get custom_delete_dialog_cancel => 'Annulla';

  @override
  String get full_screen_map_title => 'Seleziona la posizione';

  @override
  String get discard_dialog_title => 'Scartare le modifiche?';

  @override
  String get discard_dialog_message =>
      'Tutte le informazioni inserite verranno perse.';

  @override
  String get discard_dialog_confirm => 'Scarta';

  @override
  String get discard_dialog_cancel => 'Continua a modificare';

  @override
  String get code_type_text_text => 'Testo';

  @override
  String get code_type_text_url => 'URL';

  @override
  String get code_type_text_email => 'Email';

  @override
  String get code_type_text_phone => 'Telefono';

  @override
  String get code_type_text_sms => 'SMS';

  @override
  String get code_type_text_contact => 'Contatto';

  @override
  String get code_type_text_location => 'Posizione';

  @override
  String get code_type_text_wifi => 'WiFi';

  @override
  String get code_type_text_event => 'Evento';

  @override
  String get code_type_text_product => 'Prodotto';

  @override
  String get code_type_text_isbn => 'ISBN';

  @override
  String get code_type_text_license => 'Patente';

  @override
  String get code_type_text_unknown => 'Sconosciuto';

  @override
  String get app_error_state_retry => 'Riprova';

  @override
  String get database_screen_load_error =>
      'Impossibile caricare i tuoi dati. Riprova.';

  @override
  String get code_scanner_screen_permission_error =>
      'L\'accesso alla fotocamera è necessario per scansionare i codici.';

  @override
  String get changelog_dialog_title => 'Novità';

  @override
  String get changelog_dialog_close => 'Chiudi';

  @override
  String get changelog_section_added => 'Novità';

  @override
  String get changelog_section_improved => 'Miglioramenti';

  @override
  String get changelog_section_fixed => 'Correzioni';

  @override
  String get changelog_section_security => 'Sicurezza';

  @override
  String get changelog_v2_0_0_bullet_1 =>
      'Scanner: è la prima schermata all\'avvio e ha un nuovo aspetto (torcia con stato, linea animata, area esterna oscurata, riscontro al tocco). Dopo la scansione compare un indicatore di caricamento e lo stesso codice si può riscansionare senza riavviare l\'app. Corretti i blocchi dopo la prima scansione, senza connessione o quando suono e vibrazione non partivano.';

  @override
  String get changelog_v2_0_0_bullet_2 =>
      'Creazione: la Home apre direttamente la creazione dei codici, l\'anteprima si aggiorna in tempo reale per ogni tipo (anche social) e puoi inserire un logo al centro del QR. I QR con logo salvati come immagine vengono riconosciuti, e la mappa per scegliere una posizione non chiede più il permesso di posizione.';

  @override
  String get changelog_v2_0_0_bullet_3 =>
      'Cronologia e Preferiti: card con lo stesso stile, filtri in un unico pannello con il numero di filtri attivi e ricerca più fluida. Tieni premuto un codice per selezionarne più di uno ed eliminarli con un solo Cestino. Trascina verso il basso per aggiornare, con un avviso quando sei offline. Le schermate vuote suggeriscono cosa fare, e non resta più una schermata nera dopo un\'eliminazione.';

  @override
  String get changelog_v2_0_0_bullet_4 =>
      'Dettaglio codice: nuovo layout con azioni rapide con etichetta, apertura animata dalla lista e note in un pannello dal basso (che prima poteva non aprirsi).';

  @override
  String get changelog_v2_0_0_bullet_5 =>
      'Database ed esportazione: nuova pagina con statistiche più leggibili e tutte le esportazioni e il backup riuniti in un\'unica sezione, con i pulsanti spiegati. PDF, Excel, CSV e backup JSON vengono salvati anche nella cartella Download, ed è indicata la data dell\'ultimo backup. Il PDF esportato ha una nuova grafica: copertina, riepilogo di account e statistiche e i codici in schede compatte, circa 5 per pagina invece di uno. Corretti l\'errore di permesso in esportazione e un overflow nelle statistiche.';

  @override
  String get changelog_v2_0_0_bullet_6 =>
      'Account: l\'accesso con Google usa il nuovo selettore account di Android ed è disponibile anche dalla schermata di registrazione. Con Google la sessione resta sempre attiva e viene ripristinata all\'avvio, anche offline. Informazioni ed eliminazione dell\'account sono ora nel Profilo, raggiungibile dalle Impostazioni.';

  @override
  String get changelog_v2_0_0_bullet_7 =>
      'Impostazioni: scegli il colore principale tra 8 palette e il tema chiaro, scuro o di sistema, con nuovi pulsanti segmentati. La lingua scelta vale fin dall\'avvio, suono e vibrazione della scansione si applicano subito, il Changelog mostra le novità dopo ogni aggiornamento e Condividi invia il link al progetto su GitHub.';

  @override
  String get changelog_v2_0_0_bullet_8 =>
      'Aspetto: nuovo logo e nuova icona dell\'app (con le icone a tema di Android 13+), schermate ridisegnate in modo coerente, nuova schermata Info, testi meno marcati e una sola scala per dimensioni dei testi e angoli.';

  @override
  String get changelog_v2_0_0_bullet_9 =>
      'Accessibilità: testi secondari più contrastati nel tema chiaro, aree tattili di almeno 48 dp, schermate che si adattano al testo di sistema ingrandito ed etichette per gli screen reader. Il pulsante \"Salta\" dell\'onboarding ora è tradotto.';

  @override
  String get changelog_v2_0_0_bullet_10 =>
      'Privacy e prestazioni: informativa privacy leggibile nell\'app anche offline, avvio più rapido, motore di scansione e generazione dei QR aggiornati e librerie Firebase all\'ultima versione.';

  @override
  String get changelog_v2_0_0_bullet_11 =>
      'Il profilo e i codici salvati sono accessibili solo dal tuo account.';
}
