import 'dart:convert';
import 'package:xml2json/xml2json.dart';
import 'models/stmttrn.dart';

class OfxParser {
  final String ofxString;
  late Map<String, dynamic> mappedOfx;

  OfxParser(this.ofxString) {
    final xmlParser = Xml2Json();
    xmlParser.parse(ofxString);
    final jsonString = xmlParser.toParker();
    mappedOfx = jsonDecode(jsonString);
  }

  List<STMTTRN> getSTMTTRN() {
    var stmttrn = mappedOfx['OFX']['BANKMSGSRSV1']['STMTTRNRS']['STMTRS']['BANKTRANLIST']['STMTTRN'];

    List<STMTTRN> transactions = [];
    for (var element in stmttrn) {
      transactions.add(STMTTRN.fromMap(element));
    }

    return transactions;
  }
}
