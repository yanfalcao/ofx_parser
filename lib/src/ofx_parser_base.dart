import 'package:xml/xml.dart';

import 'models/transaction.dart';

class OfxParser {
  static List<Transaction> getTransactions(String ofx) {
    final xmlData = XmlDocument.parse(ofx);

    List<Transaction> transactions = [];
    final elements = xmlData.findAllElements('STMTTRN');

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
