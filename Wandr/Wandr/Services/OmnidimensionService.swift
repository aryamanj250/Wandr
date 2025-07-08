//
//  OmnidimensionError.swift
//  Wandr
//
//  Created by Utsav Balhara on 7/8/25.
//

import Foundation

// Error types for Omnidimension API
enum OmnidimensionError: Error {
    case invalidURL
    case noData
    case apiError(String)
}

// Swift-based Omnidimension API client
class OmnidimensionService {
    static let shared = OmnidimensionService()
    
    private let apiKey: String
    private let baseURL = "https://backend.omnidim.io/api/v1"
    
    // MARK: - Hardcoded Configuration
    private let guestName = "Utsav Balhara"
    private let defaultPartySize = 2
    private var currentDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: Date())
    }
    
    private init() {
        self.apiKey = Secrets.omnidimensionAPIKey
        testOmnidimensionConnectivity()
    }
    
    // MARK: - Core HTTP Client
    
    private func makeRequest(
        method: String,
        endpoint: String,
        parameters: [String: Any]? = nil,
        completion: @escaping (Result<[String: Any], Error>) -> Void
    ) {
        guard let url = URL(string: "\(baseURL)/\(endpoint.trimmingCharacters(in: CharacterSet(charactersIn: "/")))") else {
            completion(.failure(OmnidimensionError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        if let parameters = parameters, method != "GET" {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            } catch {
                completion(.failure(error))
                return
            }
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(OmnidimensionError.noData))
                return
            }
            
            // Debug logging
            if let httpResponse = response as? HTTPURLResponse {
                print("🔍 HTTP Status Code: \(httpResponse.statusCode)")
                print("🔍 Response Headers: \(httpResponse.allHeaderFields)")
            }
            
            if let rawResponse = String(data: data, encoding: .utf8) {
                print("🔍 Raw Response: \(rawResponse)")
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    completion(.success(json))
                } else {
                    completion(.success([:]))
                }
            } catch {
                print("🔍 JSON Parsing Error: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
    
    func testOmnidimensionConnectivity() {
        print("Testing Omnidimension connectivity using Swift HTTP client...")
        
        makeRequest(method: "GET", endpoint: "agents") { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("✅ Successfully connected to Omnidimension API")
                    print("Response: \(response)")
                case .failure(let error):
                    print("❌ Failed to connect to Omnidimension API: \(error)")
                }
            }
        }
    }

    // MARK: - Agent Communication & Status Updates

    func updateUIStatus(agent: String, status: String) {
        print("📊 UI STATUS UPDATE: [\(agent)] \(status)")
        NotificationCenter.default.post(
            name: .agentStatusUpdate,
            object: nil,
            userInfo: ["agent": agent, "status": status]
        )
    }

    // MARK: - Itinerary Processing for Agents

    func sendItineraryToReservationAgent(itineraryResponse: ItineraryResponse) {
        print("\n🚀 OMNIDIMENSION AGENT SYSTEM ACTIVATED")
        print("📨 Sending itinerary to DineRes Assistant Agent...")
        
        // Print the complete itinerary response
        print("🔍 COMPLETE ITINERARY RESPONSE:")
        print("   - Total Estimated Cost: \(itineraryResponse.totalEstimatedCost)")
        print("   - Timeline Suggestion: \(itineraryResponse.timelineSuggestion)")
        print("   - Total items: \(itineraryResponse.itinerary.count)")
        
        if let parsedCommand = itineraryResponse.parsedCommand {
            print("   - Parsed Command:")
            print("     * Location: \(parsedCommand.location ?? "nil")")
            print("     * Budget: \(parsedCommand.budget ?? 0)")
            print("     * Duration Hours: \(parsedCommand.durationHours ?? 0)")
            print("     * Group Size: \(parsedCommand.groupSize ?? 0)")
        }
        
        for (index, item) in itineraryResponse.itinerary.enumerated() {
            print("   - Item \(index + 1):")
            print("     * ID: \(item.id)")
            print("     * Day: \(item.day)")
            print("     * Name: \(item.name)")
            print("     * Type: \(item.type)")
            print("     * Time: \(item.time)")
            print("     * Location: \(item.location)")
            print("     * Description: \(item.description)")
            print("     * Cuisine: \(item.cuisine ?? "nil")")
            print("     * Meal Type: \(item.mealType ?? "nil")")
            print("     * Price Range: \(item.priceRange ?? "nil")")
            print("     * Budget Impact: \(item.budgetImpact ?? 0)")
            print("     * Rating: \(item.rating ?? 0)")
            print("     * Booking Required: \(item.bookingRequired)")
            print("     * Current Status: \(item.currentStatus ?? "nil")")
            print("     * Notes: \(item.notes ?? "nil")")
            print("     * Why Recommended: \(item.whyRecommended)")
        }
        
        updateUIStatus(agent: "DineRes Assistant", status: "Receiving Itinerary...")
        
        // Work directly with the ItineraryResponse object
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.processItineraryForRestaurants(itineraryResponse: itineraryResponse)
        }
    }

    // Store the current itinerary response for accessing parsed command data
    private var currentItineraryResponse: ItineraryResponse?
    
    private func getCurrentPartySize() -> Int? {
        return currentItineraryResponse?.parsedCommand?.groupSize
    }
    
    private func processItineraryForRestaurants(itineraryResponse: ItineraryResponse) {
        // Store the current response for accessing party size later
        self.currentItineraryResponse = itineraryResponse
        
        updateUIStatus(agent: "DineRes Assistant", status: "Processing Itinerary...")
        print("\n🤖 DINERES ASSISTANT AGENT ACTIVATED")
        
        print("🔍 FILTERING FOR FOOD ITEMS:")
        let allItems = itineraryResponse.itinerary
        print("   - Total items before filtering: \(allItems.count)")
        
        for (index, item) in allItems.enumerated() {
            let isFood = item.type.lowercased() == "food"
            print("   - Item \(index + 1): \(item.name) (type: '\(item.type)') -> Food: \(isFood)")
        }
        
        let restaurantItems = allItems.filter { $0.type.lowercased() == "food" }
        print("🔍 Found \(restaurantItems.count) restaurant/food items in itinerary")
        
        print("🔍 RESTAURANT ITEMS TO PROCESS:")
        for (index, item) in restaurantItems.enumerated() {
            print("   - Restaurant \(index + 1): \(item.name)")
            print("     * Time: \(item.time)")
            print("     * Location: \(item.location)")
            print("     * Cuisine: \(item.cuisine ?? "nil")")
            print("     * Meal Type: \(item.mealType ?? "nil")")
        }
        
        // Start making calls sequentially for each restaurant
        sendRestaurantMessagesSequentially(restaurants: restaurantItems, index: 0)
    }
    
    private func sendRestaurantMessagesSequentially(restaurants: [ItineraryItem], index: Int) {
        guard index < restaurants.count else {
            // All calls have been initiated
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let status = "✅ All \(restaurants.count) reservation calls have been initiated."
                self.updateUIStatus(agent: "DineRes Assistant", status: status)
                print("🎉 DineRes Assistant completed its tasks.")
            }
            return
        }
        
        let item = restaurants[index]
        let agentId = 3399 // Your "DineRes Assistant" agent ID
        
        print("🔍 PROCESSING RESTAURANT \(index + 1):")
        print("   - Restaurant Item Details:")
        print("     * ID: \(item.id)")
        print("     * Name: \(item.name)")
        print("     * Time: \(item.time)")
        print("     * Location: \(item.location)")
        print("     * Cuisine: \(item.cuisine ?? "nil")")
        print("     * Meal Type: \(item.mealType ?? "nil")")
        print("     * Type: \(item.type)")
        print("     * Description: \(item.description)")
        print("     * Price Range: \(item.priceRange ?? "nil")")
        print("     * Budget Impact: \(item.budgetImpact ?? 0)")
        print("     * Booking Required: \(item.bookingRequired)")
        
        // Get party size from parsed command, fallback to default
        let partySize = self.getCurrentPartySize() ?? self.defaultPartySize
        
        // Create the call context for the agent
        let callContext: [String: Any] = [
            "restaurant_name": item.name,
            "date": self.currentDate,
            "time": item.time,
            "location": item.location,
            "cuisine": item.cuisine ?? "unspecified cuisine",
            "meal_type": item.mealType ?? "meal",
            "guest_name": self.guestName,
            "party_size": partySize
        ]
        
        print("🔍 CALL CONTEXT CREATED:")
        print("   - Agent ID: \(agentId)")
        print("   - Phone Number: \(Secrets.restaurantBookingPhoneNumber)")
        print("   - Call Context: \(callContext)")
        
        print("📞 Processing reservation \(index + 1): Calling \(item.name)...")
        updateUIStatus(agent: "DineRes Assistant", status: "Calling \(item.name) for a \(item.mealType ?? "meal")...")
        
        // Use the corrected dispatchCall function
        dispatchCall(
            agentId: agentId,
            toNumber: Secrets.restaurantBookingPhoneNumber, // Must include country code
            callContext: callContext
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("✅ Call to \(item.name) initiated successfully!")
                    print("   Response: \(response)")
                    self.updateUIStatus(agent: "DineRes Assistant", status: "✅ Call placed to \(item.name).")
                    
                    // If we have a call ID, retrieve the call log after a delay
                    if let callId = response["call_id"] as? String {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 30.0) { // Wait 30 seconds before checking logs
                            self.getCallLog(callLogId: callId) { logResult in
                                switch logResult {
                                case .success(let log):
                                    print("📋 Call log for \(item.name): \(log)")
                                case .failure(let error):
                                    print("❌ Failed to retrieve call log: \(error)")
                                }
                            }
                        }
                    }
                    
                case .failure(let error):
                    print("❌ Failed to initiate call to \(item.name): \(error.localizedDescription)")
                    self.updateUIStatus(agent: "DineRes Assistant", status: "❌ Call failed for \(item.name).")
                }
                
                // Trigger the next call in the sequence
                self.sendRestaurantMessagesSequentially(restaurants: restaurants, index: index + 1)
            }
        }
    }
}

