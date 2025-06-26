# Voice Processing Flow - Wandr iOS App

This document details the complete voice processing flow in the Wandr iOS application, from voice input to itinerary display.

## Overview

The Wandr app processes voice commands directly through Google Gemini API without any backend server. The flow is entirely client-side using iOS frameworks and direct API integration.

## Architecture Flow

```
Voice Input → SpeechManager → GeminiService → Google Gemini API → ItineraryResponse → ItineraryView
```

---

## 1. Voice Input Capture (`SpeechManager.swift`)

### **File**: `/Wandr/Wandr/Services/SpeechManager.swift`

The speech manager handles all voice recognition using iOS native frameworks.

### **Key Components**:
- **Framework**: `Speech` and `AVFoundation` 
- **Recognition Engine**: `SFSpeechRecognizer` with English US locale
- **Audio Engine**: `AVAudioEngine` for real-time audio processing

### **Process Flow**:

#### **Authorization** (Lines 22-39):
```swift
func requestAuthorization() {
    SFSpeechRecognizer.requestAuthorization { authStatus in
        // Handle authorization status
    }
}
```

#### **Start Recording** (Lines 41-90):
```swift
func startRecording() {
    guard !isRecording else { return }
    isRecording = true
    transcribedText = ""
    
    // Configure audio session
    let audioSession = AVAudioSession.sharedInstance()
    try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
    
    // Create recognition request
    recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
    recognitionRequest.shouldReportPartialResults = true
    
    // Start recognition task with real-time callback
    recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
        if let result = result {
            self.transcribedText = result.bestTranscription.formattedString
        }
    }
    
    // Install audio tap and start engine
    audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, when in
        self.recognitionRequest?.append(buffer)
    }
    try audioEngine.start()
}
```

### **Published Properties**:
- `@Published var transcribedText: String = ""` - Real-time speech transcription
- `@Published var isRecording: Bool = false` - Recording state

---

## 2. Voice UI Integration (`VoiceGlassOverlay.swift`)

### **File**: `/Wandr/Wandr/Views/VoiceGlassOverlay.swift`

Modern liquid glass overlay that handles the complete voice interaction experience with sophisticated animations and real-time feedback.

### **Key Components**:
- **Speech Manager**: `@ObservedObject var speechManager = SpeechManager()`
- **Gemini API Key**: Hardcoded (line 16): `"AIzaSyDdFD-mjb4IzqVRvh-FTh6wKhURCU_bf9E"`

### **Voice Processing Trigger** (Lines 69-96):
```swift
Button(action: {
    if !text.isEmpty {
        isLoading = true
        showError = false
        errorMessage = ""
        itineraryResponse = nil
        
        // Direct call to Gemini API
        GeminiService.shared.processTextCommand(text: text, apiKey: geminiAPIKey) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let response):
                    self.itineraryResponse = response
                    self.showItineraryView = true
                case .failure(let error):
                    self.showError = true
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    speechManager.stopRecording()
})
```

### **Real-time Text Updates** (Lines 102-109):
```swift
.onReceive(speechManager.$transcribedText) { newText in
    self.text = newText
    if !newText.isEmpty {
        itineraryResponse = nil
        showError = false
    }
}
```

---

## 3. AI Processing (`GeminiService.swift`)

### **File**: `/Wandr/Wandr/Services/GeminiService.swift`

Handles direct integration with Google Gemini 2.0 Flash API for travel itinerary generation.

### **API Configuration**:
- **Endpoint**: `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent`
- **Method**: POST with JSON payload
- **Response**: Structured travel itinerary in JSON format

### **Core Processing Method** (Lines 8-138):
```swift
func processTextCommand(text: String, apiKey: String, completion: @escaping (Result<ItineraryResponse, Error>) -> Void) {
    guard let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent?key=\(apiKey)") else {
        completion(.failure(GeminiError.invalidURL))
        return
    }

    // Sophisticated prompt engineering for travel planning
    let prompt = """
    You are a local travel expert for a travel planning app called Wandr.
    Your task is to create a detailed travel itinerary based on user commands.
    
    Create EXACTLY 5-7 recommendations in JSON format.
    User request: "\(text)"
    
    Rules:
    - Stay within budget constraints
    - Mix activity types (food, experiences, sightseeing, travel)
    - Consider travel time and logical flow
    - Keep descriptions concise (under 50 words)
    - Return ONLY JSON, no additional text
    """

    // API request parameters
    let parameters: [String: Any] = [
        "contents": [
            [
                "parts": [
                    ["text": prompt]
                ]
            ]
        ]
    ]
    
    // HTTP request execution
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        // Handle response and decode to ItineraryResponse
    }.resume()
}
```

### **Response Processing** (Lines 108-128):
```swift
// Decode Gemini API response
let geminiResponse = try decoder.decode(GeminiAPIResponse.self, from: data)

// Extract JSON from markdown code block
let jsonString = textContent.replacingOccurrences(of: "```json\n", with: "")
                            .replacingOccurrences(of: "\n```", with: "")

