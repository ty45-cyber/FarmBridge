# FarmBridge AI Integration Setup

## Overview
FarmBridge now includes Google AI/ML services:
- **Firebase Genkit**: Crop recommendations & image analysis
- **Vertex AI**: Yield prediction & price forecasting  
- **ML Kit**: On-device crop analysis & disease detection

## Setup Instructions

### 1. Firebase Genkit Setup
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login and create project
firebase login
firebase projects:create farmbridge-ai

# Enable Genkit
firebase genkit:init
```

**Configuration:**
- Update `backend_dart/lib/services/genkit_service.dart`
- Replace `YOUR_FIREBASE_API_KEY` with actual key
- Enable Gemini API in Firebase Console

### 2. Vertex AI Setup
```bash
# Install Google Cloud CLI
gcloud auth login
gcloud config set project farmbridge-ai

# Enable Vertex AI API
gcloud services enable aiplatform.googleapis.com
```

**Configuration:**
- Update `backend_dart/lib/services/vertex_ai_service.dart`
- Replace `your-project-id` with actual project ID
- Create service account and download JSON key
- Set `GOOGLE_APPLICATION_CREDENTIALS` environment variable

### 3. ML Kit Setup (Android)
**Add to `android/app/build.gradle`:**
```gradle
dependencies {
    implementation 'com.google.mlkit:text-recognition:16.0.0'
    implementation 'com.google.mlkit:image-labeling:17.0.7'
}
```

**Add to `android/app/src/main/AndroidManifest.xml`:**
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-feature android:name="android.hardware.camera" android:required="true" />

<meta-data
    android:name="com.google.mlkit.vision.DEPENDENCIES"
    android:value="ocr,ica" />
```

## Features Implemented

### 🤖 AI Assistant Screen
- **Crop Photo Analysis**: Camera integration with ML Kit
- **Disease Detection**: On-device image labeling
- **Smart Recommendations**: AI-powered farming advice
- **Text Recognition**: Read labels and signs in images

### 🧠 Backend AI Services
- **Genkit Integration**: `/api/v1/ai/crop-recommendation`
- **Image Analysis**: `/api/v1/ai/analyze-image`
- **Yield Prediction**: `/api/v1/ai/predict-yield`
- **Price Forecasting**: `/api/v1/ai/price-forecast`

### 📱 Mobile AI Features
- **Camera Integration**: Real-time crop analysis
- **Offline ML**: On-device processing with ML Kit
- **Smart UI**: AI assistant accessible from dashboard
- **Results Display**: Formatted analysis with confidence scores

## API Keys Required

1. **Firebase API Key**: For Genkit services
2. **Google Cloud Service Account**: For Vertex AI
3. **ML Kit**: Automatically included with Google Play Services

## Usage Examples

### Crop Analysis
```dart
final mlService = MLService();
final result = await mlService.analyzeCropImage();
```

### AI Recommendations  
```dart
final apiService = ApiService();
final recommendation = await apiService.getCropRecommendation(
  location: 'Nairobi',
  soilType: 'Clay',
  season: 'Rainy'
);
```

## Cost Considerations

- **ML Kit**: Free tier available
- **Genkit**: Pay per API call
- **Vertex AI**: Pay per prediction
- **Recommended**: Start with free tiers, scale as needed

## Next Steps

1. **Get API Keys**: Set up Firebase and Google Cloud projects
2. **Test Locally**: Use mock data initially
3. **Deploy Models**: Train custom Vertex AI models
4. **Monitor Usage**: Track API costs and performance