import SwiftUI

struct VoiceInputView: View {
    @ObservedObject var speechManager = SpeechManager()
    @Binding var text: String
    @State private var geminiResponse: String = ""
    @State private var isLoading: Bool = false
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    
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
            } else if !geminiResponse.isEmpty {
                Text("Gemini Response: \(geminiResponse)")
                    .font(.body)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green.opacity(0.5))
                    .cornerRadius(10)
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
                        GeminiService.shared.processTextCommand(text: text, apiKey: geminiAPIKey) { result in
                            DispatchQueue.main.async {
                                isLoading = false
                                switch result {
                                case .success(let responseText):
                                    self.geminiResponse = responseText
                                    // You can also pass this response to the parent view if needed
                                    // onSend(responseText)
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
                geminiResponse = ""
                showError = false
            }
        }
    }
}
