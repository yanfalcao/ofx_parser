import 'package:ofx_parser/src/exceptions/ofx_field_not_found_exception.dart';
import 'package:ofx_parser/src/models/status.dart';
import 'package:xml/xml.dart';

import 'models/transaction.dart';

class OfxParser {
  late final XmlDocument ofxDocument;

  OfxParser(String ofx) {
    ofxDocument = XmlDocument.parse(ofx);
  }

  Status parseStatus(){
    final statusElement = ofxDocument.getElement('OFX')
        ?.getElement('SIGNONMSGSRSV1')
        ?.getElement('SONRS')
        ?.getElement('STATUS');

    final code = statusElement?.getElement('CODE')?.text;
    final severity = statusElement?.getElement('SEVERITY')?.text;

    if(code != null && severity != null) {
      return Status(
          code: int.parse(code),
          severity: severity
      );
    }
    throw OfxFieldNotFoundException();
  }

  List<Transaction> parseTransactions() {
    List<Transaction> transactions = [];
    final elements = ofxDocument.findAllElements('STMTTRN');

    for (var element in elements.toList()) {
      var dtposted = element.findElements('DTPOSTED').single.text;
      var datetime = dtposted.substring(0, 8);

      transactions.add(
        Transaction(
          id: element.findElements('FITID').single.text,
          type: element.findElements('TRNTYPE').single.text,
          date: DateTime.parse(datetime),
          amount: double.tryParse(element.findElements('TRNAMT').single.text),
          description: element.findElements('MEMO').single.text,
        ),
      );
    }

    return transactions;
  }
}
