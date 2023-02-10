class STMTTRN {
  String? trntype;
  String? dtposted;
  String? trnamt;
  String? fitid;
  String? checknum;
  String? refnum;
  String? memo;

  STMTTRN({this.trntype, this.dtposted, this.trnamt, this.fitid, this.checknum, this.refnum, this.memo});

  STMTTRN.fromMap(Map<String, dynamic> json) {
    trntype = json['TRNTYPE'];
    dtposted = json['DTPOSTED'];
    trnamt = json['TRNAMT'];
    fitid = json['FITID'];
    checknum = json['CHECKNUM'];
    refnum = json['REFNUM'];
    memo = json['MEMO'];
  }

  @override
  String toString() {
    return "TRNTYPE:$trntype, DTPOSTED:$dtposted, TRNAMT:$trnamt, FITID:$fitid, CHECKNUM:$checknum, REFNUM:$refnum, MEMO:$memo";
  }
}
