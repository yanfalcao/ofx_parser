import 'account_type.dart';

class Account {
  Account({
    required this.statusCode,
    required this.statusSeverity,
    required this.trnuid,
    required this.type,
    this.accountId,
    this.routingNumber,
    this.branchId,
  });

  /// Client-assigned globally-unique ID for the transaction
  String trnuid;

  /// The account number
  String? accountId;

  /// Bank identifier
  String? routingNumber;

  /// Transit ID / branch number
  String? branchId;

  /// An AccountType object
  AccountType type;

  // TODO: Implements classes Statement
  // Statement statement;

  /// Error code
  String statusCode;

  /// Severity of the error:
  ///
  /// * INFO = Informational only
  /// * WARN = Some problem with the request occurred but a valid response
  /// still present
  /// * ERROR = A problem severe enough that response could not be made
  String statusSeverity;

  /// Messages for generic errors based in the status code
  String get statusCodeMessage {
    switch(statusCode) {
      case '0':
        return 'Success';
      case '2000':
        return 'General error';
      case '2022':
        return 'Invalid TAN';
      default:
        return 'CodeSignonge not found';
    }
  }
}

