class MarketPrice {
  final String id;
  final String crop;
  final double price;
  final String location;
  final DateTime date;

  MarketPrice({
    required this.id,
    required this.crop,
    required this.price,
    required this.location,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'crop': crop,
    'price': price,
    'location': location,
    'date': date.toIso8601String(),
  };

  factory MarketPrice.fromJson(Map<String, dynamic> json) => MarketPrice(
    id: json['id'],
    crop: json['crop'],
    price: json['price'].toDouble(),
    location: json['location'],
    date: DateTime.parse(json['date']),
  );
}

class MatchRequest {
  final String farmerId;
  final String crop;
  final double quantity;
  final double minPrice;

  MatchRequest({
    required this.farmerId,
    required this.crop,
    required this.quantity,
    required this.minPrice,
  });

  factory MatchRequest.fromJson(Map<String, dynamic> json) => MatchRequest(
    farmerId: json['farmerId'],
    crop: json['crop'],
    quantity: json['quantity'].toDouble(),
    minPrice: json['minPrice'].toDouble(),
  );
}