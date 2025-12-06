# FarmBridge API Documentation
## RESTful API Reference

### Base URL
```
Development: http://localhost:8080/api/v1
Production: https://api.farmbridge.com/api/v1
```

### Authentication
All protected endpoints require JWT token in header:
```
Authorization: Bearer <jwt_token>
```

## Authentication Endpoints

### Register User
**POST** `/auth/register`

**Request Body:**
```json
{
  "name": "John Farmer",
  "phone": "+254712345678",
  "password": "securepassword",
  "role": "FARMER"
}
```

**Response (201):**
```json
{
  "id": "uuid-string",
  "name": "John Farmer",
  "phone": "+254712345678",
  "role": "FARMER"
}
```

**Errors:**
- `400`: Invalid request data
- `409`: Phone number already exists

### Login User
**POST** `/auth/login`

**Request Body:**
```json
{
  "phone": "+254712345678",
  "password": "securepassword"
}
```

**Response (200):**
```json
{
  "token": "jwt.token.string"
}
```

**Errors:**
- `400`: Invalid request data
- `401`: Invalid credentials

## Market Endpoints

### Get All Market Prices
**GET** `/market/prices`

**Response (200):**
```json
[
  {
    "id": "price-uuid",
    "crop": "Maize",
    "price": 45.50,
    "location": "Nairobi",
    "date": "2024-01-15T10:30:00Z"
  },
  {
    "id": "price-uuid-2",
    "crop": "Beans",
    "price": 120.00,
    "location": "Mombasa",
    "date": "2024-01-15T11:00:00Z"
  }
]
```

### Get Prices by Crop
**GET** `/market/prices/{crop}`

**Parameters:**
- `crop` (string): Crop name (e.g., "Maize", "Beans")

**Response (200):**
```json
[
  {
    "id": "price-uuid",
    "crop": "Maize",
    "price": 45.50,
    "location": "Nairobi",
    "date": "2024-01-15T10:30:00Z"
  }
]
```

## Matching Endpoints

### Find Matches
**POST** `/matching/find`

**Request Body:**
```json
{
  "farmerId": "farmer-uuid",
  "crop": "Maize",
  "quantity": 100.0,
  "minPrice": 40.0
}
```

**Response (200):**
```json
[
  {
    "id": "price-uuid",
    "crop": "Maize",
    "price": 45.50,
    "location": "Nairobi",
    "date": "2024-01-15T10:30:00Z"
  }
]
```

### Create Match
**POST** `/matching/create`

**Request Body:**
```json
{
  "farmerId": "farmer-uuid",
  "buyerId": "buyer-uuid",
  "crop": "Maize",
  "quantity": 100.0,
  "price": 45.50
}
```

**Response (200):**
```json
{
  "matchId": "match-uuid",
  "farmerId": "farmer-uuid",
  "buyerId": "buyer-uuid",
  "crop": "Maize",
  "quantity": 100.0,
  "price": 45.50,
  "status": "PENDING",
  "createdAt": "2024-01-15T12:00:00Z"
}
```

## AI Service Endpoints

### Get Crop Recommendation
**POST** `/ai/crop-recommendation`

**Request Body:**
```json
{
  "location": "Central Kenya",
  "soilType": "Clay loam",
  "season": "Rainy season"
}
```

**Response (200):**
```json
{
  "recommendation": "Based on your location and soil type, I recommend planting Maize and Beans. The clay loam soil is ideal for these crops during the rainy season. Expected yield: 25-30 bags per acre for maize..."
}
```

### Analyze Crop Image
**POST** `/ai/analyze-image`

**Request Body:**
```json
{
  "image": "base64-encoded-image-string"
}
```

**Response (200):**
```json
{
  "analysis": "This appears to be a healthy maize plant in the vegetative stage. No visible diseases detected. The leaves show good green coloration indicating adequate nitrogen levels...",
  "confidence": 0.85
}
```

### Predict Crop Yield
**POST** `/ai/predict-yield`

**Request Body:**
```json
{
  "crop": "Maize",
  "acreage": 5.0,
  "soilType": "Clay",
  "rainfall": 800,
  "fertilizer": "DAP + CAN",
  "location": "Central Kenya"
}
```

**Response (200):**
```json
{
  "predicted_yield": 125.5,
  "confidence": 0.78,
  "unit": "bags"
}
```

### Get Price Forecast
**POST** `/ai/price-forecast`

**Request Body:**
```json
{
  "crop": "Maize",
  "days": 30
}
```

**Response (200):**
```json
{
  "forecast": [
    {
      "date": "2024-01-16",
      "predicted_price": 46.20,
      "confidence": 0.82
    },
    {
      "date": "2024-01-17",
      "predicted_price": 46.80,
      "confidence": 0.79
    }
  ]
}
```

## Health Check

### Server Health
**GET** `/health`

**Response (200):**
```json
{
  "status": "healthy",
  "timestamp": "2024-01-15T12:00:00Z",
  "version": "1.0.0"
}
```

## Error Responses

### Standard Error Format
```json
{
  "error": "Error message description",
  "code": "ERROR_CODE",
  "timestamp": "2024-01-15T12:00:00Z"
}
```

### HTTP Status Codes
- `200`: Success
- `201`: Created
- `400`: Bad Request
- `401`: Unauthorized
- `403`: Forbidden
- `404`: Not Found
- `409`: Conflict
- `500`: Internal Server Error

## Rate Limiting
- **Limit**: 100 requests per minute per IP
- **Headers**: 
  - `X-RateLimit-Limit`: Request limit
  - `X-RateLimit-Remaining`: Remaining requests
  - `X-RateLimit-Reset`: Reset timestamp

## Data Models

### User Model
```json
{
  "id": "string (UUID)",
  "name": "string",
  "phone": "string (E.164 format)",
  "role": "FARMER | BUYER | ADMIN",
  "createdAt": "string (ISO 8601)"
}
```

### Market Price Model
```json
{
  "id": "string (UUID)",
  "crop": "string",
  "price": "number (KSh per unit)",
  "location": "string",
  "date": "string (ISO 8601)",
  "source": "string"
}
```

### Match Model
```json
{
  "matchId": "string (UUID)",
  "farmerId": "string (UUID)",
  "buyerId": "string (UUID)",
  "crop": "string",
  "quantity": "number (kg)",
  "price": "number (KSh per kg)",
  "status": "PENDING | CONFIRMED | COMPLETED | CANCELLED",
  "createdAt": "string (ISO 8601)",
  "updatedAt": "string (ISO 8601)"
}
```

## SDK Examples

### Dart/Flutter
```dart
class FarmBridgeAPI {
  static const String baseUrl = 'http://localhost:8080/api/v1';
  
  static Future<String?> login(String phone, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone, 'password': password}),
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['token'];
    }
    return null;
  }
}
```

### JavaScript/Node.js
```javascript
const FarmBridgeAPI = {
  baseUrl: 'http://localhost:8080/api/v1',
  
  async login(phone, password) {
    const response = await fetch(`${this.baseUrl}/auth/login`, {
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      body: JSON.stringify({phone, password})
    });
    
    if (response.ok) {
      const data = await response.json();
      return data.token;
    }
    return null;
  }
};
```

### cURL Examples
```bash
# Login
curl -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"phone":"+254712345678","password":"password"}'

# Get market prices
curl -X GET http://localhost:8080/api/v1/market/prices \
  -H "Authorization: Bearer <token>"

# Find matches
curl -X POST http://localhost:8080/api/v1/matching/find \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <token>" \
  -d '{"farmerId":"uuid","crop":"Maize","quantity":100,"minPrice":40}'
```