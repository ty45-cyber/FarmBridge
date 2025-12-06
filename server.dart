import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import '../lib/controllers/auth_controller.dart';
import '../lib/controllers/market_controller.dart';
import '../lib/controllers/matching_controller.dart';
import '../lib/controllers/ai_controller.dart';

void main() async {
  final authController = AuthController();
  final marketController = MarketController();
  final matchingController = MatchingController();
  final aiController = AIController();
  
  final app = Router();
  
  app.mount('/api/v1/auth/', authController.router);
  app.mount('/api/v1/market/', marketController.router);
  app.mount('/api/v1/matching/', matchingController.router);
  app.mount('/api/v1/ai/', aiController.router);
  
  app.get('/health', (Request request) {
    return Response.ok('{"status": "healthy"}', 
      headers: {'Content-Type': 'application/json'});
  });

  final handler = Pipeline()
      .addMiddleware(corsHeaders())
      .addMiddleware(logRequests())
      .addHandler(app);

  final server = await serve(handler, InternetAddress.anyIPv4, 3000);
  print('Server running on http://localhost:${server.port}');
}