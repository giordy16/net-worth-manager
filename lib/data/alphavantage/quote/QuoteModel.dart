class QuoteList {
  QuoteModel quote;

  QuoteList(this.quote);

  factory QuoteList.fromJson(Map<String, dynamic> json) =>
      QuoteList(QuoteModel.fromJson(json["Global Quote"]));
}

class QuoteModel {
  String symbol;
  double price;

  QuoteModel(this.symbol, this.price);

  factory QuoteModel.fromJson(Map<String, dynamic> json) =>
      QuoteModel(json["01. symbol"], double.parse(json["05. price"]));
}
