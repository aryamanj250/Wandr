import Foundation

class GeminiService {
    static let shared = GeminiService() // Singleton instance

    private init() {}

    func processTextCommand(text: String, apiKey: String, completion: @escaping (Result<ItineraryResponse, Error>) -> Void) {
        guard let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent?key=\(apiKey)") else {
            completion(.failure(GeminiError.invalidURL))
            return
        }

        let prompt = """
        You are a local travel expert for a travel planning app called Wandr.
        Your task is to create a detailed travel itinerary based on user commands.
        The user command will be a transcribed speech text, which might contain
        speech artifacts like "uhm", "like", or conversational fillers.

        Create EXACTLY 5-7 recommendations in JSON format.

        User request: "\(text)"

        Rules:
        - Stay within budget constraints provided in the parsed_command.budget.
        - Mix activity types (food, experiences, sightseeing, travel).
        - Consider travel time and logical flow between locations.
        - If `parsed_command.duration_hours` is provided, ensure the total duration of the itinerary items is within this limit, allowing for a small buffer (e.g., if 12 hours is requested, aim for around 10 hours of activities).
        - Keep descriptions concise (under 50 words per recommendation).
        - Include practical details (timing, booking needs).
        - Return ONLY JSON, no additional text or conversational filler.
        - Ensure the total_estimated_cost is a sum of budget_impact for all itinerary items.

        Response format:
        ```json
        {
          "parsed_command": {
            "location": "string | null",
            "budget": "number | null",
            "duration_hours": "number | null",
            "preferences": "array of strings | null",
            "group_size": "number | null",
            "special_requirements": "string | null"
          },
          "itinerary": [
            {
              "id": "string",
              "day": "number",
              "name": "string",
              "type": "string",
              "location": "string",
              "description": "string",
              "time": "string",
              "rating": "number | null",
              "price_range": "string | null",
              "budget_impact": "number",
              "why_recommended": "string",
              "current_status": "string | null",
              "booking_required": "boolean",
              "notes": "string | null"
            }
          ],
          "total_estimated_cost": "number",
          "timeline_suggestion": "string"
        }
        ```
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
                let decoder = JSONDecoder()
                let geminiResponse = try decoder.decode(GeminiAPIResponse.self, from: data)

                guard let firstCandidate = geminiResponse.candidates.first,
                      let textContent = firstCandidate.content.parts.first?.text else {
                    completion(.failure(GeminiError.invalidResponseFormat))
                    return
                }

                // Extract the JSON string from the markdown block
                let jsonString = textContent.replacingOccurrences(of: "```json\n", with: "")
                                            .replacingOccurrences(of: "\n```", with: "")

                guard let jsonData = jsonString.data(using: .utf8) else {
                    completion(.failure(GeminiError.invalidResponseFormat))
                    return
                }

                let itineraryResponse = try decoder.decode(ItineraryResponse.self, from: jsonData)
                completion(.success(itineraryResponse))
            } catch {
                print("Decoding Error: \(error)")
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw JSON Response: \(jsonString)")
                }
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
