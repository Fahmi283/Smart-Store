class Sales {
  String? uId;
  String? id;
  String name;
  int sellingPrice;
  int barcode;
  int sum;
  String date;

  Sales({
    this.uId,
    this.id,
    required this.name,
    required this.sellingPrice,
    required this.barcode,
    required this.sum,
    required this.date,
  });
}
