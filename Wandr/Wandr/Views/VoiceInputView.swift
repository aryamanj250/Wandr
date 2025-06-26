import SwiftUI

import SwiftUI

struct VoiceInputView: View {
    @ObservedObject var speechManager = SpeechManager()
    @Binding var text: String
    @State private var itineraryResponse: ItineraryResponse? = nil // Changed type to ItineraryResponse
    @State private var isLoading: Bool = false
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var showItineraryView: Bool = false // New state to control presentation
    
    // TODO: Securely load API key, e.g., from environment variables or a secure configuration
    // For demonstration, it's hardcoded. In a real app, use a more secure method.
    private let geminiAPIKey = "AIzaSyDdFD-mjb4IzqVRvh-FTh6wKhURCU_bf9E" // Gemini API Key

    var body: some View {
        VStack {
            Text(text.isEmpty ? "Speak now..." : text)
                .font(.title2)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.black.opacity(0.5))
                .cornerRadius(10)
            
            if isLoading {
                ProgressView("Processing...")
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .padding()
            } else if let response = itineraryResponse { // Check for ItineraryResponse
                Text("Itinerary generated for \(response.parsedCommand?.location ?? "your trip")!")
                    .font(.body)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green.opacity(0.5))
                    .cornerRadius(10)
                    .onTapGesture {
                        showItineraryView = true // Show ItineraryView on tap
                    }
            } else if showError {
                Text("Error: \(errorMessage)")
                    .font(.body)
                    .foregroundColor(.red)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red.opacity(0.5))
                    .cornerRadius(10)
            }
            
            HStack {
                Button(action: {
                    if speechManager.isRecording {
                        speechManager.stopRecording()
                    } else {
                        speechManager.startRecording()
                    }
                }) {
                    Image(systemName: speechManager.isRecording ? "mic.fill" : "mic.slash.fill")
                        .font(.title)
                        .padding()
                        .background(speechManager.isRecording ? Color.red : Color.gray)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }

                Button(action: {
                    if !text.isEmpty {
                        isLoading = true
                        showError = false
                        errorMessage = ""
                        itineraryResponse = nil // Clear previous response
                        GeminiService.shared.processTextCommand(text: text, apiKey: geminiAPIKey) { result in
                            DispatchQueue.main.async {
                                isLoading = false
                                switch result {
                                case .success(let response): // Changed to 'response' of type ItineraryResponse
                                    self.itineraryResponse = response
                                    self.showItineraryView = true // Automatically show ItineraryView on success
                                    OmnidimensionService.shared.sendItineraryToReservationAgent(itineraryResponse: response)
                                case .failure(let error):
                                    self.showError = true
                                    self.errorMessage = error.localizedDescription
                                }
                            }
                        }
                    }
                    speechManager.stopRecording()
                }) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.title)
                        .foregroundColor(.blue)
                }
                .disabled(text.isEmpty || isLoading)
            }
        }
        .padding()
        .onAppear {
            speechManager.requestAuthorization()
        }
        .onReceive(speechManager.$transcribedText) { newText in
            self.text = newText
            // Clear previous Gemini response when new speech input starts
            if !newText.isEmpty {
                itineraryResponse = nil // Clear itinerary response
                showError = false
            }
        }
        .fullScreenCover(isPresented: $showItineraryView) {
            if let response = itineraryResponse {
                ItineraryView(itineraryResponse: response, isShowing: $showItineraryView)
            }
        }
    }
}
