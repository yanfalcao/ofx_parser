import 'package:ofx_parser/src/exceptions/ofx_field_not_found_exception.dart';
import 'package:ofx_parser/src/models/signon.dart';
import 'package:xml/xml.dart';

import 'models/ofx.dart';
import 'models/transaction.dart';

class OfxParser {
  late final XmlDocument ofxDocument;

  OfxParser(String ofx) {
    ofxDocument = XmlDocument.parse(ofx);
  }

  Ofx parse() {
    try{
      return Ofx(
        signon: parseSignon(),
        // TODO: implements parse accounts method
        accounts: null
      );
    } catch (exception) {
      rethrow;
    }
  }

  Signon parseSignon() {
    final sonrsElement = ofxDocument
        .getElement('OFX')
        ?.getElement('SIGNONMSGSRSV1')
        ?.getElement('SONRS');
    final statusElement = sonrsElement?.getElement('STATUS');
    final fiElement = sonrsElement?.getElement('FI');

    final code = statusElement?.getElement('CODE')?.text;
    final severity = statusElement?.getElement('SEVERITY')?.text;
    final dateServer = sonrsElement?.getElement('DTSERVER')?.text;
    final language = sonrsElement?.getElement('LANGUAGE')?.text;

    if (code != null
        && severity != null
        && dateServer != null
        && language != null) {
      return Signon(
        code: code,
        severity: severity,
        dateServer: _parseOfxDate(dateServer),
        language: language,
        fiOrganization: fiElement?.getElement('ORG')?.text,
        fiId: fiElement?.getElement('FID')?.text
      );
    }
    throw OfxFieldNotFoundException();
  }

  List<Transaction> parseTransactions() {
    List<Transaction> transactions = [];
    final elements = ofxDocument.findAllElements('STMTTRN');

    for (var element in elements.toList()) {
      transactions.add(
        Transaction(
          id: element.findElements('FITID').single.text,
          type: element.findElements('TRNTYPE').single.text,
          date: _parseOfxDate(element.findElements('DTPOSTED').single.text),
          amount: double.tryParse(element.findElements('TRNAMT').single.text),
          description: element.findElements('MEMO').single.text,
        ),
      );
    }

    return transactions;
  }

  DateTime _parseOfxDate(String ofxDate) {
    String dateString = ofxDate.substring(0, 8);

    return DateTime.parse(dateString);
  }
}
