import Foundation

class GeminiService {
    static let shared = GeminiService() // Singleton instance

    private init() {}

    func processTextCommand(text: String, apiKey: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent?key=\(apiKey)") else {
            completion(.failure(GeminiError.invalidURL))
            return
        }

        let prompt = """
        You are an AI assistant for a travel planning app called Wandr.
        Your task is to extract structured travel information from user commands.
        The user command will be a transcribed speech text, which might contain
        speech artifacts like "uhm", "like", or conversational fillers.
        
        Extract the following information and return it as a JSON object.
        If a piece of information is not explicitly mentioned, use `null`.
        
        Expected JSON format:
        {
            "location": "string | null",
            "budget": "number | null",
            "duration_hours": "number | null",
            "preferences": "array of strings | null",
            "group_size": "number | null",
            "special_requirements": "string | null"
        }
        
        Examples of data extraction:
        - "We're in Goa with five thousand rupees each, want some beach vibes and party stuff for eight hours"
          -> { "location": "Goa", "budget": 5000, "duration_hours": 8, "preferences": ["beach vibes", "party"], "group_size": null, "special_requirements": null }
        - "I need a trip for two people to Paris for three days, budget around 2000 euros, looking for cultural sites"
          -> { "location": "Paris", "budget": 2000, "duration_hours": 72, "preferences": ["cultural sites"], "group_size": 2, "special_requirements": null }
        - "Just a quick weekend getaway, something relaxing"
          -> { "location": null, "budget": null, "duration_hours": 48, "preferences": ["relaxing"], "group_size": null, "special_requirements": null }
        
        User command: "\(text)"
        
        Please provide only the JSON output.
        """

        let parameters: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        ["text": prompt]
                    ]
                ]
            ]
        ]

        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            completion(.failure(GeminiError.invalidRequestData))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                let responseBody = data.map { String(data: $0, encoding: .utf8) ?? "N/A" } ?? "N/A"
                completion(.failure(GeminiError.serverError(statusCode: statusCode, responseBody: responseBody)))
                return
            }

            guard let data = data else {
                completion(.failure(GeminiError.noData))
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let candidates = json["candidates"] as? [[String: Any]],
                   let firstCandidate = candidates.first,
                   let content = firstCandidate["content"] as? [String: Any],
                   let parts = content["parts"] as? [[String: Any]],
                   let firstPart = parts.first,
                   let text = firstPart["text"] as? String {
                    completion(.success(text))
                } else {
                    completion(.failure(GeminiError.invalidResponseFormat))
                }
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

enum GeminiError: Error, LocalizedError {
    case invalidURL
    case invalidRequestData
    case serverError(statusCode: Int, responseBody: String)
    case noData
    case invalidResponseFormat

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL for the Gemini API was invalid."
        case .invalidRequestData:
            return "Failed to serialize request data for Gemini API."
        case .serverError(let statusCode, let responseBody):
            return "Gemini API server error: Status Code \(statusCode), Response: \(responseBody)"
        case .noData:
            return "No data received from Gemini API."
        case .invalidResponseFormat:
            return "Invalid response format from Gemini API."
        }
    }
}
