import '../models/market.dart';
import 'package:uuid/uuid.dart';

class MarketService {
  static final List<MarketPrice> _prices = [
    MarketPrice(
      id: '1',
      crop: 'Maize',
      price: 45.0,
      location: 'Nairobi',
      date: DateTime.now(),
    ),
    MarketPrice(
      id: '2',
      crop: 'Beans',
      price: 120.0,
      location: 'Mombasa',
      date: DateTime.now(),
    ),
  ];

  static const _uuid = Uuid();

  List<MarketPrice> getAllPrices() => _prices;

  List<MarketPrice> getPricesByCrop(String crop) =>
      _prices.where((p) => p.crop.toLowerCase() == crop.toLowerCase()).toList();

  MarketPrice addPrice(String crop, double price, String location) {
    final marketPrice = MarketPrice(
      id: _uuid.v4(),
      crop: crop,
      price: price,
      location: location,
      date: DateTime.now(),
    );
    _prices.add(marketPrice);
    return marketPrice;
  }
}