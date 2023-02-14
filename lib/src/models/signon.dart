class Signon {
  Signon({
    required this.code,
    required this.severity,
    required this.dateServer,
    required this.language,
    this.fiOrganization,
    this.fiId
  });

  /// Status code of the OFX file. Important element that help to identify
  /// success and errors code.
  String code;

  /// [severity] represents the possible status of the OFX file.
  /// Possible status:
  ///
  /// * INFO = Informational only
  /// * WARN = Some problem with the request occurred but a valid response
  /// still present
  /// * ERROR = A problem severe enough that response could not be made
  String severity;

  /// Date and time of the server response
  DateTime dateServer;

  /// Language used in text responses
  String language;

  /// Financial Institution Organization name
  String? fiOrganization;

  /// Financial Institution ID
  String? fiId;

  /// Messages for generic errors based in the status code
  String get codeMessage {
    switch(code) {
      case '0':
        return 'Success';
      case '2000':
        return 'General error';
      case '2021':
        return 'Unsupported version';
      case '2028':
        return 'Requested element unknown';
      case '3000':
        return 'MFA challenge authentication is required';
      case '6502':
        return 'Unable to process embedded transaction due to out-of-date <TOKEN>';
      case '15500':
        return 'Signon invalid';
      case '15512':
        return 'OFX server requires AUTHTOKEN in signon during the next session';
      default:
        return 'CodeSignonge not found';
    }
  }

  @override
  String toString() {
    return "code:$code \nseverity:$severity \ndateServer:$dateServer "
        "\nlanguage:$language \norganization:$fiOrganization \nfid:$fiId "
        "\ncodeMessage:$codeMessage";
  }
}