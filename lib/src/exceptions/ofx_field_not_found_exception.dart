import 'package:ofx_parser/src/exceptions/base_exception.dart';

class OfxFieldNotFoundException implements BaseException {
  @override
  String message() => 'Required field in OFX file do not found';
}