// MARK: - Corrected Call API Functions
extension OmnidimensionService {
    
    // Dispatch a call using the correct API format
    func dispatchCall(
        agentId: Int,
        toNumber: String,
        callContext: [String: Any]? = nil,
        completion: @escaping (Result<[String: Any], Error>) -> Void
    ) {
        let endpoint = "calls/dispatch" // Correct endpoint from curl docs
        var parameters: [String: Any] = [
            "agent_id": agentId,
            "to_number": toNumber
        ]
        
        if let context = callContext {
            parameters["call_context"] = context
        }
        
        makeRequest(method: "POST", endpoint: endpoint, parameters: parameters) { result in
            switch result {
            case .success(let response):
                if let error = response["error"] as? String {
                    completion(.failure(OmnidimensionError.apiError(error)))
                } else {
                    completion(.success(response))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // Get call logs with pagination and optional filtering
    func getCallLogs(
        page: Int = 1,
        pageSize: Int = 10,
        agentId: Int? = nil,
        completion: @escaping (Result<[String: Any], Error>) -> Void
    ) {
        var endpoint = "calls/logs?pageno=\(page)&pagesize=\(pageSize)"
        
        if let agentId = agentId {
            endpoint += "&agentid=\(agentId)"
        }
        
        makeRequest(method: "GET", endpoint: endpoint, parameters: nil, completion: completion)
    }
    
    // Get detailed information about a specific call log
    func getCallLog(
        callLogId: String,
        completion: @escaping (Result<[String: Any], Error>) -> Void
    ) {
        let endpoint = "calls/logs/\(callLogId)"
        makeRequest(method: "GET", endpoint: endpoint, completion: completion)
    }
}

// MARK: - Helper Function to Retrieve Recent Call Logs
extension OmnidimensionService {
    
    // Retrieve and display recent call logs for monitoring
    func displayRecentCallLogs(for agentId: Int? = nil) {
        getCallLogs(page: 1, pageSize: 10, agentId: agentId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("\n📞 Recent Call Logs:")
                    if let logs = response["logs"] as? [[String: Any]] {
                        for (index, log) in logs.enumerated() {
                            print("  \(index + 1). Call ID: \(log["id"] ?? "Unknown")")
                            print("     Status: \(log["status"] ?? "Unknown")")
                            print("     Duration: \(log["duration"] ?? "Unknown") seconds")
                            print("     Date: \(log["created_at"] ?? "Unknown")")
                            print("     ---")
                        }
                    }
                case .failure(let error):
                    print("❌ Failed to retrieve call logs: \(error)")
                }
            }
        }
    }
}

// Notification names for agent status updates
extension Notification.Name {
    static let agentStatusUpdate = Notification.Name("agentStatusUpdate")
}
