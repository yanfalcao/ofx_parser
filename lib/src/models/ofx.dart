import 'package:ofx_parser/src/models/account.dart';
import 'package:ofx_parser/src/models/signon.dart';

class Ofx{
  Ofx({
    required this.signon,
    this.accounts
  });

  Signon signon;
  List<Account>? accounts;
}