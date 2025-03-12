import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qration/models/code_model.dart';
import 'package:qration/models/code_types.dart';

class CodeTypeBody {
  final String formattedContent;
  final BarcodeType type;

  CodeTypeBody(this.formattedContent, this.type);
}

CodeTypeBody getContentBody(CodeModel code) {
  final String content = code.barcode.rawValue ?? 'N/A';

  switch (code.barcode.type) {
    case BarcodeType.text:
    case BarcodeType.url:
      if (content.startsWith('whatsapp://send?phone=')) {
        String phoneNumber = content.replaceFirst('whatsapp://send?phone=', '');
        return CodeTypeBody(phoneNumber, BarcodeType.text);
      }

      if (content.startsWith('spotify:search:')) {
        final formattedContent = content
            .replaceFirst('spotify:search:', '')
            .replaceAll(';', ' - ')
            .split(' ')
            .map((word) =>
                word[0].toUpperCase() + word.substring(1).toLowerCase())
            .join(' ');
        return CodeTypeBody(formattedContent, BarcodeType.text);
      }
      return CodeTypeBody(content, code.barcode.type);
    case BarcodeType.email:
      final email = CodeEmail.fromRawValue(content);
      return CodeTypeBody(email.toString(), BarcodeType.email);
    case BarcodeType.phone:
      final phone = CodePhoneNumber.fromRawValue(content);
      return CodeTypeBody(phone.toString(), BarcodeType.phone);
    case BarcodeType.sms:
      final sms = CodeSms.fromRawValue(content);
      return CodeTypeBody(sms.toString(), BarcodeType.sms);
    case BarcodeType.contactInfo:
      final contact = CodeContact.fromRawValue(content);
      return CodeTypeBody(contact.toString(), BarcodeType.contactInfo);
    case BarcodeType.geo:
      final geo = CodeGeo.fromRawValue(content);
      return CodeTypeBody(geo.toString(), BarcodeType.geo);
    case BarcodeType.wifi:
      final wifi = CodeWifi.fromRawValue(content);
      return CodeTypeBody(wifi.toString(), BarcodeType.wifi);
    case BarcodeType.calendarEvent:
      final event = CodeEvent.fromRawValue(content);
      return CodeTypeBody(event.toString(), BarcodeType.calendarEvent);
    case BarcodeType.product:
      final product = CodeProduct.fromRawValue(content);
      return CodeTypeBody(product.toString(), BarcodeType.product);
    case BarcodeType.isbn:
      final isbn = CodeISBN.fromRawValue(content);
      return CodeTypeBody(isbn.toString(), BarcodeType.isbn);
    default:
      return CodeTypeBody(content, BarcodeType.unknown);
  }
}
