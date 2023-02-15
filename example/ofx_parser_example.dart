import 'dart:io';

import 'package:ofx_parser/ofx_parser.dart';

void main() async {
  final ofxFile = File("./example/investment_medium.ofx");
  final parser = OfxParser(await ofxFile.readAsString());

  var ofx = parser.parse();
}
