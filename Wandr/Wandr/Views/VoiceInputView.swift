import SwiftUI

struct VoiceInputView: View {
    @ObservedObject var speechManager = SpeechManager()
    @Binding var text: String
    var onSend: (String) -> Void

    var body: some View {
        VStack {
            Text(text.isEmpty ? "Speak now..." : text)
                .font(.title2)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.black.opacity(0.5))
                .cornerRadius(10)
            
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
                    onSend(text)
                    speechManager.stopRecording()
                }) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.title)
                        .foregroundColor(.blue)
                }
            }
        }
        .padding()
        .onAppear {
            speechManager.requestAuthorization()
        }
        .onReceive(speechManager.$transcribedText) { newText in
            self.text = newText
        }
    }
}
