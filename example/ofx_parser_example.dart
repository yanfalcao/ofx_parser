import 'dart:io';

import 'package:ofx_parser/ofx_parser.dart';

void main() async {
  File ofxFile = File("./example/example.ofx");
  final String fileStringContent = await ofxFile.readAsString();

  var transactions = OfxParser.getTransactions(fileStringContent);

  for (var element in transactions) {
    print(element);
  }
}
