import 'package:intl/intl.dart';

// Class to manage url
class CodeUrl {
  final String displayValue;

  CodeUrl({required this.displayValue});

  factory CodeUrl.fromRawValue(String rawValue) {
    if (rawValue.startsWith('whatsapp://send?phone=')) {
      String phoneNumber = rawValue.replaceFirst('whatsapp://send?phone=', '');
      return CodeUrl(displayValue: phoneNumber);
    }

    if (rawValue.startsWith('spotify:search:')) {
      String searchQuery = rawValue
          .replaceFirst('spotify:search:', '')
          .replaceAll(';', ' - ')
          .trim();

      searchQuery = searchQuery
          .split(' ')
          .map(
              (word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
          .join(' ');

      return CodeUrl(displayValue: searchQuery);
    }

    return CodeUrl(displayValue: rawValue);
  }

  @override
  String toString() {
    return displayValue;
  }
}

// Class to manage email
class CodeEmail {
  final String address;
  final String? subject;
  final String? body;

  CodeEmail({required this.address, this.subject, this.body});

  factory CodeEmail.fromRawValue(String rawValue) {
    String cleanedRawEmail = rawValue.replaceFirst('MATMSG:', '');
    final List<String> emailParts = cleanedRawEmail.split(';');
    String emailAddress = '';
    String emailSubject = '';
    String emailBody = '';

    for (String part in emailParts) {
      if (part.startsWith('TO:')) {
        emailAddress = part.replaceFirst('TO:', '').trim();
      } else if (part.startsWith('SUB:')) {
        emailSubject = part.replaceFirst('SUB:', '').trim();
      } else if (part.startsWith('BODY:')) {
        emailBody = part.replaceFirst('BODY:', '').trim();
      }
    }

    emailBody = emailBody.replaceAll(r"\'", "'");

    return CodeEmail(
      address: emailAddress,
      subject: emailSubject,
      body: emailBody,
    );
  }

  @override
  String toString() {
    return '$address\n$subject';
  }
}

// Class to manage phone number
class CodePhoneNumber {
  final String number;

  CodePhoneNumber({required this.number});

  factory CodePhoneNumber.fromRawValue(String rawValue) {
    String extractedNumber = rawValue.replaceFirst('tel:', '').trim();
    return CodePhoneNumber(number: extractedNumber);
  }

  @override
  String toString() {
    return number;
  }
}

// Class to manage sms
class CodeSms {
  final String phoneNumber;
  final String message;

  CodeSms({required this.phoneNumber, required this.message});

  factory CodeSms.fromRawValue(String rawValue) {
    final RegExp regex = RegExp(r'SMSTO:(\+?\d+):(.*)');
    final Match? match = regex.firstMatch(rawValue);

    if (match != null && match.groupCount > 1) {
      String phoneNumber = match.group(1) ?? '';
      String message = match.group(2)?.trim() ?? '';
      return CodeSms(phoneNumber: phoneNumber, message: message);
    }

    return CodeSms(phoneNumber: 'N/A', message: 'N/A');
  }

  @override
  String toString() {
    return '$phoneNumber\n$message';
  }
}

// Class to manage contacts
class CodeContact {
  final String name;
  final String surname;
  final String phoneNumber;
  final String email;

  CodeContact({
    required this.name,
    required this.surname,
    required this.phoneNumber,
    required this.email,
  });

  factory CodeContact.fromRawValue(String rawValue) {
    String cleanedRawContact = rawValue
        .replaceFirst('BEGIN:VCARD', '')
        .replaceFirst('END:VCARD', '')
        .trim();

    final List<String> contactParts = cleanedRawContact.split('\n');
    String name = '';
    String surname = '';
    String phoneNumber = '';
    String email = '';

    for (String part in contactParts) {
      part = part.trim();

      if (part.startsWith('FN:')) {
        String fullName = part.replaceFirst('FN:', '').trim();
        List<String> names = fullName.split(' ');
        if (names.isNotEmpty) {
          name = names.first;
          surname = names.length > 1 ? names.sublist(1).join(' ') : '';
        }
      } else if (part.startsWith('N;CHARSET=UTF-8:')) {
        List<String> names =
            part.replaceFirst('N;CHARSET=UTF-8:', '').trim().split(';');
        if (names.length >= 2) {
          surname = names[0];
          name = names[1];
        }
      } else if (part.startsWith('N:')) {
        List<String> names = part.replaceFirst('N:', '').trim().split(';');
        if (names.length >= 2) {
          surname = names[0];
          name = names[1];
        }
      } else if (part.startsWith('TEL;')) {
        phoneNumber = part.replaceFirst(RegExp(r'TEL;.*?:'), '').trim();
      } else if (part.startsWith('TEL:')) {
        phoneNumber = part.replaceFirst('TEL:', '').trim();
      } else if (part.startsWith('EMAIL:')) {
        email = part.replaceFirst('EMAIL:', '').trim();
      }
    }

    return CodeContact(
      name: name,
      surname: surname,
      phoneNumber: phoneNumber,
      email: email,
    );
  }

  @override
  String toString() {
    return '$name\n$surname';
  }
}

// Class to manage locations
class CodeGeo {
  final String latitude;
  final String longitude;

  CodeGeo({
    required this.latitude,
    required this.longitude,
  });

  factory CodeGeo.fromRawValue(String rawValue) {
    List<String> parts = rawValue.split(',');
    String latitude = parts.isNotEmpty ? parts[0].replaceFirst('geo:', '') : '';
    String longitude = parts.length > 1 ? parts[1].split('?')[0] : '';

    return CodeGeo(
      latitude: latitude,
      longitude: longitude,
    );
  }

  @override
  String toString() {
    return '$latitude\n$longitude';
  }
}

// Class to manage wifi
class CodeWifi {
  final String ssid;
  final String password;
  final String authenticationType;
  final bool hidden;

  CodeWifi({
    required this.ssid,
    required this.password,
    required this.authenticationType,
    required this.hidden,
  });

  factory CodeWifi.fromRawValue(String rawValue) {
    final RegExp regExp = RegExp(r'WIFI:T:(.*?);S:(.*?);P:(.*?);H:(.*?);');
    final match = regExp.firstMatch(rawValue);

    if (match != null) {
      return CodeWifi(
        ssid: match.group(2) ?? '',
        password: match.group(3) ?? '',
        authenticationType: match.group(1) ?? '',
        hidden: match.group(4) == 'true',
      );
    } else {
      throw Exception('Invalid WiFi barcode content');
    }
  }

  @override
  String toString() {
    return '$ssid\n$password';
  }
}

// Class to manage events
class CodeEvent {
  final String title;
  final String startDate;
  final String formattedStartDate;
  final String endDate;
  final String formattedEndDate;
  final String location;

  CodeEvent({
    required this.title,
    required this.startDate,
    required this.formattedStartDate,
    required this.endDate,
    required this.formattedEndDate,
    required this.location,
  });

  static String convertToCustomFormat(String date) {
    DateTime dateTime =
        DateTime.parse(date.replaceAll('T', ' ').replaceAll('Z', ''));
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  factory CodeEvent.fromRawValue(String rawValue) {
    List<String> lines = rawValue.split('\n');

    String title = '';
    String startDate = '';
    String formattedStartDate = '';
    String endDate = '';
    String formattedEndDate = '';
    String location = '';

    for (String line in lines) {
      if (line.startsWith('SUMMARY:')) {
        title = line.replaceFirst('SUMMARY:', '').trim();
      } else if (line.startsWith('DTSTART:')) {
        String date = line.replaceFirst('DTSTART:', '').trim();
        startDate = date;
        formattedStartDate = convertToCustomFormat(date);
      } else if (line.startsWith('DTEND:')) {
        String date = line.replaceFirst('DTEND:', '').trim();
        endDate = date;
        formattedEndDate = convertToCustomFormat(date);
      } else if (line.startsWith('LOCATION:')) {
        location = line.replaceFirst('LOCATION:', '').trim();
      }
    }

    return CodeEvent(
      title: title,
      startDate: startDate,
      formattedStartDate: formattedStartDate,
      endDate: endDate,
      formattedEndDate: formattedEndDate,
      location: location,
    );
  }

  String toRawValue() {
    return 'SUMMARY:$title\nDTSTART:$formattedStartDate\nDTEND:$formattedEndDate\nLOCATION:$location';
  }

  @override
  String toString() {
    return '$title\n$formattedStartDate\n$formattedEndDate\n$location';
  }
}

String convertToCustomFormat(String date) {
  try {
    if (date.length == 16) {
      date = "$date:00";
    }

    if (date.contains("/")) {
      List<String> parts = date.split(" ");
      List<String> dateParts = parts[0].split("/");
      String formattedDate =
          "${dateParts[2]}-${dateParts[1]}-${dateParts[0]}T${parts[1]}";

      return formattedDate;
    } else {
      return date;
    }
  } catch (e) {
    return date;
  }
}

// Class to manage products
class CodeProduct {
  final String barcode;

  CodeProduct({required this.barcode});

  factory CodeProduct.fromRawValue(String rawValue) {
    final parts = rawValue.split(' - ');

    if (parts.isEmpty || parts[0].isEmpty) {
      throw FormatException(
          'Formato del valore scansionato non valido: $rawValue');
    }

    return CodeProduct(
      barcode: parts[0],
    );
  }

  @override
  String toString() {
    return barcode;
  }
}

// Class to manage ISBN
class CodeISBN {
  final String isbn;

  CodeISBN({required this.isbn});

  factory CodeISBN.fromRawValue(String rawValue) {
    if (rawValue.isEmpty) {
      throw FormatException(
          'Formato del valore scansionato non valido: $rawValue');
    }

    return CodeISBN(isbn: rawValue);
  }

  @override
  String toString() {
    return isbn;
  }

  String toRawValue() {
    return isbn;
  }
}
