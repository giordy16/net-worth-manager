class AVQuoteList {
  AVQuoteModel quote;

  AVQuoteList(this.quote);

  factory AVQuoteList.fromJson(Map<String, dynamic> json) =>
      AVQuoteList(AVQuoteModel.fromJson(json["Global Quote"]));
}

class AVQuoteModel {
  String symbol;
  double price;

  AVQuoteModel(this.symbol, this.price);

  factory AVQuoteModel.fromJson(Map<String, dynamic> json) =>
      AVQuoteModel(json["01. symbol"], double.parse(json["05. price"]));
}
