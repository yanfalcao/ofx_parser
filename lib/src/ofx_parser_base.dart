import 'package:ofx_parser/src/exceptions/ofx_field_not_found_exception.dart';
import 'package:ofx_parser/src/models/account.dart';
import 'package:ofx_parser/src/models/account_type.dart';
import 'package:ofx_parser/src/models/signon.dart';
import 'package:xml/xml.dart';

import 'models/ofx.dart';
import 'models/transaction.dart';

class OfxParser {
  late final XmlDocument ofxDocument;

  OfxParser(String ofx) {
    ofxDocument = XmlDocument.parse(ofx);
  }

  Ofx parse() {
    try{
      final signon = parseSignon();
      List<Account> accounts = [];

      accounts.addAll(parseBankAccounts());
      accounts.addAll(parseCreditCardAccounts());

      return Ofx(
        signon: signon,
        accounts: accounts
      );
    } catch (exception) {
      rethrow;
    }
  }

  Signon parseSignon() {
    final sonrsElement = ofxDocument
        .getElement('OFX')
        ?.getElement('SIGNONMSGSRSV1')
        ?.getElement('SONRS');
    final statusElement = sonrsElement?.getElement('STATUS');
    final fiElement = sonrsElement?.getElement('FI');

    final code = statusElement?.getElement('CODE')?.text;
    final severity = statusElement?.getElement('SEVERITY')?.text;
    final dateServer = sonrsElement?.getElement('DTSERVER')?.text;
    final language = sonrsElement?.getElement('LANGUAGE')?.text;

    if (code != null
        && severity != null
        && dateServer != null
        && language != null) {
      return Signon(
        code: code,
        severity: severity,
        dateServer: _parseOfxDate(dateServer),
        language: language,
        fiOrganization: fiElement?.getElement('ORG')?.text,
        fiId: fiElement?.getElement('FID')?.text
      );
    }
    throw OfxFieldNotFoundException();
  }

  List<Account> parseBankAccounts() {
    final ofxElement =  ofxDocument.getElement('OFX');
    if(ofxElement == null){
      throw OfxFieldNotFoundException();
    }

    final accountElements = ofxElement
        .getElement('BANKMSGSRSV1')
        ?.findElements('STMTTRNRS');

    if(accountElements != null && accountElements.isNotEmpty) {
      return _parseAccounts(accountElements.toList(), AccountType.Bank);
    }
    return [];
  }

  List<Account> parseCreditCardAccounts() {
    final ofxElement =  ofxDocument.getElement('OFX');
    if(ofxElement == null){
      throw OfxFieldNotFoundException();
    }

    final accountElements = ofxElement
        .getElement('CREDITCARDMSGSRSV1')
        ?.findElements('CCSTMTTRNRS');

    if(accountElements != null && accountElements.isNotEmpty) {
      return _parseAccounts(accountElements.toList(), AccountType.CreditCard);
    }
    return [];
  }

  List<Transaction> parseTransactions() {
    List<Transaction> transactions = [];
    final elements = ofxDocument.findAllElements('STMTTRN');

    for (var element in elements.toList()) {
      transactions.add(
        Transaction(
          id: element.findElements('FITID').single.text,
          type: element.findElements('TRNTYPE').single.text,
          date: _parseOfxDate(element.findElements('DTPOSTED').single.text),
          amount: double.tryParse(element.findElements('TRNAMT').single.text),
          description: element.findElements('MEMO').single.text,
        ),
      );
    }

    return transactions;
  }

  List<Account> _parseAccounts(List<XmlElement> accountsElement, AccountType type) {
    List<Account> accountList = [];
    for(var element in accountsElement) {
      final trnuid = element.getElement('TRNUID')?.text;
      final code = element.getElement('STATUS')?.getElement('CODE')?.text;
      final severity = element.getElement('STATUS')?.getElement('SEVERITY')?.text;

      if(trnuid != null && code != null && severity != null){
        var account = Account(
          trnuid: trnuid,
          type: type,
          statusCode: code,
          statusSeverity: severity
        );

        var acctid = element.findAllElements('ACCTID');
        if(acctid.isNotEmpty){
          account.accountId = acctid.elementAt(0).text;
        }

        var bankid = element.findAllElements('BANKID');
        if(bankid.isNotEmpty){
          account.routingNumber = bankid.elementAt(0).text;
        }

        var branchid = element.findAllElements('BRANCHID');
        if(branchid.isNotEmpty){
          account.branchId = branchid.elementAt(0).text;
        }

        accountList.add(account);
      }
    }

    return accountList;
  }

  DateTime _parseOfxDate(String ofxDate) {
    String dateString = ofxDate.substring(0, 8);

    return DateTime.parse(dateString);
  }
}
