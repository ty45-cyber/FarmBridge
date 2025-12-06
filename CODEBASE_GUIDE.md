# FarmBridge Codebase Guide
## Understanding the Code Structure

### Quick Navigation
- [Getting Started](#getting-started)
- [Backend Architecture](#backend-architecture)
- [Frontend Architecture](#frontend-architecture)
- [AI Integration](#ai-integration)
- [Data Flow](#data-flow)
- [Key Files](#key-files)

## Getting Started

### 1. Project Overview
FarmBridge connects farmers with buyers using AI-powered insights. The codebase is split into:
- **Backend**: Dart/Shelf REST API server
- **Frontend**: Flutter mobile application
- **AI Services**: Google Cloud AI integration

### 2. Running the Application
```bash
# Terminal 1: Start Backend
cd backend_dart
dart pub get
dart run bin/server.dart

# Terminal 2: Start Frontend
cd frontend_flutter
flutter pub get
flutter run
```

## Backend Architecture

### Entry Point: `bin/server.dart`
```dart
void main() async {
  // 1. Initialize controllers
  final authController = AuthController();
  final marketController = MarketController();
  final matchingController = MatchingController();
  final aiController = AIController();
  
  // 2. Setup routes
  final app = Router();
  app.mount('/api/v1/auth/', authController.router);
  app.mount('/api/v1/market/', marketController.router);
  app.mount('/api/v1/matching/', matchingController.router);
  app.mount('/api/v1/ai/', aiController.router);
  
  // 3. Start server on port 8080
  final server = await serve(handler, InternetAddress.anyIPv4, 8080);
}
```

### Controller Layer
**Purpose**: Handle HTTP requests and responses

**Example: AuthController**
```dart
class AuthController {
  final UserService _userService = UserService();

  Router get router {
    final router = Router();
    router.post('/register', _register);  // POST /api/v1/auth/register
    router.post('/login', _login);        // POST /api/v1/auth/login
    return router;
  }

  Future<Response> _register(Request request) async {
    // 1. Parse JSON from request body
    final body = await request.readAsString();
    final json = jsonDecode(body);
    final registerRequest = RegisterRequest.fromJson(json);
    
    // 2. Call service layer
    final user = _userService.register(registerRequest);
    
    // 3. Return JSON response
    return Response.ok(jsonEncode(user.toJson()));
  }
}
```

### Service Layer
**Purpose**: Business logic and data processing

**Example: UserService**
```dart
class UserService {
  final UserRepository _userRepository = UserRepository();
  final JwtService _jwtService = JwtService();

  User register(RegisterRequest request) {
    // 1. Hash password
    final hashedPassword = sha256.convert(utf8.encode(request.password)).toString();
    
    // 2. Create user object
    final user = User(
      id: '',
      name: request.name,
      phone: request.phone,
      password: hashedPassword,
      role: request.role,
    );
    
    // 3. Save to database
    return _userRepository.save(user);
  }
}
```

### Repository Layer
**Purpose**: Data access and storage

**Example: UserRepository**
```dart
class UserRepository {
  static final Map<String, User> _users = {};  // In-memory storage
  static const _uuid = Uuid();

  User save(User user) {
    final id = user.id.isEmpty ? _uuid.v4() : user.id;
    final savedUser = User(/* ... */);
    _users[id] = savedUser;  // Store in memory
    return savedUser;
  }

  User? findByPhone(String phone) {
    return _users.values.where((u) => u.phone == phone).firstOrNull;
  }
}
```

## Frontend Architecture

### Entry Point: `lib/main.dart`
```dart
void main() {
  runApp(const FarmBridgeApp());
}

class FarmBridgeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FarmBridge',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const LoginScreen(),  // Start with login
    );
  }
}
```

### Screen Layer
**Purpose**: UI screens and user interaction

**Example: LoginScreen**
```dart
class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _apiService = ApiService();

  Future<void> _login() async {
    // 1. Get user input
    final phone = _phoneController.text;
    final password = _passwordController.text;
    
    // 2. Call API service
    final token = await _apiService.login(phone, password);
    
    // 3. Navigate on success
    if (token != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(controller: _phoneController),
          TextField(controller: _passwordController, obscureText: true),
          ElevatedButton(onPressed: _login, child: Text('Login')),
        ],
      ),
    );
  }
}
```

### Service Layer (Frontend)
**Purpose**: API communication and data management

**Example: ApiService**
```dart
class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8080/api/v1';

  Future<String?> login(String phone, String password) async {
    try {
      // 1. Make HTTP POST request
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone, 'password': password}),
      );

      // 2. Parse response
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['token'];  // Return JWT token
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
```

## AI Integration

### Google ML Kit (On-Device)
```dart
class MLService {
  Future<Map<String, dynamic>> analyzeCropImage() async {
    // 1. Take photo with camera
    final XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
    
    // 2. Process with ML Kit
    final inputImage = InputImage.fromFilePath(image!.path);
    final imageLabeler = ImageLabeler();
    final List<ImageLabel> labels = await imageLabeler.processImage(inputImage);
    
    // 3. Return analysis results
    return {
      'labels': labels.map((label) => {
        'name': label.label,
        'confidence': label.confidence,
      }).toList(),
    };
  }
}
```

### Google Vertex AI (Cloud)
```dart
class VertexAIService {
  Future<Map<String, dynamic>> predictCropYield(Map<String, dynamic> farmData) async {
    // 1. Prepare API request
    final endpoint = 'https://us-central1-aiplatform.googleapis.com/v1/projects/PROJECT_ID/locations/us-central1/endpoints/ENDPOINT_ID:predict';
    
    // 2. Make prediction request
    final response = await http.post(
      Uri.parse(endpoint),
      headers: {'Authorization': 'Bearer ACCESS_TOKEN'},
      body: jsonEncode({'instances': [farmData]}),
    );
    
    // 3. Return prediction
    final data = jsonDecode(response.body);
    return {'predicted_yield': data['predictions'][0]['value']};
  }
}
```

## Data Flow

### User Registration Flow
```
1. User fills registration form (RegisterScreen)
2. Form data sent to ApiService.register()
3. HTTP POST to /api/v1/auth/register
4. AuthController._register() processes request
5. UserService.register() handles business logic
6. UserRepository.save() stores user data
7. Response sent back to frontend
8. User navigated to dashboard
```

### Market Price Flow
```
1. User opens dashboard (DashboardScreen)
2. Screen calls ApiService.getMarketPrices()
3. HTTP GET to /api/v1/market/prices
4. MarketController._getPrices() handles request
5. MarketService.getAllPrices() returns data
6. JSON response sent to frontend
7. Prices displayed in ListView
```

### AI Analysis Flow
```
1. User taps camera button (AIAssistantScreen)
2. MLService.analyzeCropImage() called
3. Camera opens, user takes photo
4. ML Kit processes image on-device
5. Results displayed immediately
6. Optional: Send to cloud AI for advanced analysis
```

## Key Files Explained

### Backend Files
- **`bin/server.dart`**: Main server entry point, sets up routes
- **`lib/controllers/auth_controller.dart`**: Handles login/register requests
- **`lib/services/user_service.dart`**: User business logic
- **`lib/models/user.dart`**: User data structure
- **`pubspec.yaml`**: Dependencies and project configuration

### Frontend Files
- **`lib/main.dart`**: App entry point, sets up navigation
- **`lib/screens/login_screen.dart`**: Login UI and logic
- **`lib/screens/dashboard_screen.dart`**: Main app screen
- **`lib/services/api_service.dart`**: HTTP API communication
- **`pubspec.yaml`**: Flutter dependencies

### Configuration Files
- **`docker-compose.yml`**: Container orchestration
- **`Jenkinsfile`**: CI/CD pipeline configuration
- **`README.md`**: Project overview and setup instructions

## Common Patterns

### Error Handling
```dart
// Backend
try {
  final user = _userService.register(request);
  return Response.ok(jsonEncode(user.toJson()));
} catch (e) {
  return Response.badRequest(body: jsonEncode({'error': 'Registration failed'}));
}

// Frontend
try {
  final token = await _apiService.login(phone, password);
  if (token != null) {
    // Success
  } else {
    // Show error message
  }
} catch (e) {
  // Handle network errors
}
```

### State Management
```dart
class _DashboardScreenState extends State<DashboardScreen> {
  List<MarketPrice> _prices = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPrices();  // Load data when screen opens
  }

  Future<void> _loadPrices() async {
    final prices = await _apiService.getMarketPrices();
    setState(() {
      _prices = prices;
      _isLoading = false;  // Update UI
    });
  }
}
```

### JSON Serialization
```dart
class User {
  final String id;
  final String name;

  // Convert object to JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };

  // Create object from JSON
  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    name: json['name'],
  );
}
```

This guide provides a practical understanding of how the FarmBridge codebase is organized and how different components work together.