// Parse structured itinerary data
let itineraryResponse = try decoder.decode(ItineraryResponse.self, from: jsonData)
completion(.success(itineraryResponse))
```

---

## 4. Data Models (`ItineraryModels.swift`)

### **File**: `/Wandr/Wandr/Models/ItineraryModels.swift`

Defines the structured data models for AI responses and travel itineraries.

### **Core Response Model**:
```swift
struct ItineraryResponse: Codable {
    let parsedCommand: ParsedCommand?
    let itinerary: [ItineraryItem]
    let totalEstimatedCost: Double
    let timelineSuggestion: String
}
```

### **Travel Command Parsing**:
```swift
struct ParsedCommand: Codable {
    let location: String?
    let budget: Double?
    let durationHours: Double?
    let preferences: [String]?
    let groupSize: Int?
    let specialRequirements: String?
}
```

### **Individual Itinerary Items**:
```swift
struct ItineraryItem: Codable {
    let id: String
    let day: Int
    let name: String
    let type: String  // "food", "experience", "sightseeing", etc.
    let location: String
    let description: String
    let time: String
    let rating: Double?
    let priceRange: String?
    let budgetImpact: Double
    let whyRecommended: String
    let currentStatus: String?
    let bookingRequired: Bool
    let notes: String?
}
```

---

## 5. Itinerary Display (`ItineraryView.swift`)

### **File**: `/Wandr/Wandr/Views/ItineraryView.swift`

Displays the AI-generated travel itinerary with sophisticated animations and timeline layout.

### **Main Structure** (Lines 19-51):
```swift
var body: some View {
    ZStack {
        Color.black.edgesIgnoringSafeArea(.all)
        
        VStack(spacing: 0) {
            headerView    // Back button, title, share button
            
            ScrollView {
                VStack(spacing: 30) {
                    titleSection      // Location, timeline suggestion, cost
                    timelineView      // Detailed timeline with activities
                }
            }
        }
    }
    .onAppear {
        withAnimation(.easeOut.delay(0.3)) {
            showDetails = true
            headerOpacity = 1.0
            titleScale = 1.0
        }
    }
}
```

### **Title Section** (Lines 119-164):
```swift
private var titleSection: some View {
    VStack(spacing: 16) {
        // Location name from parsed command
        Text(itineraryResponse.parsedCommand?.location ?? "Your Journey")
            .font(.custom("Futura", size: 32))
            .fontWeight(.bold)
        
        // AI-generated timeline suggestion
        Text(itineraryResponse.timelineSuggestion)
            .font(.custom("Futura", size: 16))
            .italic()
        
        // Total estimated cost
        Text("$\(itineraryResponse.totalEstimatedCost, specifier: "%.0f")")
            .font(.custom("Futura", size: 16))
            .fontWeight(.semibold)
    }
}
```

---

## 6. Timeline Component (`TimelineView.swift`)

### **File**: `/Wandr/Wandr/Components/TimelineView.swift`

Creates an animated vertical timeline for displaying itinerary items.

### **Timeline Structure** (Lines 16-45):
```swift
var body: some View {
    VStack(spacing: 0) {
        ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
            let delay = Double(index) * 0.15
            
            TimelineItemView(
                item: item,
                isLast: index == items.count - 1,
                lineProgress: index == 0 ? lineProgress : (showItems ? 1.0 : 0.0),
                delay: delay
            )
            .opacity(showItems ? 1 : 0)
            .offset(y: showItems ? 0 : 30)
            .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(delay), value: showItems)
        }
    }
}
```

### **Individual Timeline Item** (Lines 54-220):
```swift
struct TimelineItemView: View {
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            // Time column with timeline dots and connecting lines
            VStack(spacing: 0) {
                Text(item.time)                    // Time label
                Circle().stroke().frame(width: 20) // Timeline dot
                Rectangle().fill()                 // Connecting line (animated)
            }
            .frame(width: 80)
            
            // Content card with activity details
            VStack(alignment: .leading, spacing: 12) {
                // Activity icon and name
                HStack {
                    Image(systemName: icon(for: item.type))
                    Text(item.name)
                }
                
                // Description and recommendations
                Text(item.whyRecommended)
                Text(item.description)
                
                // Price, rating, booking status
                HStack {
                    Text(item.priceRange ?? "$\(item.budgetImpact)")
                    if let rating = item.rating {
                        HStack {
                            Image(systemName: "star.fill")
                            Text(String(format: "%.1f", rating))
                        }
                    }
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 16).fill(Color.white.opacity(0.05)))
        }
    }
}
```

---

## 7. Legacy Code (Not Used)

### **NetworkService.swift** - Flask Backend Integration (UNUSED)
- File contains leftover code from previous Flask backend implementation
- Methods like `sendTextCommand()` and `pollForCommandResult()` are not used in current flow
- The hardcoded endpoint `http://192.168.1.3:8000/api/v1` is from old architecture

### **MainView.swift** - Contains Mixed Code
- Lines 207-310 contain unused Flask polling logic (`handleVoiceCompletion`, `pollForCommandResult`)
- The actual voice processing now happens directly in `VoiceInputView.swift`
- Voice button UI is functional but doesn't trigger the main processing flow

---

## Current Issues & Cleanup Needed

1. **Mixed Architecture**: `MainView.swift` contains both old Flask code and new UI
2. **Duplicate Voice Logic**: Voice processing exists in both `MainView` and `VoiceInputView`
3. **API Key Security**: Gemini API key is hardcoded and exposed
4. **Unused Files**: `NetworkService.swift` should be removed or refactored

---

## Summary

The actual working flow is:
1. **Voice Input**: `SpeechManager` captures and transcribes speech
2. **AI Processing**: `GeminiService` sends transcribed text directly to Google Gemini API
3. **Data Parsing**: Response is parsed into structured `ItineraryResponse`
4. **UI Display**: `ItineraryView` shows the travel timeline with animations

This is a **client-side only** implementation with no backend server required.