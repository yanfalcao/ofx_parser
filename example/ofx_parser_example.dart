import 'dart:io';

import 'package:ofx_parser/ofx_parser.dart';

void main() async {
  File ofxFile = File("./example/example.ofx");
  final String fileStringContent = await ofxFile.readAsString();

  final List<STMTTRN> stmttrn = OfxParser(fileStringContent).getSTMTTRN();

  for (var element in stmttrn) {
    print(element.toString());
  }
}
