import 'dart:io';

import 'package:ofx_parser/ofx_parser.dart';

void main() async {
  final ofxFile = File("./example/example.ofx");
  final parser = OfxParser(await ofxFile.readAsString());

  var status = parser.parseStatus();
  var transactions = parser.parseTransactions();

  print(status);
  for (var element in transactions) {
    print(element);
  }
}
