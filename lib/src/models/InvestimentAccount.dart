import 'package:ofx_parser/src/models/account.dart';

class InvestmentAccount extends Account {
  InvestmentAccount({
    required super.statusCode,
    required super.statusSeverity,
    required super.trnuid,
    required super.type,
    super.currency,
    super.accountId,
    this.brokerId
  });

  /// Investment broker ID
  String? brokerId;
}