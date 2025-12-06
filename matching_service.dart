import '../models/market.dart';
import 'market_service.dart';

class MatchingService {
  final MarketService _marketService = MarketService();

  List<MarketPrice> findMatches(MatchRequest request) {
    final prices = _marketService.getPricesByCrop(request.crop);
    return prices.where((p) => p.price >= request.minPrice).toList();
  }

  Map<String, dynamic> createMatch(String farmerId, String buyerId, String crop, double quantity, double price) {
    return {
      'matchId': DateTime.now().millisecondsSinceEpoch.toString(),
      'farmerId': farmerId,
      'buyerId': buyerId,
      'crop': crop,
      'quantity': quantity,
      'price': price,
      'status': 'PENDING',
      'createdAt': DateTime.now().toIso8601String(),
    };
  }
}