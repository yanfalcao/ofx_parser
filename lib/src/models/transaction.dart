class Transaction {
  Transaction({
    this.id,
    this.type,
    this.date,
    this.amount,
    this.description,
  });

  String? id;
  String? type;
  DateTime? date;
  double? amount;
  String? description;

  @override
  String toString() {
    return "id:$id, type:$type, date:$date, amount:$amount, description:$description";
  }
}
