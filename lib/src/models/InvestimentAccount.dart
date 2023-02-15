import 'package:ofx_parser/src/models/account.dart';

class InvestmentAccount extends Account {
  InvestmentAccount({
    required super.statusCode,
    required super.statusSeverity,
    required super.trnuid,
    required super.type,
    super.branchId,
    super.routingNumber,
    super.accountId,
    this.brokerId
  });

  String? brokerId;
}